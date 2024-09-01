import SkipBridge
#if !SKIP
import SkipJNI

// skipstone-generated Swift

extension JavaFileBridge : SkipReferenceBridgable {
    public static let javaClass = try! JClass(name: "skip.bridge.samples.JavaFileBridge")

    public func toJavaObject() -> JavaObjectPointer? {
        try? javaPeer
    }

    /// Call from Swift into Java using JNI
    public func invokeJavaVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws {
        switch functionName {
        case "setFilePath(_:)":
            return try callJavaV(functionName: "setFilePath", signature: "(Ljava/lang/String;)V", arguments: args)
        default:
            fatalError("could not identify which function called invokeJava for: \(functionName)")
        }
    }

    /// Call from Swift into Java using JNI
    public func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
        switch functionName {
        case "exists()":
            return try callJavaT(functionName: "exists", signature: "()Z", arguments: args)
        case "delete()":
            return try callJavaT(functionName: "delete", signature: "()Z", arguments: args)
        case "createNewFile()":
            return try callJavaT(functionName: "createNewFile", signature: "()Z", arguments: args)
        case "toSwiftURLBridge()":
            return try callJavaT(functionName: "toSwiftURLBridge", signature: "()Lskip/bridge/samples/SwiftURLBridge;", arguments: args)
        default:
            fatalError("could not identify which function called invokeJava for: \(functionName)")
        }
    }
}

#endif

// the Kotlin side of the bridge with the invocation of the extern functions

#if SKIP
extension JavaFileBridge {
    func withSwiftBridge<T>(function: () -> T) -> T {
        if _swiftPeer == Long(0) {
            loadPeerLibrary("SkipBridgeSamples") // ensure the shared library containing the native implementations is loaded
            // create the Swift peer for this Java instance
            _swiftPeer = createSwiftJavaFileBridge()
        }

        return function()
    }

    /* SKIP EXTERN */ public func createSwiftJavaFileBridge() -> Int64 { }
}
#else
@_cdecl("Java_skip_bridge_samples_JavaFileBridge_createSwiftJavaFileBridge")
internal func Java_skip_bridge_samples_JavaFileBridge_createSwiftJavaFileBridge(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?) -> Int64 {
    registerSwiftBridge(JavaFileBridge())
}
#endif
