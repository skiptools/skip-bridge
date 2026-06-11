// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
@_exported import SwiftJNI
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Android)
import Android
#endif

/// That this needs to be manually loaded with `System.loadLibrary("SwiftJNI")` in order to have `JNI_OnLoad` called.
///
/// A dynamic library that loads another dynamic library will *not* have `JNI_OnLoad` automatically called.
///
/// The alternative is to `dlsym("JNI_GetCreatedJavaVMs")` from the right shared object file (e.g., `libnativehelper.so` in recent Android APIs), but this is much easier.
@_silgen_name("JNI_OnLoad")
public func JNI_OnLoad(jvm: UnsafeMutablePointer<JavaVM?>, reserved: UnsafeMutableRawPointer) -> JavaInt {
    JNI.jni = JNI(jvm: jvm)
    if JNI.jni == nil {
        fatalError("SwiftJNI: global jni variable was nil after JNI_OnLoad")
    }

    AnyBridging.initJThrowableErrorConverter()

    #if !os(Android)
    // Being loaded by a JVM on a development OS means we are hosted by a test JVM
    // (Robolectric unit tests or an embedded test JVM), where bridged main-actor API is
    // called from JVM test threads that can never satisfy the Darwin main-queue assertion.
    isJVMHostedEnvironment = true
    installJVMHostedCheckIsolatedHook()
    #endif

    return JavaInt(0x00010006) // JNI_VERSION_1_6
}

#if !os(Android)
/// Whether this library was loaded by a JVM on a development OS (Robolectric unit tests or
/// an embedded test JVM) rather than running on Android. Set by `JNI_OnLoad`, before any
/// bridged call can execute. Read by `assumeMainActorUnchecked` to relax main-actor
/// assumptions that JVM test threads can never satisfy.
nonisolated(unsafe) var isJVMHostedEnvironment = false

/// Relax `MainActor.assumeIsolated` for JVM-hosted test environments.
///
/// On Android the main looper drains the dispatch main queue, so the main-actor assumptions
/// made by bridged calls hold on the UI thread. A JVM hosted on macOS or Linux has no such
/// integration: Robolectric runs everything on a JVM test thread, which is never the platform
/// main dispatch queue, so the last-resort `checkIsolated` runtime check would trap on the
/// first bridged call into `@MainActor` API. Installing a no-op
/// `swift_task_checkIsolated_hook` makes the runtime treat that check as satisfied.
/// Robolectric tests are effectively single-threaded, so the assumption is sound in practice.
///
/// On host runtimes that predate the hook (macOS 14 and earlier), this is a no-op; the
/// `isJVMHostedEnvironment` bypass in `assumeMainActorUnchecked` covers those.
private func installJVMHostedCheckIsolatedHook() {
    #if canImport(Darwin)
    let defaultHandle = UnsafeMutableRawPointer(bitPattern: -2) // RTLD_DEFAULT
    #else
    let defaultHandle: UnsafeMutableRawPointer? = nil // RTLD_DEFAULT
    #endif
    guard let hook = dlsym(defaultHandle, "swift_task_checkIsolated_hook") else {
        return
    }
    // The hook is `SWIFT_CC(swift) (SerialExecutorRef, original) -> Void`: two register words
    // plus the original-function pointer, all ignored by the no-op, so a C-convention
    // function with matching register usage is ABI-compatible.
    let noop: @convention(c) (UnsafeRawPointer?, UnsafeRawPointer?, UnsafeRawPointer?) -> Void = { _, _, _ in }
    hook.assumingMemoryBound(to: UnsafeRawPointer?.self).pointee = unsafeBitCast(noop, to: UnsafeRawPointer?.self)
}
#endif

extension JNI {
    /// In order to use JNI to access the Swift side of the bridge, we need to first manually load the library.
    /// This only works on macOS; Android will need to load the .so from the embedded jni library path.
    ///
    /// When searching for the library to load, there are four scenarios we need to handle,
    /// each of which has different paths that need to be searched:
    ///
    /// 1. Xcode-launched Swift tests where the embedded JVM needs to load the Xcode-created library ("SkipBridgeSamples.framework/SkipBridgeSamples")
    /// 2. Xcode-launched Skip gradle tests, where gradle's JVM needs to load the Xcode created-library ("SkipBridgeSamples.framework/SkipBridgeSamples")
    /// 3. SwiftPM-launched Swift tests where the embedded JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
    /// 4. SwiftPM-launched Skip gradle tests, where gradle's JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
    public static func loadLibrary(packageName: String, moduleName libName: String) throws {
        let libName_java = libName.toJavaParameter(options: [])
        try Java_systemClass.get().callStatic(method: Java_loadLibrary_methodID.get(), options: [], args: [libName_java])
    }
}

private let Java_systemClass = Result { try JClass(name: "skip.bridge.SystemKt") }
private let Java_loadLibrary_methodID = Result { try Java_systemClass.get().getStaticMethodID(name: "loadLibrary", sig: "(Ljava/lang/String;)V")! }


#if SKIP

/// The libraries we have already loaded, so we don't try to load them again
private var loadedLibraries: Set<String> = []

/// In order to use JNI to access the Swift side of the bridge, we need to first manually load the library.
/// This only works on macOS; Android will need to load the .so from the embedded jni library path.
///
/// When searching for the library to load, there are four scenarios we need to handle,
/// each of which has different paths that need to be searched:
///
/// 1. Xcode-launched Swift tests where the embedded JVM needs to load the Xcode-created library ("SkipBridgeSamples.framework/SkipBridgeSamples")
/// 2. Xcode-launched Skip gradle tests, where gradle's JVM needs to load the Xcode created-library ("SkipBridgeSamples.framework/SkipBridgeSamples")
/// 3. SwiftPM-launched Swift tests where the embedded JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
/// 4. SwiftPM-launched Skip gradle tests, where gradle's JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
// SKIP @nobridge
public func loadPeerLibrary(packageName: String, moduleName libName: String) throws {
    let env = System.getenv()
    //print("System.getenv(): \(env.toSortedMap())")

    // Xcode output for dynamic library
    // user.dir: ~/Developer/Xcode/DerivedData/ProjectName/SourcePackages/plugins/skip-jni.output/SkipBridgeSamplesTests/skipstone/SkipBridgeSamples
    // framework dylib: ~/Library/Developer/Xcode/DerivedData/ProjectName/Build/Products/Debug/PackageFrameworks/SkipBridgeSamples.framework/Versions/A/SkipBridgeSamples

    // XCTestBundlePath=/Users/marc/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/Build/Products/Debug/SkipBridgeSamplesTests.xctest

    // on an Android device this will be something like "google/sdk_gphone64_arm64/emu64a:14/UE1A.230829.050/12077443:userdebug/dev-keys"
    let isRobolectric = android.os.Build.FINGERPRINT == "robolectric" || android.os.Build.FINGERPRINT == nil

    if !isRobolectric {
        // we are running on Android, which means the library is packaged with the APK, so we should be able to simply load it by name
        System.loadLibrary(libName)
        return
    }

    // running in Robolectric means we have to search around the file system for where the .dylib is output
    let osName = System.getProperty("os.name")
    let osArch = System.getProperty("os.arch")
    let libext: String
    let arch: String
    if osName.lowercase().contains("linux") {
        libext = "so"
        arch = osArch == "aarch64" ? "aarch64-unknown-linux-gnu" : "x86_64-unknown-linux-gnu"
    } else {
        libext = "dylib"
        arch = osArch == "aarch64" ? "arm64-apple-macosx" : "x86_64-apple-macosx"
    }
    let sharedObject = "lib\(libName).\(libext)"
    let libPath = ".build/\(libName)/swift/\(arch)/debug/\(sharedObject)"

    let cwd = System.getProperty("user.dir")

    var libraryPath: String
    if let testBundlePath = env["XCTestBundlePath"] { // running from within an Xcode test case, the XCTestBundlePath points to somewhere like: ~/Library/Developer/Xcode/DerivedData/*-*/Build/Products/Debug/SkipBridgeSamplesTests.xctest
        // cwd from Xcode: /Users/marc/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/SourcePackages/plugins/skip-bridge.output/SkipBridgeSamplesTests/skipstone
        // libraryPath = cwd + "/../../../\(libName)/skipstone/\(libName)/" + libPath
        libraryPath = cwd + "/" + libPath
    } else {
        // need to update for forked swift build output

        // cwd from swiftPM CLI: /opt/src/github/skiptools/skip-bridge/.build/plugins/outputs/skip-bridge/SkipBridgeSamplesTests/destination/skipstone/SkipBridgeSamples
        libraryPath = cwd + "/" + libPath
    }

    if loadedLibraries.contains(libraryPath) {
        print("note: already loaded library: \(libraryPath)")
        return
    } else if !java.io.File(libraryPath).isFile() {
        // load the native library that contains the function implementations
        error("error: missing library: \(libraryPath)")
    } else {
        print("note: loading library: \(libraryPath)")
        System.load(libraryPath)
        print("note: loaded library: \(libraryPath)")
        loadedLibraries.insert(libraryPath)
    }
}

#endif
