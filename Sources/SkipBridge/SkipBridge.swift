// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// MARK: loadLibrary

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
    try! Java_fileClass.callStatic(method: Java_loadLibrary_methodID, args: [libName_java])
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

// MARK: SwiftObjectPointer

/// An opaque reference to a Swift object.
public typealias SwiftObjectPointer = Int64
public let SwiftObjectNil = Int64(0)

#if !SKIP

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
private let Java_SwiftPeerBridged_class = try! JClass(name: "skip/bridge/SwiftPeerBridged")
private let Java_SwiftPeerBridged_peer_methodID = Java_SwiftPeerBridged_class.getMethodID(name: "Swift_bridgedPeer", sig: "()J")!

#else

/// Protocol added to the generated class for a Swift type bridged to Kotlin.
public protocol SwiftPeerBridged {
    func Swift_bridgedPeer() -> SwiftObjectPointer
}

/// Marker type used to guarantee uniqueness of our `Swift_peer` constructor.
public final class SwiftPeerMarker {
}

#endif

// MARK: Closures

#if !SKIP

//~~~ Single class for all arities?
//~~~ Handle void?
//~~~ Do we need all this to be public?

/// A Swift object that is backed by a Java closure in the form of a `kotlin.jvm.functions.FunctionN` object.
public final class JavaBackedClosure1<R>: JObject where R: JConvertible {
    /// Invoke the underlying closure.
    public func invoke(_ p0: JConvertible) throws -> R {
        let p0_java = p0.toJavaObject().toJavaParameter()
        //~~~ handle non-object return types?
        return try call(method: Java_Function1_invoke_methodID, args: [p0_java])
    }
}
private let Java_Function1_class = try! JClass(name: "kotlin/jvm/functions/Function1")
private let Java_Function1_invoke_methodID = Java_Function1_class.getMethodID(name: "invoke", sig: "(Ljava/lang/Object;)Ljava/lang/Object;")!

/// A Swift class that houses a closure.
///
/// This class can perform argument conversions and allows us to reference it with a `SwiftObjectPointer`.
public final class SwiftClosure1 {
    /// Create a Java closure in the form of a `kotlin.jvm.functions.FunctionN` backed by a Swift closure.
    public static func javaObject<P0, R>(for closure: @escaping (P0) -> R) -> JavaObjectPointer {
        let swiftPeer = SwiftClosure1(p0Type: P0.self) { p0 in
            return closure(p0 as! P0)
        }
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction1_class.create(ctor: Java_SwiftBackedFunction1_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public let closure: (Any) -> Any
    public let p0Type: Any.Type

    public init(p0Type: Any.Type, closure: @escaping (Any) -> Any) {
        self.p0Type = p0Type
        self.closure = closure
    }
}
private let Java_SwiftBackedFunction1_class = try! JClass(name: "skip/bridge/SwiftBackedFunction1")
private let Java_SwiftBackedFunction1_constructor_methodID = Java_SwiftBackedFunction1_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_SwiftBackedFunction1_Swift_1release")
func SwiftBackedFunction1_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure1.self)
}
@_cdecl("Java_skip_bridge_SwiftBackedFunction1_Swift_1invoke")
func SwiftBackedFunction1_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer) -> JavaObjectPointer {
    let value_swift: SwiftClosure1 = Swift_peer.pointee()!
    let p0_swift = try! (value_swift.p0Type as! JConvertible.Type).fromJavaObject(p0)
    let c_return_swift = value_swift.closure(p0_swift) as! JConvertible
    return c_return_swift.toJavaObject()!
}

#else

/// A Swift-backed `kotlin.jvm.functions.FunctionN` type.
public final class SwiftBackedFunction1<P0, R>: kotlin.jvm.functions.Function1<P0, R> {
    private var Swift_peer: SwiftObjectPointer

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func invoke(_ p0: P0) -> R {
        return Swift_invoke(Swift_peer, p0 as! Any) as! R
    }
    // SKIP EXTERN
    private func Swift_invoke(Swift_peer: SwiftObjectPointer, p0: Any) -> Any
}

#endif
