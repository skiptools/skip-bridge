#if !SKIP
@_exported import Foundation
import SkipJNI
#else
public protocol JConvertible { }
public protocol JObjectConvertible { }
#endif

public protocol SkipBridgable: JConvertible {
}

public protocol SkipReferenceBridgable : AnyObject, SkipBridgable, JObjectConvertible {
    #if !SKIP
    var javaPeer: JavaObject { get throws }

    func invokeJava<T: SkipBridgable>(functionName: String, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T
    func invokeJavaVoid(functionName: String, _ args: SkipBridgable..., implementation: () throws -> ()) throws

    func invokeSwift<T: SkipBridgable>(_ args: SkipBridgable..., implementation: () throws -> T) rethrows -> T
    func invokeSwiftVoid(_ args: SkipBridgable..., implementation: () throws -> ()) rethrows
    #endif
}

public protocol SkipBridgeInstance {

}

open class SkipBridge : SkipBridgeInstance {
    #if SKIP // added by skipstone
    /// The pointer to the Swift side of MathBridge associated with this Java instance, used by `lookupSwiftPeerFromJavaObject`
    public var _swiftPeer: Long = 0
    #endif


    // FIXME: how to do this in the subclass?
    
    /// The name of the Java class for this Swift peer

    public init() {
    }


    /// Cleanup JNI peer.
    ///
    /// Cleanup should only happen if this instance was constructed from the Swift side.
    /// It if was created from the Java side, then cleanup will happen when the instance is finalized in the owning Java peer, like:
    ///
    /// ```
    /// fun finalize() {
    ///     JNI_call_cleanupSkipBridge(this)
    /// }
    /// ```
    deinit {
        if /* createdFromSwift */ true {
            cleanupSkipBridge()
        }
    }
}

public extension SkipBridgeInstance {
    #if !SKIP
    /// The pointer value of the this Swift object
    var swiftPointerValue: Int64 {
        let ptr = unsafeBitCast(self, to: Int.self)
        return Int64(ptr)
        // alternatively:
        // let ptr: UnsafeMutableRawPointer = Unmanaged.passUnretained(self).toOpaque()
        //return Int64(Int(bitPattern: ptr))
    }

    static func fromJavaObject(_ obj: JavaObject?) throws -> Self where Self : SkipBridge {
        try lookupSwiftPeerFromJavaObject(obj)
    }
    
    func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () -> ()) throws -> T {
        throw SkipBridgeError(description: "invokeJava should be have been added by the transpiler via an extension on the owning type")
    }

    func invokeJavaVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () -> ()) throws  {
        throw SkipBridgeError(description: "invokeJava should be have been added by the transpiler via an extension on the owning type")
    }

    func invokeSwift<T: SkipBridgable>(_ args: SkipBridgable..., implementation: () throws -> T) rethrows -> T {
        /// When calling Swift from Swift, we simply invoke the implementation
        return try implementation()
    }

    func invokeSwiftVoid(_ args: SkipBridgable..., implementation: () throws -> ()) rethrows {
        /// When calling Swift from Swift, we simply invoke the implementation
        try implementation()
    }

    #else // SKIP

    // on the Java side, we don't constrain T or the arguments to the invoke* functions to SkipBridgable since Kotlin cannot retroactively conform primitives to an interface

    func invokeJava<T>(_ args: Any..., implementation: () -> T) throws -> T {
        /// When calling Java from Java, we simply invoke the implementation
        return try implementation()
    }

    func invokeJavaVoid(_ args: Any..., implementation: () -> ()) throws {
        /// When calling Java from Java, we simply invoke the implementation
        try implementation()
    }

    func invokeSwift<T>(_ args: Any..., implementation: () throws -> ()) rethrows -> T {
        throw SkipBridgeError(description: "invokeSwift should be have been added by the transpiler for each function invocation")
    }

    func invokeSwiftVoid(_ args: Any..., implementation: () throws -> ()) rethrows {
        throw SkipBridgeError(description: "invokeSwift should be have been added by the transpiler for each function invocation")
    }

    /// Invokes the given closure, and checks whether an error was thrown by Swift or not.
    func checkSwiftError<T>(function: () -> T?) -> T {
        let result = function()
        if let error = SwiftBridge.shared.popSwiftErrorMessage() {
            throw RuntimeException(error) // ### TODO: should we try to convert the exception type?
        }
        return result!
    }

    /// Invokes the given closure, and checks whether an error was thrown by Swift or not.
    func checkSwiftErrorVoid(function: () -> Void) throws -> Void {
        function()
        if let error = SwiftBridge.shared.popSwiftErrorMessage() {
            throw RuntimeException(error) // ### TODO: should we try to convert the exception type?
        }
    }
    #endif

    /// Must be called from deinit in a `SkipBridge` implementation in order to clean up the JNI references
    func cleanupSkipBridge() {
        #if !SKIP
        // Called from Swift `deinit`.
        // If this instance had been constructed from the Java side, then do not remove the references here;
        // rather, they will be removed via the owning Java object's `finalize` function
        swiftJavaPeerMap.removeValue(forKey: self.swiftPointerValue)
        #endif
    }
}

#if !SKIP
extension SkipReferenceBridgable {
    public func callJavaT<T: SkipBridgable>(functionName: String, signature: String, arguments args: [SkipBridgable]) throws -> T {
        try callJ(functionName: functionName, signature: signature, arguments: args) { jobj, mid, jargs in
            try jobj.call(method: mid, jargs)
        }
    }

    public func callJavaV(functionName: String, signature: String, arguments args: [SkipBridgable]) throws {
        try callJ(functionName: functionName, signature: signature, arguments: args) { jobj, mid, jargs in
            try jobj.call(method: mid, jargs)
        }
    }

    /// Java invocation that can return either `Void` or a `SkipBridgable` instance.
    private func callJ<T>(functionName: String, signature: String, arguments args: [SkipBridgable], invoke: (JObject, JavaMethodID, [JavaParameter]) throws -> T) throws -> T {
        let javaObject: JavaObject = try self.javaPeer

        // 1. Get the Java peer of this Swift instance via the pointer value
        let jobj = JObject(javaObject)
        let jcls = jobj.cls

        // 2. Look up the callJavaPOW function using JNI with the specified arguments
        guard let mid = jcls.getMethodID(name: functionName, sig: signature) else {
            fatalError("could not lookup method id")
        }

        // 3. Invoke the JNI method with the given arguments
        let jargs = args.map({ $0.toJavaParameter() })
        return try invoke(jobj, mid, jargs)
    }
}
#endif

/// An error with the bridging between Swift and Java instances
public struct SkipBridgeError: Error, CustomStringConvertible {
    public var description: String

    public init(description: String) {
        self.description = description
    }
}

#if !SKIP

extension Bool : SkipBridgable { } // boolean (Z)
extension Int : SkipBridgable { } // long (J)
extension Int8 : SkipBridgable { } // byte (B)
extension Int16 : SkipBridgable { } // short (S)
extension UInt16 : SkipBridgable { } // char (C)
extension Int32 : SkipBridgable { } // int (I)
extension Int64 : SkipBridgable { } // long (L)
extension Float : SkipBridgable { } // float (F)
extension Double : SkipBridgable { } // double (D)
extension String : SkipBridgable { } // java.lang.String


/// Bookkeeping for peers
public var swiftJavaPeerMap: [Int64: JavaObject] = [:]
public var javaSwiftPeerMap: [Int64: SkipBridge] = [:]

public func lookupSwiftPeerFromJavaObject<T: SkipBridge>(_ obj: JavaObject?) throws -> T {
    guard let obj = obj else {
        throw SkipBridgeError(description: "Unable to call lookupSwiftPeerFromJavaObject for a nil JavaObject")
    }

    let javaObject = JObject(obj)

    /// Get the value of the `_swiftPeer` field, which will be set to the pointer of the peer Swift instance
    guard let ptr_field = javaObject.cls.getFieldID(name: "_swiftPeer", sig: "J") else {
        throw SkipBridgeError(description: "Could not find _swiftPeer field in Java instance")
    }

    let swiftPointer: Int64 = try javaObject.get(field: ptr_field)

    if swiftPointer == 0 {
        throw SkipBridgeError(description: "Value of _swiftPeer was unset for JavaObject")
    }

    let pointer = UnsafeMutableRawPointer(bitPattern: Int(swiftPointer))!
    return Unmanaged<T>.fromOpaque(pointer).takeUnretainedValue()
}

extension SkipReferenceBridgable where Self : SkipBridgeInstance {
    public var javaPeer: JavaObject {
        get throws {
            let swiftPointer = self.swiftPointerValue
            if let existingPeer = swiftJavaPeerMap[swiftPointer] {
                return existingPeer
            }

            let clazz = Self.javaClass
            // bridge classes always must have an accessable no-arg constructor
            let constructor = clazz.getMethodID(name: "<init>", sig: "()V")!
            let obj: JavaObject = try clazz.create(ctor: constructor, [])
            swiftJavaPeerMap[swiftPointer] = obj
            return obj
        }
    }
}
#endif

#if !SKIP
// MARK: error handling

private let _swiftErrorStackKey = "_swiftErrorStack"

/// Adds the given error to the current native error stack.
public func pushSwiftError(_ error: Error) {
    let threadStorage = Thread.current.threadDictionary
    var errorStack = threadStorage[_swiftErrorStackKey] as? [Error] ?? []
    errorStack.append(error)
    threadStorage[_swiftErrorStackKey] = errorStack
}

/// Removes the most recent error from the current thread's native error stack and returns it
public func popSwiftError() -> Error? {
    let threadStorage = Thread.current.threadDictionary
    var errorStack = threadStorage[_swiftErrorStackKey] as? [Error] ?? []
    defer {
        if errorStack.isEmpty {
            threadStorage.removeObject(forKey: _swiftErrorStackKey)
        } else {
            threadStorage[_swiftErrorStackKey] = errorStack
        }
    }
    return errorStack.popLast()
}

@_cdecl("Java_skip_bridge_SwiftBridge_popSwiftErrorMessageFromStack")
internal func Java_skip_bridge_SwiftBridge_popSwiftErrorMessageFromStack() -> JavaString? {
    if let error = popSwiftError() {
        return "\(error)".toJavaObject()
    } else {
        return nil
    }
}

#else

final class SwiftBridge {
    static let shared = SwiftBridge()

    public func popSwiftErrorMessage() -> String? {
        return popSwiftErrorMessageFromStack()
    }

    /* SKIP EXTERN */ public func popSwiftErrorMessageFromStack() -> String? {
        // this will invoke @_cdecl("Java_skip_bridge_SwiftBridge_popSwiftErrorMessageFromStack")
    }

}

#endif
