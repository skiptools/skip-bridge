#if !SKIP
import Foundation
import SkipJNI
#else
public protocol JConvertible { }
public protocol JObjectConvertible { }
#endif

// TODO: constructors/initializers
// TODO: static functions
// TODO: async/coroutine bridging
// TODO: error/exception translation


public protocol SkipBridgable: JConvertible {
}

public protocol SkipBridge : AnyObject, JObjectConvertible {
    static var javaClassName: String { get }
    
    #if !SKIP
    var javaPeer: JavaObject { get throws }
    #endif

    #if !SKIP
    func invokeJava<T: SkipBridgable>(functionName: String, _ args: SkipBridgable..., implementation: () -> ()) throws -> T

    func invokeSwift<T: SkipBridgable>(_ args: SkipBridgable..., implementation: () throws -> T) rethrows -> T
    #endif
}

public extension SkipBridge {
    #if !SKIP
    static var javaClass: JClass {
        try! JClass(name: javaClassName)
    }

    static func fromJavaObject(_ obj: JavaObject?) throws -> Self {
        try lookupSwiftPeerFromJavaObject(obj)
    }

    func toJavaObject() -> JavaObject? {
        try? javaPeer
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

    #if !SKIP
    /// The pointer value of the this Swift object
    var swiftPointerValue: Int64 {
        let ptr = unsafeBitCast(self, to: Int.self)
        return Int64(ptr)
        // alternatively:
        // let ptr: UnsafeMutableRawPointer = Unmanaged.passUnretained(self).toOpaque()
        //return Int64(Int(bitPattern: ptr))
    }

    var javaPeer: JavaObject {
        get throws {
            let swiftPointer = self.swiftPointerValue
            if let existingPeer = swiftJavaPeerMap[swiftPointer] {
                return existingPeer
            }

            let clazz = Self.javaClass
            let constructor = clazz.getMethodID(name: "<init>", sig: "()V")!
            let obj: JavaObject = try! clazz.create(ctor: constructor, [])
            swiftJavaPeerMap[swiftPointer] = obj
            return obj
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



#if !SKIP
//func getPeerFromJavaObject(javaObject: JavaObject) -> SkipBridgable? {
//    if let ptr_field = javaObject.cls.getFieldID(name: "_ptr", sig: "J") {
//        let ptr = unsafeBitCast(self, to: Int.self)
//        javaObject.set(field: ptr_field, value: Int64(ptr))
//    }
//
//}

//open class ObjectBase: ObjectProtocol {
//    public let javaObject: JObject
//
//    open class var javaClass: JClass {
//        return try! getJavaClass(from: self)
//    }
//
//    public required init(_ obj: JavaObject) {
//        javaObject = JObject(obj)
//    }
//
//    public required init(ctor: JavaMethodID, _ args: [JavaParameter]) throws {
//        let obj = try type(of: self).javaClass.create(ctor: ctor, args)
//        javaObject = JObject(obj)
//
//        if let ptr_field = javaObject.cls.getFieldID(name: "_ptr", sig: "J") {
//            let ptr = unsafeBitCast(self, to: Int.self)
//            javaObject.set(field: ptr_field, value: Int64(ptr))
//        }
//    }
//}
//
//
//extension ObjectBase: Equatable {
//    public static func == (lhs: ObjectBase, rhs: ObjectBase) -> Bool {
//        return jni.withEnv { $0.IsSameObject($1, lhs.javaObject.ptr, rhs.javaObject.ptr) != 0 }
//    }
//}

#endif

