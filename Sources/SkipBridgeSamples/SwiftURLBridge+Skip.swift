import SkipBridge
#if !SKIP
import Darwin
import Foundation
#endif

// skipstone: SwiftURLBridge+SkipExtensions.swift

#if SKIP
extension SwiftURLBridge {
    func withSwiftBridge<T>(function: () -> T) -> T {
        if _swiftPeer == Long(0) {
            loadPeerLibrary("SkipBridgeSamples") // ensure the shared library containing the native implementations is loaded
            // create the Swift peer for this Java instance
            _swiftPeer = createSwiftURLBridge()
        }

        return function()
    }

    /* SKIP EXTERN */ public func createSwiftURLBridge() -> Int64 {
        // this will invoke @_cdecl("Java_skip_bridge_samples_SwiftURLBridge_createSwiftURLBridge")
    }

    /* SKIP EXTERN */ public func invokeSwift_setURLString(_ value: String) {
        // this will invoke @_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1setURLString")
    }

    /* SKIP EXTERN */ public func invokeSwift_isFileURL() -> Bool {
        // this will invoke @_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL")
    }

    /* SKIP EXTERN */ public func invokeSwift_toJavaFileBridge() -> JavaFileBridge {
        // this will invoke @_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1toJavaFileBridge")
    }
}

#else

import SkipJNI

// skipstone-generated JNI functions

@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_createSwiftURLBridge")
public func Java_skip_bridge_samples_SwiftURLBridge_createSwiftURLBridge(_ env: JNIEnvPointer, _ obj: JavaObject?) -> Int64 {
    registerSwiftBridge(SwiftURLBridge())
}

@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1setURLString")
public func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1setURLString(_ env: JNIEnvPointer, _ obj: JavaObject?, _ urlString: JavaString?) {
    do {
        let bridge: SwiftURLBridge = try lookupSwiftPeerFromJavaObject(obj) // TODO: how to handle exception?
        try bridge.setURLString(String.fromJavaObject(urlString))
    } catch {
        // `@_cdecl` JNI functions cannot throw errors, so instead we add the current error to the thread's error stack, which we will check after invoking the function
        pushSwiftError(error)
    }
}

@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL")
public func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL(_ env: JNIEnvPointer, _ obj: JavaObject?) -> Bool {
    let bridge: SwiftURLBridge = try! lookupSwiftPeerFromJavaObject(obj)
    return bridge.isFileURL()
}

@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1toJavaFileBridge")
public func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1toJavaFileBridge(_ env: JNIEnvPointer, _ obj: JavaObject?) -> JavaObject? {
    do {
        let bridge: SwiftURLBridge = try! lookupSwiftPeerFromJavaObject(obj)
        return try JavaFileBridge(filePath: bridge.url.path).toJavaObject()
    } catch {
        // `@_cdecl` JNI functions cannot throw errors, so instead we add the current error to the thread's error stack, which we will check after invoking the function
        pushSwiftError(error)
        return nil
    }
}


// skipstone-generated Swift

extension SwiftURLBridge : SkipReferenceBridgable {
    public static var javaClass: JClass {
        return try! JClass(name: "skip.bridge.samples.SwiftURLBridge")
    }

    public func toJavaObject() -> JavaObject? {
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
