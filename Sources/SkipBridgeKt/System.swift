// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
    if osName.toLowerCase().contains("linux") {
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
