// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import SkipJNI

let Java_fileClass = try! JClass(name: "skip.bridge2.SkipBridgeKt")
let Java_loadLibrary_methodID = Java_fileClass.getStaticMethodID(name: "loadLibrary", sig: "(Ljava/lang/String;)V")!
#endif

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
public func loadLibrary(_ libName: String) {
    #if !SKIP
    let libName_java = libName.toJavaParameter()
    try! Java_fileClass.callStatic(method: Java_loadLibrary_methodID, [libName_java])
    #else
    // Xcode output for dynamic library
    // user.dir: ~/Developer/Xcode/DerivedData/ProjectName/SourcePackages/plugins/skip-jni.output/SkipBridgeSamplesTests/skipstone/SkipBridgeSamples
    // framework dylib: ~/Library/Developer/Xcode/DerivedData/ProjectName/Build/Products/Debug/PackageFrameworks/SkipBridgeSamples.framework/Versions/A/SkipBridgeSamples

    // XCTestBundlePath=/Users/marc/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/Build/Products/Debug/SkipBridgeSamplesTests.xctest
    var libraryPath: String
    if let testBundlePath = System.getenv()["XCTestBundlePath"] { // running from within Xcode
        libraryPath = testBundlePath + "/../PackageFrameworks/\(libName).framework/Versions/A/\(libName)"
    } else {
        let cwd = System.getProperty("user.dir")
        // from gradle: /opt/src/github/skiptools/skip-jni/.build/plugins/outputs/skip-jni/SkipBridgeSamplesTests/skipstone
        // from swiftPM CLI: /opt/src/github/skiptools/skip-jni
        let dylib = "lib\(libName).dylib"
        let arch = System.getProperty("os.arch") == "aarch64" ? "arm64-apple-macosx" : "x86_64-apple-macosx"
        libraryPath = cwd + "/.build/\(arch)/debug/\(dylib)" // Swift-launched JVM
        if !java.io.File(libraryPath).isFile() {
            libraryPath = cwd + "/../../../../../../\(arch)/debug/\(dylib)" // gradle-launched JVM
        }
    }

    // load the native library that contains the function implementations
    if !java.io.File(libraryPath).isFile() {
        print("warning: missing library: \(libraryPath)")
    } else {
        print("note: loading library: \(libraryPath)")
        System.load(libraryPath)
        print("note: loaded library: \(libraryPath)")
    }
    #endif
}

/// An opaque reference to a Swift object.
public typealias SwiftObjectPtr = Int64
public let SwiftObjectNil = Int64(0)

#if !SKIP
extension SwiftObjectPtr {
    /// Get a pointer to the given object.
    public static func forSwift<T: AnyObject>(_ obj: T, retain: Bool) -> SwiftObjectPtr {
        let unmanaged = retain ? Unmanaged.passRetained(obj) : Unmanaged.passUnretained(obj)
        let rawPtr = unmanaged.toOpaque()
        return SwiftObjectPtr(Int(bitPattern: rawPtr))
    }

    /// Return the object for this pointer.
    public func toSwift<T: AnyObject>() -> T {
        assert(self != SwiftObjectNil, "SkipBridge.toSwift() called on nil pointer")
        let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self))!
        return Unmanaged<T>.fromOpaque(rawPtr).takeUnretainedValue()
    }
}

/// Increment the reference count for a Swift object held by Java.
public func refSwift<T: AnyObject>(_ ptr: SwiftObjectPtr, type: T.Type) -> SwiftObjectPtr {
    guard ptr != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(ptr)) else {
        return ptr
    }
    let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
    let refUnmanaged = unmanaged.retain()
    return SwiftObjectPtr(Int(bitPattern: refUnmanaged.toOpaque()))
}

/// Decrement the reference count for a Swift object held by Java.
public func derefSwift<T: AnyObject>(_ ptr: SwiftObjectPtr, type: T.Type) {
    guard ptr != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(ptr)) else {
        return
    }
    let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
    unmanaged.release()
}
#endif
