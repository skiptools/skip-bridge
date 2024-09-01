// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
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
    private let _createdFromJava: Bool
    #if !SKIP
    public var _javaPeer: JavaObjectPointer?

    public init(javaPeer: JavaObjectPointer!) {
        self._javaPeer = javaPeer
        self._createdFromJava = javaPeer != nil
    }
    #else
    public var _swiftPeer: Long

    public init(swiftPeer: Long) {
        self._swiftPeer = swiftPeer
        self._createdFromJava = swiftPeer == Long(0)
    }
    #endif

    /// Cleanup Swift/Java peers.
    deinit {
        #if !SKIP
        // release the Java instance when the Swift peer is dealloced, freeing it for garbage collection
        if _createdFromJava == false, let javaPeer = _javaPeer {
            jni.deleteGlobalRef(javaPeer)
            self._javaPeer = nil
        }
        #else
        // release the Swift instance
        if _createdFromJava == true, _swiftPeer != Long(0) {
            releaseSkipBridge(_swiftPeer)
            self._swiftPeer = Long(0)
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

    func invokeSwift<T: SkipBridgable>(_ args: SkipBridgable..., implementation: () async throws -> T) async rethrows -> T {
        return try await implementation()
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
    public func toJavaObject() -> JavaObjectPointer? {
        _javaPeer
    }

    public func createJavaPeer() throws -> JavaObjectPointer {
        let swiftPointer = registerSwiftBridge(self, retain: false)

        let clazz = Self.javaClass
        let bridgeClass = try JClass(name: "skip.bridge.SkipBridge") // need to use the superclass, which is where getMethodID is delcared
        // bridge classes always must have an accessable single-arg constructor take takes a pointer to the Swift peer
        guard let constructor = bridgeClass.getMethodID(name: "<init>", sig: "(J)V") else {
            throw SkipBridgeError(description: "Could not find single-argument constructor for Java instance of type \(try! clazz.name)")
        }
        let jobj: JavaObjectPointer = try clazz.create(ctor: constructor, [swiftPointer.toJavaParameter()])

        return jni.newGlobalRef(jobj)
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
        guard let javaObject: JavaObjectPointer = self._javaPeer else {
            throw SkipBridgeError(description: "No Java peer set for invocation of: \(functionName) with signature: \(signature)")
        }

        // 1. Get the Java peer of this Swift instance via the pointer value
        let jobj = JObject(javaObject)
        let jcls = jobj.cls

        // 2. Look up the function using JNI with the specified arguments
        guard let mid = jcls.getMethodID(name: functionName, sig: signature) else {
            throw SkipBridgeError(description: "Could not lookup method id: \(functionName) with signature: \(signature)")
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

extension Optional : SkipBridgable where Wrapped : SkipBridgable & JObjectConvertible {
}

/// The `swiftPeerRegistry` exists simply to retain a bridge instance that is held by the Java peer on memory.
/// On `finalize()`, the Java peer will remove the instance from the registry, releasing it for deallocation.
//private var swiftPeerRegistry: [Int64: SkipBridge] = [:]
//private let swiftPeerRegistryLock = OSAllocatedUnfairLock()

/// Adds a newly-created Swift bridge and registers the pointer value of the instance globally so it is retained until the Java side is finalized
public func registerSwiftBridge<T : SkipReferenceBridgable>(_ bridge: T, retain: Bool) -> Int64 {
    // The pointer value of the this Swift object, which is how the Swift reference can be stored in the Java object.
    // Note that this `retain` will need to be manually balanced by a `release` when the Java instance is finalized.
    let ptr: UnsafeMutableRawPointer = (retain ? Unmanaged.passRetained(bridge) : Unmanaged.passUnretained(bridge)).toOpaque()
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
    assert(swiftPointer != 0, "SkipBridge: swiftPeer: swiftPointer was zero")
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

#if SKIP

public extension SkipBridge {
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
    func loadPeerLibrary(_ libName: String) {
        //print("### System.getenv(): \(System.getenv())")

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

        if loadedLibraries.contains(libraryPath) {
            return // already loaded
        }

        // load the native library that contains the function implementations
        if !java.io.File(libraryPath).isFile() {
            print("warning: missing library: \(libraryPath)")
        } else {
            print("note: loading library: \(libraryPath)")
            System.load(libraryPath)
            loadedLibraries.insert(libraryPath)
            print("note: loaded library: \(libraryPath)")
        }
    }
}

/// The list the library file paths we have already loaded so we don't try to load the multiple times
private var loadedLibraries: Set<String> = []
#endif

