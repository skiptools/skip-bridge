// This is free software: you can redistribute and/or modify it
// under the terms of the GNU General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import CJNI
import Foundation

#if canImport(Android)
import Android
#endif

// MARK: JNI Types

public typealias JNIEnv = CJNI.JNIEnv
public typealias JNIEnvPointer = UnsafeMutablePointer<JNIEnv?>
public typealias JavaBoolean = jboolean
public typealias JavaByte = jbyte
public typealias JavaChar = jchar
public typealias JavaShort = jshort
public typealias JavaInt = jint
public typealias JavaLong = jlong
public typealias JavaFloat = jfloat
public typealias JavaDouble = jdouble

public typealias JavaObjectPointer = jobject
public typealias JavaClassPointer = jobject
public typealias JavaString = jstring
public typealias JavaArray = jarray
public typealias JavaObjectArray = jobjectArray
public typealias JavaBooleanArray = jbooleanArray
public typealias JavaByteArray = jbyteArray
public typealias JavaCharArray = jcharArray
public typealias JavaShortArray = jshortArray
public typealias JavaIntArray = jintArray
public typealias JavaLongArray = jlongArray
public typealias JavaFloatArray = jfloatArray
public typealias JavaDoubleArray = jdoubleArray
public typealias JavaThrowable = jthrowable
public typealias JavaWeakReference = jweak

public typealias JavaFieldID = jfieldID
public typealias JavaMethodID = jmethodID
public typealias JavaParameter = jvalue

extension JavaBoolean : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = value ? JavaBoolean(JNI_TRUE) : JavaBoolean(JNI_FALSE)
    }
}

// MARK: JNI

/// The single shared singleton JNI instance for the process
public private(set) var jni: JNI! // this gets set "OnLoad" so should always exist

/// Establish a context in which to perform JNI operations.
///
/// - Warning: You cannot initiate JNI operations from native code outside of a context.
public func jniContext<T>(_ block: () throws -> T) rethrows -> T {
    let jvm: JNIInvokeInterface = jni._jvm.pointee!.pointee
    var tenv: UnsafeMutableRawPointer?
    let threadStatus = jvm.GetEnv(jni._jvm, &tenv, JavaInt(JNI_VERSION_1_6))
    
    // Ensure that there is a `JNIEnvPointer` for the current thread
    // See: https://developer.android.com/training/articles/perf-jni#threads
    switch threadStatus {
    case JNI_OK:
        return try block()
    case JNI_EDETACHED:
        // we weren't attached to the Java thread; attach, perform the block, and then detach
        // see https://developer.android.com/training/articles/perf-jni#threads
        var tenv: JNIEnvPointer!
        if jvm.AttachCurrentThread(jni._jvm, &tenv, nil) != JNI_OK {
            fatalError("SkipJNI: unable to attach JNI to current thread")
        }
        defer {
            if jvm.DetachCurrentThread(jni._jvm) != JNI_OK {
                fatalError("SkipJNI: unable to detach JNI from thread")
            }
        }
        return try block()
    case JNI_EVERSION:
        fatalError("SkipJNI: unsupoprted JNI version")
    default:
        fatalError("SkipJNI: unexpected JNI thread status: \(threadStatus)")
    }
}

/// Gateway to JVM and JNI functionality
public class JNI {
    /// Our reference to the Java Virtual Machine, to be set on init
    let _jvm: UnsafeMutablePointer<JavaVM?>

    // Normally we init the jni global ourselves in JNI_OnLoad
    public init(jvm: UnsafeMutablePointer<JavaVM?>) {
        self._jvm = jvm
    }
}

extension JNI {
    /// Perform an operation with the current thread's `JNIEnviPointer`.
    fileprivate func withEnv<T>(_ block: (JNINativeInterface, JNIEnvPointer) throws -> T) rethrows -> T {
        let jvm: JNIInvokeInterface = _jvm.pointee!.pointee
        var tenv: UnsafeMutableRawPointer?
        let threadStatus = jvm.GetEnv(_jvm, &tenv, JavaInt(JNI_VERSION_1_6))
        guard threadStatus == JNI_OK else {
            fatalError("SkipJNI: you must perform JNI operations within a jniContext { ... } block")
        }
        let env = tenv!.assumingMemoryBound(to: JNIEnv?.self)
        return try block(env.pointee!.pointee, env)
    }

    /// Same as `withEnv`, but also checks for any java exceptions. If an exception occurred,
    /// it will throw a `JavaException` and clear the JNI exception.
    fileprivate func withEnvThrowing<T>(_ block: (JNINativeInterface, JNIEnvPointer) throws -> T) throws -> T {
        let result = try withEnv(block)
        try checkExceptionAndThrow()
        return result
    }

    /// Checks whether there is a Java exception outstanding, and if so, clears the exception and throws it as a Swift error.
    public func checkExceptionAndThrow() throws {
        if let throwable = self.exceptionOccurred() {
            self.exceptionClear()
            throw JThrowable(throwable).toError()
        }
    }

    @discardableResult public func checkExceptionAndClear() -> Bool {
        if self.exceptionCheck() == true {
            self.exceptionClear()
            return true
        } else {
            return false
        }
    }
}

extension JNI {
    /// The JNI version in effect
    public var version: JavaInt { withEnv { $0.GetVersion($1) } }

    private func getJavaVM(vm: UnsafeMutablePointer<UnsafeMutablePointer<JavaVM?>?>) -> JavaInt {
        withEnv { $0.GetJavaVM($1, vm) }
    }

    public func registerNatives(targetClass: JavaClassPointer, _ methods: UnsafePointer<JNINativeMethod>, _ nMethods: JavaInt) -> JavaInt {
        withEnv { $0.RegisterNatives($1, targetClass, methods, nMethods) }
    }

    public func unregisterNatives(targetClass: JavaClassPointer) -> JavaInt {
        withEnv { $0.UnregisterNatives($1, targetClass) }
    }

    public func exceptionCheck() -> JavaBoolean {
        withEnv { $0.ExceptionCheck($1) }
    }

    public func exceptionClear() {
        withEnv { $0.ExceptionClear($1) }
    }

    public func exceptionOccurred() -> JavaThrowable? {
        withEnv { $0.ExceptionOccurred($1) }
    }

    public func exceptionDescribe() {
        withEnv { $0.ExceptionDescribe($1) }
    }

    public func monitorEnter(obj: JavaObjectPointer) -> JavaInt {
        withEnv { $0.MonitorEnter($1, obj) }
    }

    public func monitorExit(obj: JavaObjectPointer) -> JavaInt {
        withEnv { $0.MonitorExit($1, obj) }
    }

    func synchronized<T>(_ obj: JavaObjectPointer, _ block: () throws -> T) rethrows -> T {
        try withEnv { inv, env in
            if inv.MonitorEnter(env, obj) != JNI_OK {
                fatalError("SkipJNI: unable to MonitorEnter")
            }
            defer {
                if inv.MonitorExit(env, obj) != JNI_OK {
                    fatalError("SkipJNI: unable to MonitorExit")
                }
            }
            return try block()
        }
    }

    public func findClass(_ name: String) -> JavaClassPointer? {
        withEnv { $0.FindClass($1, name) }
    }

    public func newGlobalRef(_ obj: JavaObjectPointer) -> JavaObjectPointer! {
        withEnv { $0.NewGlobalRef($1, obj) }
    }

    public func deleteGlobalRef(_ obj: JavaObjectPointer) {
        withEnv { $0.DeleteGlobalRef($1, obj) }
    }

    public func newLocalRef(_ obj: JavaObjectPointer) -> JavaObjectPointer! {
        withEnv { $0.NewLocalRef($1, obj) }
    }

    public func deleteLocalRef(_ obj: JavaObjectPointer) {
        withEnv { $0.DeleteLocalRef($1, obj) }
    }

    public func getObjectClass(_ obj: JavaObjectPointer) -> JavaClassPointer! {
        withEnv { $0.GetObjectClass($1, obj) }
    }
}

// MARK: Errors

/// A system-level error relating to interacting with the Java Virtual Machine
public struct JVMError: Error, CustomStringConvertible {
    public var description: String

    public init(description: String) {
        self.description = description
    }
}

/// A class could not be loaded
public struct ClassNotFoundError: Error, CustomStringConvertible {
    public var description: String

    public init(name: String) {
        self.description = "Unable to load class: \(name)"
    }
}

/// An unexpected JNI error
public struct JNIError: Error, CustomStringConvertible {
    public var description: String

    public init(description: String = "JNIError", clear: Bool) {
        self.description = description

        jni.exceptionDescribe()
        if clear {
            jni.exceptionClear()
        }
    }
}

/// An error from a Java Throwable.
public struct ThrowableError: Error, CustomStringConvertible {
    public let description: String
}

// MARK: Convertions

/// Type that can be converted to and from Java.
public protocol JConvertible {
    static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Self
    static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Self

    static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Self
    func store(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Void

    static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Self
    func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Void

    static func fromJavaObject(_ obj: JavaObjectPointer?) -> Self
    func toJavaObject() -> JavaObjectPointer?

    func toJavaParameter() -> JavaParameter
}

/// Type represented by a Java object.
public protocol JObjectProtocol {
}

extension JConvertible where Self: JObjectProtocol {
    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Self {
        fromJavaObject(try jni.withEnvThrowing { $0.CallObjectMethodA($1, obj, method, args) })
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Self {
        fromJavaObject(try jni.withEnvThrowing { $0.CallStaticObjectMethodA($1, cls, method, args) })
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Self {
        fromJavaObject(jni.withEnv { $0.GetObjectField($1, obj, field) })
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Void {
        jni.withEnv { $0.SetObjectField($1, obj, field, toJavaObject()) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Self {
        fromJavaObject(jni.withEnv { $0.GetStaticObjectField($1, cls, field) })
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Void {
        jni.withEnv { $0.SetStaticObjectField($1, cls, field, toJavaObject()) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(l: toJavaObject())
    }
}

/// All optionals are represented by Java objects
extension Optional: JObjectProtocol {
}

extension Optional: JConvertible where Wrapped: JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> Self {
        if let obj {
            return Wrapped.fromJavaObject(obj)
        } else {
            return nil
        }
    }

    public func toJavaObject() -> JavaObjectPointer? {
        if let self {
            return self.toJavaObject()
        } else {
            return nil
        }
    }
}

extension JavaObjectPointer: JObjectProtocol {
}

extension JavaObjectPointer: JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> JavaObjectPointer {
        return obj!
    }

    public func toJavaObject() -> JavaObjectPointer? {
        return self
    }
}

/// A Java primitive wrapper, e.g. java/lang/Integer
public protocol JPrimitiveWrapperProtocol: JObjectProtocol {
    static var javaClass: JClass { get }
    static var initWithPrimitiveValueMethodID: JavaMethodID { get }
    static var primitiveValueMethodID: JavaMethodID { get }

    associatedtype JConvertibleType: JConvertible
    var value: JConvertibleType { get throws }
    init(_ value: JConvertibleType)
    init(_ obj: JavaObjectPointer)
}

extension JPrimitiveWrapperProtocol where Self: JObject {
    public init(_ value: JConvertibleType) {
        // we force try because primitive wrapper initializers should never fail
        let ptr = try! Self.javaClass.create(ctor: Self.initWithPrimitiveValueMethodID, args: [value.toJavaParameter()])
        self.init(ptr)
    }

    public var value: JConvertibleType {
        get throws {
            return try call(method: Self.primitiveValueMethodID, args: [])
        }
    }
}

/// A Java primitive
public protocol JPrimitiveProtocol: JConvertible {
    associatedtype JWrapperType: JPrimitiveWrapperProtocol
}

extension JPrimitiveProtocol where JWrapperType.JConvertibleType == Self {
    public static func fromJavaObject(_ ptr: JavaObjectPointer?) -> Self {
        return try! Self.call(JWrapperType.primitiveValueMethodID, on: ptr!, args: [])
    }

    public func toJavaObject() -> JavaObjectPointer? {
        return try! JWrapperType.javaClass.create(ctor: JWrapperType.initWithPrimitiveValueMethodID, args: [self.toJavaParameter()])
    }
}

// MARK: Object Wrappers

public class JObject: JObjectProtocol {
    let ptr: JavaObjectPointer

    public init(_ ptr: JavaObjectPointer) {
        self.ptr = jni.newGlobalRef(ptr)
    }

    public convenience init?(_ ptr: JavaObjectPointer?) {
        if let ptr {
            self.init(ptr as JavaObjectPointer)
        } else {
            return nil
        }
    }

    deinit {
        jni.deleteGlobalRef(ptr)
    }

    /// Return a reference to this object that will not become invalid if this `JObject` struct is deallocated.
    public func safePointer() -> JavaObjectPointer {
        return jni.newLocalRef(ptr)
    }

    public func get<T: JConvertible>(field: JavaFieldID) -> T {
        return T.load(field, of: ptr)
    }

    public func set<T: JConvertible>(field: JavaFieldID, value: T) {
        value.store(field, of: ptr)
    }

    public func call(method: JavaMethodID, args : [JavaParameter]) throws -> Void {
        try jni.withEnvThrowing { $0.CallVoidMethodA($1, ptr, method, args) }
    }

    public func call<T>(method: JavaMethodID, args: [JavaParameter]) throws -> T where T: JConvertible {
        return try T.call(method, on: ptr, args: args)
    }
}

public final class JClass : JObject {
    public let name: String

    public init(_ ptr: JavaObjectPointer, name: String) {
        self.name = name
        super.init(ptr)
    }

    public convenience init(name: String) throws {
        guard let cls = jni.findClass(name) else {
            throw ClassNotFoundError(name: name)
        }
        self.init(cls, name: name)
    }

    public func getFieldID(name: String, sig: String) -> JavaFieldID? {
        defer { jni.checkExceptionAndClear() }
        return jni.withEnv { $0.GetFieldID($1, self.ptr, name, sig) }
    }

    public func getStaticFieldID(name: String, sig: String) -> JavaFieldID? {
        defer { jni.checkExceptionAndClear() }
        return jni.withEnv { $0.GetStaticFieldID($1, self.ptr, name, sig) }
    }

    public func getMethodID(name: String, sig: String) -> JavaMethodID? {
        defer { jni.checkExceptionAndClear() }
        return jni.withEnv { $0.GetMethodID($1, self.ptr, name, sig) }
    }

    public func getStaticMethodID(name: String, sig: String) -> JavaMethodID? {
        defer { jni.checkExceptionAndClear() }
        return jni.withEnv { $0.GetStaticMethodID($1, self.ptr, name, sig) }
    }

    public func create(ctor: JavaMethodID, args: [JavaParameter]) throws -> JavaObjectPointer {
        guard let obj = try jni.withEnvThrowing({ $0.NewObjectA($1, self.ptr, ctor, args) }) else {
            throw JNIError(clear: true) // init should never return nil
        }
        return obj
    }

    public func getStatic<T: JConvertible>(field: JavaFieldID) -> T {
        return T.loadStatic(field, of: ptr)
    }

    public func setStatic<T: JConvertible>(field: JavaFieldID, value: T) {
        value.storeStatic(field, of: self.ptr)
    }

    public func callStatic(method: JavaMethodID, args : [JavaParameter]) throws -> Void {
        try jni.withEnvThrowing { $0.CallStaticVoidMethodA($1, self.ptr, method, args) }
    }

    public func callStatic<T: JConvertible>(method: JavaMethodID, args: [JavaParameter]) throws -> T {
        return try T.callStatic(method, on: self.ptr, args: args)
    }
}

public final class JThrowable: JObject {
    private static let javaClass = try! JClass(name: "java/lang/Throwable")

    public func getMessage() throws -> String? {
        try call(method: Self.getMessageID, args: [])
    }
    private static let getMessageID = javaClass.getMethodID(name: "getMessage", sig: "()Ljava/lang/String;")!

    public func getLocalizedMessage() throws -> String? {
        try call(method: Self.getLocalizedMessageID, args: [])
    }
    private static let getLocalizedMessageID = javaClass.getMethodID(name: "getLocalizedMessage", sig: "()Ljava/lang/String;")!

    public func toString() throws -> String? {
        try call(method: Self.toStringID, args: [])
    }
    private static let toStringID = javaClass.getMethodID(name: "toString", sig: "()Ljava/lang/String;")!

    public func toError() -> ThrowableError {
        return ThrowableError(description: (try? toString()) ?? "A java exception occurred, and an error was raised when trying to get the exception message")
    }
}

// MARK: Primitives

public final class JBoolean: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = Bool
    public static let javaClass = try! JClass(name: "java/lang/Boolean")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(Z)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "booleanValue", sig: "()Z")!
}

extension Bool: JPrimitiveProtocol {
    public typealias JWrapperType = JBoolean

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Bool {
        try jni.withEnvThrowing { $0.CallBooleanMethodA($1, obj, method, args) == JNI_TRUE }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Bool {
        try jni.withEnvThrowing { $0.CallStaticBooleanMethodA($1, cls, method, args) == JNI_TRUE }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Bool {
        jni.withEnv { $0.GetBooleanField($1, obj, field) == JNI_TRUE }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Void {
        jni.withEnv { $0.SetBooleanField($1, obj, field, (self) ? 1 : 0) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Bool {
        jni.withEnv { $0.GetStaticBooleanField($1, cls, field) == JNI_TRUE }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Void {
        jni.withEnv { $0.SetBooleanField($1, cls, field, (self) ? 1 : 0) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(z: (self) ? 1 : 0)
    }
}

final public class JByte: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = Int8
    public static let javaClass = try! JClass(name: "java/lang/Byte")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(B)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "byteValue", sig: "()B")!
}

extension Int8: JPrimitiveProtocol {
    public typealias JWrapperType = JByte

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Int8 {
        try jni.withEnvThrowing { $0.CallByteMethodA($1, obj, method, args) }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Int8 {
        try jni.withEnvThrowing { $0.CallStaticByteMethodA($1, cls, method, args) }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Int8 {
        jni.withEnv { $0.GetByteField($1, obj, field) }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        jni.withEnv { $0.SetByteField($1, obj, field, self) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Int8 {
        jni.withEnv { $0.GetStaticByteField($1, cls, field) }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        jni.withEnv { $0.SetStaticByteField($1, cls, field, self) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(b: self)
    }
}

public final class JChar: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = UInt16
    public static let javaClass = try! JClass(name: "java/lang/Character")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(C)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "charValue", sig: "()C")!
}

extension UInt16: JPrimitiveProtocol {
    public typealias JWrapperType = JChar

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> UInt16 {
        try jni.withEnvThrowing { $0.CallCharMethodA($1, obj, method, args) }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> UInt16 {
        try jni.withEnvThrowing { $0.CallStaticCharMethodA($1, cls, method, args) }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> UInt16 {
        jni.withEnv { $0.GetCharField($1, obj, field) }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        jni.withEnv { $0.SetCharField($1, obj, field, self) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> UInt16 {
        jni.withEnv { $0.GetStaticCharField($1, cls, field) }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        jni.withEnv { $0.SetStaticCharField($1, cls, field, self) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(c: self)
    }
}

public final class JShort: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = Int16
    public static let javaClass = try! JClass(name: "java/lang/Short")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(S)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "shortValue", sig: "()S")!
}

extension Int16: JPrimitiveProtocol {
    public typealias JWrapperType = JShort

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Int16 {
        try jni.withEnvThrowing { $0.CallShortMethodA($1, obj, method, args) }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Int16 {
        try jni.withEnvThrowing { $0.CallStaticShortMethodA($1, cls, method, args) }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Int16 {
        jni.withEnv { $0.GetShortField($1, obj, field) }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        jni.withEnv { $0.SetShortField($1, obj, field, self) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Int16 {
        jni.withEnv { $0.GetStaticShortField($1, cls, field) }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        jni.withEnv { $0.SetStaticShortField($1, cls, field, self) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(s: self)
    }
}

public final class JInteger: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = Int32
    public static let javaClass = try! JClass(name: "java/lang/Integer")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(I)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "intValue", sig: "()I")!
}

extension Int32: JPrimitiveProtocol {
    public typealias JWrapperType = JInteger

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Int32 {
        try jni.withEnvThrowing { $0.CallIntMethodA($1, obj, method, args) }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Int32 {
        try jni.withEnvThrowing { $0.CallStaticIntMethodA($1, cls, method, args) }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Int32 {
        jni.withEnv { $0.GetIntField($1, obj, field) }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        jni.withEnv { $0.SetIntField($1, obj, field, self) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Int32 {
        jni.withEnv { $0.GetStaticIntField($1, cls, field) }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        jni.withEnv { $0.SetStaticIntField($1, cls, field, self) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(i: self)
    }
}

public final class JLong: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = Int64
    public static let javaClass = try! JClass(name: "java/lang/Long")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(J)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "longValue", sig: "()J")!
}

extension Int64: JPrimitiveProtocol {
    public typealias JWrapperType = JLong

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Int64 {
        try jni.withEnvThrowing { $0.CallLongMethodA($1, obj, method, args) }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Int64 {
        try jni.withEnvThrowing { $0.CallStaticLongMethodA($1, cls, method, args) }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Int64 {
        jni.withEnv { $0.GetLongField($1, obj, field) }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        jni.withEnv { $0.SetLongField($1, obj, field, self) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Int64 {
        jni.withEnv { $0.GetStaticLongField($1, cls, field) }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        jni.withEnv { $0.SetStaticLongField($1, cls, field, self) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(j: self)
    }
}

extension Int: JPrimitiveProtocol {
    public typealias JWrapperType = JInteger

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Int {
        return Int(try Int32.call(method, on: obj, args: args))
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Int {
        return Int(try Int32.callStatic(method, on: cls, args: args))
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Int {
        return Int(Int32.load(field, of: obj))
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        Int32(self).store(field, of: obj)
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Int {
        return Int(Int32.loadStatic(field, of: cls))
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        Int32(self).storeStatic(field, of: cls)
    }

    public func toJavaParameter() -> JavaParameter {
        return Int32(self).toJavaParameter()
    }

    public static func fromJavaObject(_ ptr: JavaObjectPointer?) -> Self {
        return Int(Int32.fromJavaObject(ptr))
    }

    public func toJavaObject() -> JavaObjectPointer? {
        return Int32(self).toJavaObject()
    }
}

public final class JFloat: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = Float
    public static let javaClass = try! JClass(name: "java/lang/Float")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(F)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "floatValue", sig: "()F")!
}

extension Float: JPrimitiveProtocol {
    public typealias JWrapperType = JFloat

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Float {
        try jni.withEnvThrowing { $0.CallFloatMethodA($1, obj, method, args) }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Float {
        try jni.withEnvThrowing { $0.CallStaticFloatMethodA($1, cls, method, args) }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Float {
        jni.withEnv { $0.GetFloatField($1, obj, field) }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        jni.withEnv { $0.SetFloatField($1, obj, field, self) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Float {
        jni.withEnv { $0.GetStaticFloatField($1, cls, field) }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        jni.withEnv { $0.SetStaticFloatField($1, cls, field, self) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(f: self)
    }
}

public final class JDouble: JObject, JPrimitiveWrapperProtocol {
    public typealias JConvertibleType = Double
    public static let javaClass = try! JClass(name: "java/lang/Double")
    public static let initWithPrimitiveValueMethodID = javaClass.getMethodID(name: "<init>", sig: "(D)V")!
    public static let primitiveValueMethodID = javaClass.getMethodID(name: "doubleValue", sig: "()D")!
}

extension Double: JPrimitiveProtocol {
    public typealias JWrapperType = JDouble

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Double {
        try jni.withEnvThrowing { $0.CallDoubleMethodA($1, obj, method, args) }
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Double {
        try jni.withEnvThrowing { $0.CallStaticDoubleMethodA($1, cls, method, args) }
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Double {
        jni.withEnv { $0.GetDoubleField($1, obj, field) }
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        jni.withEnv { $0.SetDoubleField($1, obj, field, self) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Double {
        jni.withEnv { $0.GetStaticDoubleField($1, cls, field) }
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        jni.withEnv { $0.SetStaticDoubleField($1, cls, field, self) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(d: self)
    }
}

extension String: JObjectProtocol, JConvertible {
    private static let javaClass = try! JClass(name: "java/lang/String")

    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> String {
        jni.withEnv { jni, env in
            guard let chars = jni.GetStringUTFChars(env, obj, nil) else {
                fatalError("Could not get characters from String")
            }
            defer { jni.ReleaseStringUTFChars(env, obj, chars) }
            guard let str = String(validatingUTF8: chars) else {
                fatalError("Could not get valid UTF8 characters from String")
            }
            return str
        }
    }

    public func toJavaObject() -> JavaString? {
        jni.withEnv { jni, env in
            // NewStringUTF would be more efficient than converting the string to UTF-16, but NewStringUTF uses Java's "modified UTF-8", which doesn't encode characters outside of the BMP in the way Swift expects
            // we could theoretically scan the string to check whether the string can be represented

            // return jni.NewStringUTF(env, self)

            let chars = self.utf16
            let count = jsize(chars.count)

            // withContiguousStorageIfAvailable often returns nil,
            // so fall back to using a ContiguousArray
            return chars.withContiguousStorageIfAvailable {
                return jni.NewString(env, $0.baseAddress, count)
            } ?? ContiguousArray(chars).withUnsafeBufferPointer {
                return jni.NewString(env, $0.baseAddress, count)
            }
        }
    }
}

// MARK: JVM Management


/// That this needs to be manually loaded with `System.loadLibrary("SkipJNI")` in order to have `JNI_OnLoad` called.
///
/// A dynamic library that loads another dynamic library will *not* have `JNI_OnLoad` automatically called.
///
/// The alternative is to `dlsym("JNI_GetCreatedJavaVMs")` from the right shared object file (e.g., `libnativehelper.so` in recent Android APIs), but this is much easier.
@_silgen_name("JNI_OnLoad")
public func JNI_OnLoad(jvm: UnsafeMutablePointer<JavaVM?>, reserved: UnsafeMutableRawPointer) -> JavaInt {
    jni = JNI(jvm: jvm)
    if jni == nil {
        fatalError("SkipJNI: global jni variable was nil after JNI_OnLoad")
    }
    return JavaInt(JNI_VERSION_1_6)
}

/// If the JNI context is nil (e.g., we are running on macOS rather than Android), starts up an embedded JVM process and sets the JNI context from that.
/// - Parameter options: the options that will be used when launching the Java VM
public func ensureJVMAttached(options: JVMOptions = .default, launch: Bool = false) throws {
    if jni != nil {
        return
    }

    // we need to get the host JVM using JNI_GetCreatedJavaVMs, but it is not exported in jni.h,
    // so we need to dlsym it from some library, which has changed over various Android APIs
    // libnativehelper.so added in API 31 (https://github.com/android/ndk/issues/1320) to work around "libart.so" no longer being allowed to load
    for libname in [nil, "libnativehelper.so", "libart.so", "libdvm.so"] {
        let lib = dlopen(libname, RTLD_NOW)
        typealias JavaVMPtr = UnsafeMutablePointer<JavaVM?>
        typealias GetCreatedJavaVMs = @convention(c) (_ pvm: UnsafeMutablePointer<JavaVMPtr?>, _ count: Int32, _ num: UnsafeMutablePointer<Int32>) -> jint

        guard let getCreatedJavaVMs = dlsym(lib, "JNI_GetCreatedJavaVMs").map({ unsafeBitCast($0, to: (GetCreatedJavaVMs).self) }) else {
            continue
        }

        // check to see if we are already running inside of a VM; if so, return the existing VM
        var runningCount: Int32 = 0
        var jvm: JavaVMPtr?
        if getCreatedJavaVMs(&jvm, 1, &runningCount) == JNI_OK, let jvm = jvm {
            jni = JNI(jvm: jvm)
            return
        } else {
            fatalError("unable to invoke getCreatedJavaVMs for lib: \(libname ?? "")")
        }
    }

    if jni == nil && launch{
        #if os(macOS)
        try launchJavaVM(options: options)
        #elseif os(Android)
        throw JVMError(description: "TODO: get jni reference from JNI_GetCreatedJavaVMs")
        #else
        throw JVMError(description: "invokeJava cannot be called on iOS; it only works from an Android app running within a JVM")
        #endif
    }

    if jni == nil {
        throw JVMError(description: "No jni pointer was attached, and could not get/create a JVM instance")
    }
}

#if !SKIP

public struct JVMOptions {
    public static let `default` = JVMOptions()

    public var verboseGarbageCollection = false
    public var verboseClassLoading = false
    public var verboseJNI = false
    public var checkJNI = true
    public var classPath: [String] = []
    public var libraryPath: [String] = []
    public var extDirs: [String] = []
    public var compiler: String? = nil // e.g. "none" to disable JIT

    /// Returns the options as an array of strings to use for JVM initialization
    public var vmoptions: [String] {
        var opts: [String] = []
        if verboseGarbageCollection { opts += ["-verbose:gc"] }
        if verboseClassLoading { opts += ["-verbose:class"] }

        if verboseJNI { opts += ["-verbose:jni"] }
        if checkJNI { opts += ["-Xcheck:jni"] }

        if !classPath.isEmpty { opts += ["-Djava.class.path=" + classPath.joined(separator: ":")] }
        if !libraryPath.isEmpty { opts += ["-Djava.library.path=" + libraryPath.joined(separator: ":")] }
        if !extDirs.isEmpty { opts += ["-Djava.ext.dirs=" + extDirs.joined(separator: ":")] }

        if let compiler = compiler { opts += ["-Djava.compiler=" + compiler] }

        return opts
    }
}

#endif

#if os(macOS)
/// Instantiate an embedded Java Virtual Machine.
/// This is just used in local testing, where a Swift test case needs to be able to call into JNI from a macOS environment
public func launchJavaVM(options: JVMOptions = .default) throws {
    if jni != nil {
        return
    }

    let library = try loadLibJava()

    typealias CreateJavaVM = @convention(c) (_ pvm: UnsafeMutablePointer<UnsafeMutablePointer<JavaVM?>?>?, _ penv: UnsafeMutablePointer<UnsafeMutablePointer<JNIEnv?>?>?, _ args: UnsafeMutableRawPointer) -> jint

    guard let JNI_CreateJavaVM_dlsym = dlsym(library, "JNI_CreateJavaVM").map({ unsafeBitCast($0, to: (CreateJavaVM).self) }) else {
        throw JVMError(description: "Unable to dlsym JNI_CreateJavaVM")
    }

    var pvm: UnsafeMutablePointer<JavaVM?>?
    var penv: UnsafeMutablePointer<JNIEnv?>?
    var jargs = JavaVMInitArgs()
    jargs.version = JNI_VERSION_1_6

    let vmopts = options.vmoptions

    let copts = vmopts.map { NullTerminatedCString($0) }
    jargs.nOptions = jint(copts.count)
    let jopts = UnsafeMutablePointer<JavaVMOption>.allocate(capacity: copts.count)
    for (i, copt) in copts.enumerated() {
        jopts[i].optionString = copt.buffer
    }
    jargs.options = jopts

    // we need to manually dlsym(), or else we get: Undefined symbol: _JNI_CreateJavaVM
    //JNI_CreateJavaVM(&pvm, &penv, nil)

    let success: jint = JNI_CreateJavaVM_dlsym(&pvm, &penv, &jargs)

    guard success == JNI_OK, let pvm = pvm else {
        throw JVMError(description: "Could not launch embedded Java virtual machine: \(success)")
    }

    jni = JNI(jvm: pvm)
}

final class NullTerminatedCString {
    let length: Int
    let buffer: UnsafePointer<CChar>

    init(_ string: String) {
        (length, buffer) = string.withCString {
            let len = Int(strlen($0) + 1)
            let dst = UnsafePointer(strcpy(UnsafeMutablePointer<CChar>.allocate(capacity: len), $0))
            return (len, dst!)
        }
    }

    deinit {
        buffer.deallocate()
    }
}

/// Finds the loads the local dynamic library that contains the JNI entry point functions
/// `JNI_GetCreatedJavaVMs` and `JNI_CreateJavaVM`
private func loadLibJava() throws -> UnsafeMutableRawPointer {
    // if JAVA_HOME is unset, default to the Homebrew installation
    if getenv("JAVA_HOME") == nil {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/opt/java") {
            setenv("JAVA_HOME", "/opt/homebrew/opt/java", 0) // Homebrew ARM location
        } else if FileManager.default.fileExists(atPath: "/usr/local/opt/java") {
            setenv("JAVA_HOME", "/usr/local/opt/java", 0) // Homebrew Intel location
        } else {
            throw JVMError(description: "No JAVA_HOME set, and could not locate default Java installation")
        }
    }
    let JAVA_HOME = getenv("JAVA_HOME")!
    let javaHome = URL(fileURLWithPath: String(validatingUTF8: JAVA_HOME)!)

    let ext: String
    #if os(Windows)
    ext = "dll"
    #elseif os(Linux) || os(Android)
    ext = "so"
    #elseif os(macOS) || os(iOS) || os(tvOS)
    ext = "dylib"
    #endif

    let libs = [
        URL(fileURLWithPath: "jre/lib/server/libjvm.\(ext)", relativeTo: javaHome),
        URL(fileURLWithPath: "lib/server/libjvm.\(ext)", relativeTo: javaHome),
        URL(fileURLWithPath: "lib/libjvm.\(ext)", relativeTo: javaHome),
        URL(fileURLWithPath: "libexec/openjdk.jdk/Contents/Home/lib/server/libjvm.\(ext)", relativeTo: javaHome), // Homebrew
    ]

    guard let lib = libs.first(where: { FileManager.default.isReadableFile(atPath: $0.path) }) else {
        throw JVMError(description: "Could not find libjvm in: \(libs.map(\.path))")
    }

    // TODO: on macOS, reduce signal interception debugging issues by locating libjsig.dylib and adding it to DYLD_INSERT_LIBRARIES
    guard let dylib = dlopen(lib.path, RTLD_NOW) else {
        if let error = dlerror() {
            throw JVMError(description: "dlopen error: \(String(cString: error))")
        } else {
            throw JVMError(description: "Unknown dlopen error")
        }
    }

    return dylib
}
#endif

#endif // !SKIP