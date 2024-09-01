import SkipBridge
#if !SKIP
import SkipJNI

// skipstone-generated Swift

extension SwiftURLBridge : SkipReferenceBridgable {
    public static let javaClass = try! JClass(name: "skip.bridge.samples.SwiftURLBridge")

    public func toJavaObject() -> JavaObjectPointer? {
        try? javaPeer
    }

    /// Call from Swift into Java using JNI
    public func invokeJavaVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws {
        fatalError("SwiftURLBridge does not have any bridged Java functions")
    }

    /// Call from Swift into Java using JNI
    public func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
        fatalError("SwiftURLBridge does not have any bridged Java functions")
    }
}
#endif

// MARK: skipstone-generated JNI bridging

#if SKIP
public extension SwiftURLBridge {
    internal func withSwiftBridge<T>(function: () -> T) -> T {
        if _swiftPeer == Long(0) {
            loadPeerLibrary("SkipBridgeSamples") // ensure the shared library containing the native implementations is loaded
            // create the Swift peer for this Java instance
            _swiftPeer = createSwiftURLBridge()
        }

        return function()
    }

    /* SKIP EXTERN */ func createSwiftURLBridge() -> Int64 { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_createSwiftURLBridge")
internal func Java_skip_bridge_samples_SwiftURLBridge_createSwiftURLBridge(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?) -> Int64 {
    registerSwiftBridge(SwiftURLBridge())
}
#endif

#if SKIP
public extension SwiftURLBridge {
    /* SKIP EXTERN */ func invokeSwift_setURLString(_ swiftPeer: Long, _ value: String) { }
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
public extension SwiftURLBridge {
    /* SKIP EXTERN */ func invokeSwift_isFileURL(_ swiftPeer: Long) -> Bool { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL__J")
internal func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL__J(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong) -> Bool {
    let bridge: SwiftURLBridge = swiftPeer(for: swiftPointer)
    return bridge.isFileURL()
}
#endif

#if SKIP
public extension SwiftURLBridge {
    /* SKIP EXTERN */ public func invokeSwift_toJavaFileBridge(_ swiftPeer: Long) -> JavaFileBridge { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1toJavaFileBridge__J")
internal func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1toJavaFileBridge__J(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong) -> JavaObjectPointer? {
    return handleSwiftError {
        let bridge: SwiftURLBridge = swiftPeer(for: swiftPointer)
        return try JavaFileBridge(filePath: bridge.url.path).toJavaObject()
    } ?? nil
}
#endif


#if SKIP
public extension SwiftURLBridge {
    /* SKIP EXTERN */ public static func invokeSwift_fromJavaFileBridge(fileBridge: JavaFileBridge) -> SwiftURLBridge { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_00024Companion_invokeSwift_1fromJavaFileBridge__Lskip_bridge_samples_JavaFileBridge_2")
internal func Java_skip_bridge_samples_SwiftURLBridge_00024Companion_invokeSwift_1fromJavaFileBridge__J(_ env: JNIEnvPointer, _ cls: JavaClassPointer?, _ fileBridge: JavaObjectPointer?) -> JavaObjectPointer? {
    handleSwiftError {
        try JavaFileBridge.fromJavaObject(fileBridge).toSwiftURLBridge().toJavaObject()
    } ?? nil
}
#endif
