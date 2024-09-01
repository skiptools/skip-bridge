import SkipBridge
#if !SKIP
import Foundation
import SkipJNI

// skipstone-generated Swift

extension MathBridge : SkipReferenceBridgable {
    public static let javaClass = try! JClass(name: "skip.bridge.samples.MathBridge")

    public func toJavaObject() -> JavaObjectPointer? {
        try? javaPeer
    }

    /// Call from Swift into Java using JNI
    public func invokeJavaVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws {
        switch functionName {
        case "callJavaThrowing(message:)":
            return try callJavaV(functionName: "callJavaThrowing", signature: "(Ljava/lang/String;)V", arguments: args)
        default:
            fatalError("could not identify which function called invokeJava for: \(functionName)")
        }
    }

    /// Call from Swift into Java using JNI
    public func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
        switch functionName {
        case "callJavaPOW(_:power:)":
            return try callJavaT(functionName: "callJavaPOW", signature: "(DD)D", arguments: args)
        default:
            fatalError("could not identify which function called invokeJava for: \(functionName)")
        }

    }
}
#else

#endif

// MARK: skipstone-generated JNI bridging

#if SKIP
public extension MathBridge {
    internal func withSwiftBridge<T>(function: () -> T) -> T {
        if _swiftPeer == Long(0) {
            loadPeerLibrary("SkipBridgeSamples") // ensure the shared library containing the native implementations is loaded
            // create the Swift peer for this Java instance
            _swiftPeer = createSwiftMathBridge()
        }

        return function()
    }

    /* SKIP EXTERN */ func createSwiftMathBridge() -> Int64 {
        // this will invoke @_cdecl("Java_skip_bridge_samples_MathBridge_createSwiftMathBridge")
    }
}
#else
@_cdecl("Java_skip_bridge_samples_MathBridge_createSwiftMathBridge")
internal func Java_skip_bridge_samples_MathBridge_createSwiftMathBridge(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?) -> Int64 {
    registerSwiftBridge(MathBridge())
}
#endif


#if SKIP
public extension MathBridge {
    /* SKIP EXTERN */ func invokeSwift_callSwiftPOW(_ swiftPeer: Long, _ value: Double, _ power: Double) -> Double { }
}
#else
@_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__JDD")
internal func Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__JDD(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong, _ value: Double, _ power: Double) -> Double {
    let bridge: MathBridge = swiftPeer(for: swiftPointer)
    return bridge.callSwiftPOW(value, power: power)
}
#endif


#if SKIP
public extension MathBridge {
    /* SKIP EXTERN */ func invokeSwift_callSwiftThrowing(_ swiftPeer: Long, _ value: String) { }
}
#else
/// JNI Signature naming rules from https://docs.oracle.com/javase/1.5.0/docs/guide/jni/spec/design.html#wp615
///
/// - `_1` escaps the underscore in the method name: `invokeSwift_callSwiftThrowing` -> `invokeSwift_1callSwiftThrowing`
/// - Parameters are separated from function name with `__`
/// - First paramerer is a Long (`J`)
/// - Second parameter is a `java.lang.String` whose JNI string ls `Ljava/lang/String;` and which is encoded to the C function name `Ljava_lang_String_2` (`_2` represents `;`)
/// - If there were a `[` in the function name, that would be represented by `_3`
@_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing__JLjava_lang_String_2")
internal func Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing__JLjava_lang_String_2(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong, _ message: JavaString?) {
    let bridge: MathBridge = swiftPeer(for: swiftPointer)
    handleSwiftError {
        try bridge.callSwiftThrowing(message: String.fromJavaObject(message))
    }
}
#endif

