// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipBridge

extension SwiftURLBridge {
    public convenience init() throws {
        #if !SKIP
        self.init(javaPeer: nil)
        self._javaPeer = try createJavaPeer()
        #else
        super.init(swiftPeer: SWIFT_NULL)
        loadPeerLibrary("SkipBridgeSamples")
        self._swiftPeer = createSwiftURLBridge()
        #endif
    }
}

#if !SKIP
import SkipJNI

// skipstone-generated Swift

extension SwiftURLBridge : SkipReferenceBridgable {
    public static let javaClass = try! JClass(name: "skip.bridge.samples.SwiftURLBridge")

    /// Call from Swift into Java using JNI
    public func invokeJavaVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws {
        fatalError("SwiftURLBridge does not have any bridged Java functions")
    }

    /// Call from Swift into Java using JNI
    public func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
        fatalError("SwiftURLBridge does not have any bridged Java functions")
    }

    /// Call from Swift into a static Java function using JNI
    public static func invokeJavaStatic<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
        fatalError("SwiftURLBridge does not have any bridged static Java functions")
    }

    /// Call from Swift into a static Java function using JNI
    public static func invokeJavaStaticVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws {
        fatalError("SwiftURLBridge does not have any bridged static Java functions")
    }
}
#endif

// MARK: skipstone-generated JNI bridging

#if SKIP
extension SwiftURLBridge {
    /* SKIP EXTERN */ public func createSwiftURLBridge() -> Int64 { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_createSwiftURLBridge")
internal func Java_skip_bridge_samples_SwiftURLBridge_createSwiftURLBridge(_ env: JNIEnvPointer, _ obj: JavaObjectPointer) -> Int64 {
    registerSwiftBridge(SwiftURLBridge(javaPeer: obj), retain: true)
}
#endif


#if SKIP
extension SwiftURLBridge {
    /* SKIP EXTERN */ public func invokeSwift_setURLString(_ swiftPeer: SwiftObjectPointer, _ value: String) { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1setURLString__JLjava_lang_String_2")
internal func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1setURLString__JLjava_lang_String_2(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong, _ urlString: JavaString?) {
    do {
        let bridge: SwiftURLBridge = swiftPeer(for: swiftPointer)
        try bridge.setURLString(String.fromJavaObject(urlString))
    } catch {
        // `@_cdecl` JNI functions cannot throw errors, so instead we add the current error to the thread's error stack, which we will check after invoking the function
        pushSwiftError(error)
    }
}
#endif


#if SKIP
extension SwiftURLBridge {
    /* SKIP EXTERN */ public func invokeSwift_isFileURL(_ swiftPeer: SwiftObjectPointer) -> Bool { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL__J")
internal func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL__J(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong) -> Bool {
    let bridge: SwiftURLBridge = swiftPeer(for: swiftPointer)
    return bridge.isFileURL()
}
#endif


#if SKIP
extension SwiftURLBridge {
    /* SKIP EXTERN */ public func invokeSwift_toJavaFileBridge(_ swiftPeer: SwiftObjectPointer) -> JavaFileBridge { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1toJavaFileBridge__J")
internal func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1toJavaFileBridge__J(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong) -> JavaObjectPointer? {
    return handleSwiftError {
        let bridge: SwiftURLBridge = swiftPeer(for: swiftPointer)
        // return try JavaFileBridge(filePath: bridge.url.path).toJavaObject() // FIXME: this immediately releases the Swift JavaFileBridge, which invalidates the JavaObject peer that was just created…
        let fb = JavaFileBridge(javaPeer: obj) // …so we need to create it with a bogus peer (wrong class) in order to mark the instance as having been created from the Java side
        fb._javaPeer = try fb.createJavaPeer()
        try fb.setFilePath(bridge.url.path)
        return fb.toJavaObject()
    } ?? nil
}
#endif


#if SKIP
extension SwiftURLBridge {
    /* SKIP EXTERN */ public static func invokeSwift_host(forURL: String) -> String? { }
}
#else
/// `skip.bridge.samples.SwiftURLBridge$Companion.invokeSwift_host()`
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_00024Companion_invokeSwift_1host__Ljava_lang_String_2")
internal func Java_skip_bridge_samples_SwiftURLBridge_00024Companion_invokeSwift_1host__Ljava_lang_String_2(_ env: JNIEnvPointer, _ cls: JavaClassPointer?, _ url: JavaString) -> JavaString? {
    SwiftURLBridge.host(forURL: try! String.fromJavaObject(url))?.toJavaObject()
}
#endif


#if SKIP
extension SwiftURLBridge {
    /* SKIP EXTERN */ public static func invokeSwift_fromJavaFileBridge(fileBridge: JavaFileBridge) -> SwiftURLBridge { }
}
#else
/// `skip.bridge.samples.SwiftURLBridge$Companion.invokeSwift_fromJavaFileBridge(skip.bridge.samples.JavaFileBridge)`
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_00024Companion_invokeSwift_1fromJavaFileBridge__Lskip_bridge_samples_JavaFileBridge_2")
internal func Java_skip_bridge_samples_SwiftURLBridge_00024Companion_invokeSwift_1fromJavaFileBridge__Lskip_bridge_samples_JavaFileBridge_2(_ env: JNIEnvPointer, _ cls: JavaClassPointer?, _ fileBridge: JavaObjectPointer?) -> JavaObjectPointer? {
    handleSwiftError {
        // get the JavaFileBridge's Swift peer, invoke toSwiftURLBridge(), and return the Java peer for the result
        try JavaFileBridge.fromJavaObject(fileBridge).toSwiftURLBridge().toJavaObject()
    } ?? nil
}
#endif


//#if SKIP
//extension SwiftURLBridge {
//    /* SKIP EXTERN */ public func invokeSwift_readContents(_ swiftPeer: SwiftObjectPointer, _ callback: JavaCallback) { }
//}
//#else
//@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1readContents__JLskip_bridge_JavaCallback_2")
//internal func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1readContents__JLskip_bridge_JavaCallback_2(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong, _ callbackPointer: JavaObjectPointer) {
//    let bridge: SwiftURLBridge = swiftPeer(for: swiftPointer)
//    print("### bridge: \(bridge)")
//    handleSwiftError {
//        let cb = try! JavaCallback.fromJavaObject(callbackPointer)
//        print("### callback: \(cb)")
//        try! cb.callback("ABCX")
//
////        Task {
////            let contents = try await bridge.readContents()
////            print("### contents: \(contents)")
////            cb.callback(contents)
////        }
//    }
//}
//#endif
