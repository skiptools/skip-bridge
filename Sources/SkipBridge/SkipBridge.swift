#if !SKIP
@_exported import Foundation
import SkipJNI
import os
#else
public protocol JConvertible { }
public protocol JObjectConvertible { }
#endif

public protocol SkipBridgable: JConvertible {
}

public protocol SkipReferenceBridgable : AnyObject, SkipBridgable, JObjectConvertible {
    #if !SKIP
    var javaPeer: JavaObjectPointer { get throws }
    var _javaPeer: JavaObjectPointer? { get set }

    func invokeJava<T: SkipBridgable>(functionName: String, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T
    func invokeJavaVoid(functionName: String, _ args: SkipBridgable..., implementation: () throws -> ()) throws

    func invokeSwift<T: SkipBridgable>(_ args: SkipBridgable..., implementation: () throws -> T) rethrows -> T
    func invokeSwiftVoid(_ args: SkipBridgable..., implementation: () throws -> ()) rethrows
    #endif
}

public protocol SkipBridgeInstance : AnyObject {

}

open class SkipBridge : SkipBridgeInstance {
    #if !SKIP
    public var _javaPeer: JavaObjectPointer?
    #else
    public var _swiftPeer: Long = 0
    #endif

    public init() {
    }

    /// Cleanup Swift/Java peers.
    deinit {
        #if !SKIP
        // release the Java instance when the Swift peer is dealloced, freeing it for garbage collection
        if let javaPeer = _javaPeer {
            // FIXME: this winds up deallocating the Swift instance too soon, but without we have a reference cycle between the Swift and Java peers
            // https://developer.android.com/training/articles/perf-jni#local-and-global-references
            //jni.deleteGlobalRef(javaPeer)
        }
        #else
        // finalize the Java instance, which will remove the Swift peer from the swiftPeerRegistry
        if _swiftPeer != Long(0) {
            releaseSkipBridge(_swiftPeer)
        }
        #endif
    }

    #if SKIP
    /* SKIP EXTERN */ internal func releaseSkipBridge(_ swiftPointer: Long) {
        // this will invoke @_cdecl("Java_skip_bridge_SkipBridge_releaseSkipBridge")
    }
    #endif
}

public extension SkipBridgeInstance {
    #if !SKIP
    static func fromJavaObject(_ obj: JavaObjectPointer?) throws -> Self where Self : SkipBridge {
        try swiftPeerReflective(for: obj)
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

    static func invokeSwift<T: SkipBridgable>(_ args: SkipBridgable..., implementation: () throws -> T) rethrows -> T {
        /// When calling Swift from Swift, we simply invoke the implementation
        return try implementation()
    }

    static func invokeSwiftVoid(_ args: SkipBridgable..., implementation: () throws -> ()) rethrows {
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
        throw SkipBridgeError(description: "invokeSwift should be have been replaced with the native method invocation by the transpiler")
    }

    func invokeSwiftVoid(_ args: Any..., implementation: () throws -> ()) rethrows {
        throw SkipBridgeError(description: "invokeSwift should be have been replaced with the native method invocation by the transpiler")
    }
    #endif
}

#if !SKIP

extension SkipReferenceBridgable {
    /// Returns the Java peer instance for this `SkipBridgeInstance`. It will lazily create the instance if it doesn't already exist.
    /// 
    public var javaPeer: JavaObjectPointer {
        get throws {
            if let peer = _javaPeer {
                return peer
            }

            let clazz = Self.javaClass
            // bridge classes always must have an accessable no-arg constructor
            let constructor = clazz.getMethodID(name: "<init>", sig: "()V")!
            let obj: JavaObjectPointer = try clazz.create(ctor: constructor, [])
            let peer = jni.newGlobalRef(obj)!
            self._javaPeer = peer
            return peer
        }
    }

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
        let javaObject: JavaObjectPointer = try self.javaPeer

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

public extension JClass {
    /// Converts the Swift type name into a Java class name, following the convention of de-camel-casing the module name as the package name.
    /// - Parameter fromSwiftType: the type of the class
    convenience init<T: SkipBridgeInstance>(fromSwiftType: T.Type) throws {
        let swiftName = String(reflecting: fromSwiftType).split(separator: ".")
        let packageName = Self.packageName(forModule: swiftName.first ?? "")
        let fqn = packageName + "." + (swiftName.last ?? "")
        try self.init(name: fqn)
    }

    /// Turn module name ModuleName package name module.name
    private static func packageName(forModule moduleName: any StringProtocol) -> String {
        var lastLower = false
        var packageName = ""
        for c in moduleName {
            let lower = c.lowercased()
            if lower == String(c) {
                lastLower = true
            } else {
                if lastLower == true {
                    packageName += "."
                }
                lastLower = false
            }
            packageName += lower
        }

        return packageName
    }
}

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


/// The `swiftPeerRegistry` exists simply to retain a bridge instance that is held by the Java peer on memory.
/// On `finalize()`, the Java peer will remove the instance from the registry, releasing it for deallocation.
//private var swiftPeerRegistry: [Int64: SkipBridge] = [:]
//private let swiftPeerRegistryLock = OSAllocatedUnfairLock()

/// Adds a newly-created Swift bridge and registers the pointer value of the instance globally so it is retained until the Java side is finalized
public func registerSwiftBridge<T : SkipBridge>(_ bridge: T) -> Int64 {
    // The pointer value of the this Swift object, which is how the Swift reference can be stored in the Java object.
    // Note that this `retain` will need to be manually balanced by a `release` when the Java instance is finalized.
    let ptr: UnsafeMutableRawPointer = Unmanaged.passRetained(bridge).toOpaque()
    return Int64(Int(bitPattern: ptr))
}

/// Called when a Java peer finalizes, this will de-register the Swift peer's pointer from the global map so the Swift side can be deinit'd.
@_cdecl("Java_skip_bridge_SkipBridge_releaseSkipBridge")
internal func Java_skip_bridge_SkipBridge_releaseSkipBridge(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong) {
    if swiftPointer != 0, let pointer = UnsafeMutableRawPointer(bitPattern: Int(swiftPointer)) {
        let bridge = Unmanaged<SkipBridge>.fromOpaque(pointer)
        bridge.release() // release the Swift instance
    }
}

/// Takes the pointer to the Swift instance and converts it into the expected `SkipBridge` type
public func swiftPeer<T: SkipBridge>(for swiftPointer: JavaLong) -> T {
    let pointer = UnsafeMutableRawPointer(bitPattern: Int(swiftPointer))!
    return Unmanaged<T>.fromOpaque(pointer).takeUnretainedValue()
}

// TODO: @available(*, deprecated, message: "no need for the overhead of reflective field lookup of _swiftPeer when we can just pass the pointer directly")
private func swiftPeerReflective<T: SkipBridge>(for obj: JavaObjectPointer?) throws -> T {
    guard let obj = obj else {
        throw SkipBridgeError(description: "Unable to call swiftPeer for a nil JavaObject")
    }

    let javaObject = JObject(obj)

    /// Get the value of the `_swiftPeer` field, which will be set to the pointer of the peer Swift instance
    guard let ptr_field = javaObject.cls.getFieldID(name: "_swiftPeer", sig: "J") else {
        throw SkipBridgeError(description: "Could not find _swiftPeer field in Java instance")
    }

    let swiftPointer: Int64 = try javaObject.get(field: ptr_field)

    if swiftPointer == 0 {
        throw SkipBridgeError(description: "Value of _swiftPeer was unset for JavaObject of type \(T.self)")
    }

    return swiftPeer(for: swiftPointer)
}

#endif

// MARK: Error handling


/// An error with the bridging between Swift and Java instances
public struct SkipBridgeError: Error, CustomStringConvertible {
    public var description: String

    public init(description: String) {
        self.description = description
    }
}

#if !SKIP

private let _swiftErrorStackKey = "_swiftErrorStack"

/// Execute the given Swift closure and if an error occurs, put it onto the thread's error stack and return nil.
public func handleSwiftError<T>(_ block: () throws -> T) -> T? {
    do {
        return try block()
    } catch {
        // `@_cdecl` JNI C functions cannot throw, so instead we add the current error to the thread's error stack, which we will check after invoking the function
        pushSwiftError(error)
        return nil
    }
}

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

/// The static `skip.bridge.SkipBridge$Companion` function reaplces the `$` with the unicode representation: `_00024`.
///
/// See: https://docs.oracle.com/javase/1.5.0/docs/guide/jni/spec/design.html#wp615
@_cdecl("Java_skip_bridge_SkipBridge_00024Companion_popSwiftErrorMessageFromStack")
internal func Java_skip_bridge_SkipBridge_00024Companion_popSwiftErrorMessageFromStack(_ env: JNIEnvPointer, _ cls: JavaClassPointer?) -> JavaString? {
    if let error = popSwiftError() {
        return "\(error)".toJavaObject()
    } else {
        return nil
    }
}
#else
public extension SkipBridge {
    /* SKIP EXTERN */ public static func popSwiftErrorMessageFromStack() -> String? {
        // this will invoke @_cdecl("Java_skip_bridge_SkipBridge_00024Companion_popSwiftErrorMessageFromStack")
    }
}

/// Invokes the given closure, and checks whether an error was thrown by Swift or not.
public func checkSwiftError<T>(function: () -> T?) -> T {
    let result = function()
    if let error = popSwiftErrorMessage() {
        throw RuntimeException(error) // ### TODO: should we try to convert the exception type?
    }
    return result!
}

/// Invokes the given closure, and checks whether an error was thrown by Swift or not.
public func checkSwiftErrorVoid(function: () -> Void) throws -> Void {
    function()
    if let error = popSwiftErrorMessage() {
        throw RuntimeException(error) // ### TODO: should we try to convert the exception type?
    }
}

public func popSwiftErrorMessage() -> String? {
    return SkipBridge.popSwiftErrorMessageFromStack()
}

#endif
