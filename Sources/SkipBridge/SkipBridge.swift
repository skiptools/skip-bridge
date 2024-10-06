// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
let Java_fileClass = try! JClass(name: "skip.bridge.SkipBridgeKt")
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
public typealias SwiftObjectPointer = Int64
public let SwiftObjectNil = Int64(0)

#if SKIP
/// Protocol added to the generated class for a Swift type bridged to Kotlin.
public protocol SwiftPeerBridged {
    var Swift_peer: SwiftObjectPointer { get }
}

/// Marker type used to guarantee uniqueness of our `Swift_peer` constructor.
public final class SwiftPeerMarker {
}

#else

extension SwiftObjectPointer {
    /// Get a pointer to the given object.
    public static func pointer<T: AnyObject>(to object: T?, retain: Bool) -> SwiftObjectPointer {
        guard let object else {
            return SwiftObjectNil
        }
        let unmanaged = retain ? Unmanaged.passRetained(object) : Unmanaged.passUnretained(object)
        let rawPtr = unmanaged.toOpaque()
        return SwiftObjectPointer(Int(bitPattern: rawPtr))
    }

    /// Return the object for this pointer.
    public func pointee<T: AnyObject>() -> T? {
        guard self != SwiftObjectNil else {
            return nil
        }
        let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self))!
        return Unmanaged<T>.fromOpaque(rawPtr).takeUnretainedValue()
    }

    /// Increment the reference count for a Swift object held by Java.
    public func retained<T: AnyObject>(as type: T.Type) -> SwiftObjectPointer {
        guard self != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self)) else {
            return self
        }
        let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
        let refUnmanaged = unmanaged.retain()
        return SwiftObjectPointer(Int(bitPattern: refUnmanaged.toOpaque()))
    }

    /// Decrement the reference count for a Swift object held by Java.
    public func release<T: AnyObject>(as type: T.Type) {
        guard self != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self)) else {
            return
        }
        let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
        unmanaged.release()
    }
}

extension SwiftObjectPointer {
    /// Return the `Swift_peer` of the given `SwiftPeerBridged` object.
    public static func peer(of bridged: JavaObjectPointer) -> SwiftObjectPointer {
        return try! SwiftObjectPointer.call(Java_SwiftPeerBridged_peer_methodID, on: bridged, args: [])
    }
}
private let Java_SwiftPeerBridged_class = try! JClass(name: "skip.bridge.SwiftPeerBridged")
private let Java_SwiftPeerBridged_peer_methodID = Java_SwiftPeerBridged_class.getMethodID(name: "getSwift_Peer", sig: "()J")!

#endif
