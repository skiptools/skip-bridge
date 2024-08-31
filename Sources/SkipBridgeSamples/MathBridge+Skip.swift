import SkipBridge
#if !SKIP
import Darwin
import Foundation
#endif

// skipstone: MathBridge+SkipExtensions.swift

#if SKIP
extension MathBridge {
    func withSwiftBridge<T>(function: () -> T) -> T {
        if _swiftPeer == Long(0) {
            loadPeerLibrary("SkipBridgeSamples") // ensure the shared library containing the native implementations is loaded
            // create the Swift peer for this Java instance
            _swiftPeer = createSwiftMathBridge()
        }

        return function()
    }

    /* SKIP EXTERN */ public func createSwiftMathBridge() -> Int64 {
        // this will invoke @_cdecl("Java_skip_bridge_samples_MathBridge_createSwiftMathBridge")
    }

    /* SKIP EXTERN */ public func invokeSwift_callSwiftPOW(_ value: Double, _ power: Double) -> Double {
        // this will invoke @_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__DD")
    }

    /* SKIP EXTERN */ public func invokeSwift_callSwiftThrowing(_ value: String) {
        // this will invoke @_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing")
    }
}

#else

import SkipJNI

// skipstone-generated JNI functions

@_cdecl("Java_skip_bridge_samples_MathBridge_createSwiftMathBridge")
public func Java_skip_bridge_samples_MathBridge_createSwiftMathBridge(_ env: JNIEnvPointer, _ obj: JavaObject?) -> Int64 {
    registerSwiftBridge(MathBridge())
}

@_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__DD")
public func Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__DD(_ env: JNIEnvPointer, _ obj: JavaObject?, _ value: Double, _ power: Double) -> Double {
    let bridge: MathBridge = try! lookupSwiftPeerFromJavaObject(obj) // TODO: how to handle exception?
    return bridge.callSwiftPOW(value, power: power)
}

@_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing")
public func Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing(_ env: JNIEnvPointer, _ obj: JavaObject?, _ message: JavaString?) {
    let bridge: MathBridge = try! lookupSwiftPeerFromJavaObject(obj) // TODO: how to handle exception?
    do {
        try bridge.callSwiftThrowing(message: String.fromJavaObject(message))
    } catch {
        // `@_cdecl` JNI functions cannot throw errors, so instead we add the current error to the thread's error stack, which we will check after invoking the function
        pushSwiftError(error)
    }
}

// skipstone-generated Swift

extension MathBridge : SkipReferenceBridgable {
    public static var javaClass: JClass {
        return try! JClass(name: "skip.bridge.samples.MathBridge")
    }

    public func toJavaObject() -> JavaObject? {
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

#endif
