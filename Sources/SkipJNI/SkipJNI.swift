// This is free software: you can redistribute and/or modify it
// under the terms of the GNU General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import CJNI
import Foundation

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

// MARK: JNI

/// The single shared singleton JNI instance for the process
public private(set) var jni: JNI! // this gets set "OnLoad" so should always exist


public class JNI {
    /// Our reference to the Java Virtual Machine, to be set on init
    let _jvm: UnsafeMutablePointer<JavaVM?>

    // Normally we init the jni global ourselves in JNI_OnLoad
    public init(jvm: UnsafeMutablePointer<JavaVM?>) {
        self._jvm = jvm
    }
}

extension JNI {
    /// Ensure the `_env` pointer we have is always attached to the current thread
    ///
    /// See: https://developer.android.com/training/articles/perf-jni#threads
    fileprivate func withEnv<T>(_ block: (JNINativeInterface, JNIEnvPointer) throws -> T) rethrows -> T {
        let jvm: JNIInvokeInterface = _jvm.pointee!.pointee

        var tenv: UnsafeMutableRawPointer?
        let threadStatus = jvm.GetEnv(_jvm, &tenv, JavaInt(JNI_VERSION_1_6))

        switch threadStatus {
        case JNI_OK:
            let env = tenv!.assumingMemoryBound(to: JNIEnv?.self)
            // if we're already attached, just invoke the block
            return try block(env.pointee!.pointee, env)
        case JNI_EDETACHED:
            // we weren't attached to the Java thread; attach, perform the block, and then detach
            // see https://developer.android.com/training/articles/perf-jni#threads
            var tenv: JNIEnvPointer!
            if jvm.AttachCurrentThread(_jvm, &tenv, nil) != JNI_OK {
                fatalError("SkipJNI: unable to attach JNI to current thread")
            }

            // This should work in theory, but it invalidates any local references that were created from this thread, possibly before a global reference may have been created, which will then crash the next time the thread is references
            //defer {
            //    if jvm.DetachCurrentThread(_jvm) != JNI_OK {
            //        fatalError("SkipJNI: unable to detach JNI from thread")
            //    }
            //}

            // so instead we register a cleanup function for removing the environment when the thread exits, otherwise we will leak the thread
            let keyCreated = withUnsafeMutablePointer(to: &jniEnvKey, {
                pthread_key_create($0, { _ in
                    // thread destructor callback
                    _ = jni._jvm.pointee?.pointee.DetachCurrentThread(jni._jvm)
                })
            })
            if keyCreated != 0 {
                fatalError("SkipJNI: pthread_key_create failed")
            }
            pthread_setspecific(jniEnvKey, tenv)

            return try block(tenv.pointee!.pointee, tenv)
        case JNI_EVERSION:
            fatalError("SkipJNI: unsupoprted JNI version")
        default:
            fatalError("SkipJNI: unexpected JNI thread status: \(threadStatus)")
        }
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
            throw Throwable(throwable).toError()
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

/// Thread cleanup
fileprivate var jniEnvKey = pthread_key_t()

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

extension JavaBoolean : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = value ? JavaBoolean(JNI_TRUE) : JavaBoolean(JNI_FALSE)
    }
}

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

// MARK: JConvertible

public protocol JConvertible: JParameterConvertible {
    static var jsig: String { get }

    static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Self
    static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Self

    static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) throws -> Self
    func store(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Void

    static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) throws -> Self
    func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Void

    static func fromJavaObject(_ obj: JavaObjectPointer?) throws -> Self
    func toJavaObject() -> JavaObjectPointer?

    //  static func fromJavaArray(_ arr: JavaArray?) -> [Self]
    //  static func toJavaArray(_ arr: [Self]) -> JavaArray?
}


public protocol JNullInitializable: JConvertible {
    init()
    static func fromJavaObject(_ obj: JavaObjectPointer) throws -> Self
}


extension JNullInitializable {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) throws -> Self {
        if let _obj = obj {
            return try fromJavaObject(_obj)
        } else {
            return Self()
        }
    }
}


extension Optional: JObjectConvertible, JConvertible, JParameterConvertible where Wrapped: JObjectConvertible {
    public static var javaClass: JClass {
        return Wrapped.javaClass
    }

    public static func fromJavaObject(_ obj: JavaObjectPointer?) throws -> Optional<Wrapped> {
        if let _obj = obj {
            return try Wrapped.fromJavaObject(_obj)
        }
        return nil
    }

    public func toJavaObject() -> JavaObjectPointer? {
        if let this = self {
            return this.toJavaObject()
        }
        return nil
    }
}


// MARK: JPrimitiveObjectProtocol

public protocol JPrimitiveObjectProtocol: ObjectProtocol {
    associatedtype ConvertibleType: JConvertible
    var value: ConvertibleType { get throws }
    init(_ value: ConvertibleType)
    init(_ obj: JavaObjectPointer)
}


fileprivate protocol JPrimitiveObjectInternalProtocol: JPrimitiveObjectProtocol {
    static var __method__init : JavaMethodID { get }
    static var __method__value : JavaMethodID { get }
}


extension JPrimitiveObjectInternalProtocol {
    public init(_ value: ConvertibleType) {
        // we force try because primitive wrapper initializers should never fail
        try! self.init(Self.javaClass.create(ctor: Self.__method__init, value))
    }

    public var value: ConvertibleType {
        get throws {
            return try self.javaObject.call(method: Self.__method__value)
        }
    }
}


public protocol JPrimitiveConvertible : JNullInitializable {
    associatedtype PrimitiveType: JPrimitiveObjectProtocol
    associatedtype ArrayType

    static func createArray(len: jsize) -> ArrayType?
    static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]?
    static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize)
}

extension JPrimitiveConvertible where PrimitiveType.ConvertibleType == Self {
    public func toJavaObject() -> JavaObjectPointer? {
        return PrimitiveType(self).javaObject.ptr
    }

    public static func fromJavaObject(_ obj: JavaObjectPointer) throws -> Self {
        return try PrimitiveType(obj).value
    }
}



// MARK: Boolean

final public class JBoolean: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = Bool
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Boolean")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(Z)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "booleanValue", sig: "()Z")!
}

extension Bool: JPrimitiveConvertible {
    public typealias PrimitiveType = JBoolean
    public typealias ArrayType = JavaBooleanArray
    public static let jsig = "Z"

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

    public static func createArray(len: jsize) -> JavaBooleanArray? {
        jni.withEnv { $0.NewBooleanArray($1, len) }
    }
    
    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetBooleanArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))).map({ $0 != 0 }) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetBooleanArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(z: (self) ? 1 : 0)
    }
}


// MARK: Byte

final public class JByte: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = Int8
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Byte")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(B)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "byteValue", sig: "()B")!
}


extension Int8: JPrimitiveConvertible {
    public typealias PrimitiveType = JByte
    public typealias ArrayType = JavaByteArray
    public static let jsig = "B"

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

    public static func createArray(len: jsize) -> JavaByteArray? {
        jni.withEnv { $0.NewByteArray($1, len) }
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetByteArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetByteArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(b: self)
    }
}

// MARK: Char

final public class JChar: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = UInt16
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Character")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(C)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "charValue", sig: "()C")!
}


extension UInt16: JPrimitiveConvertible {
    public typealias PrimitiveType = JChar
    public typealias ArrayType = JavaCharArray
    public static let jsig = "C"

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

    public static func createArray(len: jsize) -> JavaCharArray? {
        jni.withEnv { $0.NewCharArray($1, len) }
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetCharArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetCharArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(c: self)
    }
}

// MARK: Short

final public class JShort: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = Int16
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Short")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(S)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "shortValue", sig: "()S")!
}


extension Int16: JPrimitiveConvertible {
    public typealias PrimitiveType = JShort
    public typealias ArrayType = JavaShortArray
    public static let jsig = "S"

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

    public static func createArray(len: jsize) -> JavaShortArray? {
        jni.withEnv { $0.NewShortArray($1, len) }
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetShortArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetShortArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(s: self)
    }
}


// MARK: Integer

final public class JInteger: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = Int32
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Integer")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(I)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "intValue", sig: "()I")!
}


extension Int32: JPrimitiveConvertible {
    public typealias PrimitiveType = JInteger
    public typealias ArrayType = JavaIntArray
    public static let jsig = "I"

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

    public static func createArray(len: jsize) -> JavaIntArray? {
        jni.withEnv { $0.NewIntArray($1, len) }
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetIntArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetIntArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(i: self)
    }
}


// MARK: Long

final public class JLong: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = Int64
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Long")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(J)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "longValue", sig: "()J")!
}


extension Int64: JPrimitiveConvertible {
    public typealias PrimitiveType = JLong
    public typealias ArrayType = JavaLongArray
    public static let jsig = "J"

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

    public static func createArray(len: jsize) -> JavaLongArray? {
        jni.withEnv { $0.NewLongArray($1, len) }
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetLongArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetLongArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(j: self)
    }
}


// MARK: Int

extension Int: JPrimitiveConvertible {
    #if arch(x86_64) || arch(arm64)
    public typealias PrimitiveType = JLong
    public typealias ArrayType = JavaLongArray
    private typealias Convertible = Int64
    public static let jsig = "J"
    #else
    public typealias PrimitiveType = JInteger
    public typealias ArrayType = JavaIntArray
    private typealias Convertible = Int32
    public static let jsig = "I"
    #endif

    public static func fromJavaObject(_ obj: JavaObjectPointer) throws -> Int {
        return Int(try Convertible.fromJavaObject(obj))
    }

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Int {
        return Int(try Convertible.call(method, on: obj, args: args))
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Int {
        return Int(try Convertible.callStatic(method, on: cls, args: args))
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Int {
        return Int(Convertible.load(field, of: obj))
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) {
        Convertible(self).store(field, of: obj)
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Int {
        return Int(Convertible.loadStatic(field, of: cls))
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) {
        Convertible(self).storeStatic(field, of: cls)
    }

    public func toJavaObject() -> JavaObjectPointer? {
        return PrimitiveType(PrimitiveType.ConvertibleType(self)).javaObject.ptr
    }

    public static func createArray(len: jsize) -> ArrayType? {
        #if arch(x86_64) || arch(arm64)
        jni.withEnv { $0.NewLongArray($1, len) }
        #else
        jni.withEnv { $0.NewIntArray($1, len) }
        #endif
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        #if arch(x86_64) || arch(arm64)
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetLongArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
        #else
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetIntArratElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
        #endif
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        #if arch(x86_64) || arch(arm64)
        jni.withEnv { $0.SetLongArrayRegion($1, array, offset, jsize(values.count), values) }
        #else
        jni.withEnv { $0.SetIntArrayRegion($1, array, offset, jsize(values.count), values) }
        #endif
    }

    public func toJavaParameter() -> JavaParameter {
        return Convertible(self).toJavaParameter()
    }
}


// MARK: Float

final public class JFloat: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = Float
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Float")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(F)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "floatValue", sig: "()F")!
}

extension Float: JPrimitiveConvertible {
    public typealias PrimitiveType = JFloat
    public typealias ArrayType = JavaFloatArray
    public static let jsig = "F"

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

    public static func createArray(len: jsize) -> JavaFloatArray? {
        jni.withEnv { $0.NewFloatArray($1, len) }
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetFloatArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetFloatArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(f: self)
    }
}


// MARK: Double

final public class JDouble: Object, JPrimitiveObjectInternalProtocol {
    public typealias ConvertibleType = Double
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Double")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "(D)V")!
    fileprivate static let __method__value = __class.getMethodID(name: "doubleValue", sig: "()D")!
}

extension Double: JPrimitiveConvertible {
    public typealias PrimitiveType = JDouble
    public typealias ArrayType = JavaDoubleArray
    public static let jsig = "D"

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

    public static func createArray(len: jsize) -> JavaDoubleArray? {
        jni.withEnv { $0.NewDoubleArray($1, len) }
    }

    public static func getArrayElements(from array: ArrayType) -> [PrimitiveType.ConvertibleType]? {
        jni.withEnv { Array(UnsafeBufferPointer(start: $0.GetDoubleArrayElements($1, array, nil), count: Int($0.GetArrayLength($1, array)))) }
    }

    public static func setArrayRegion(values: [PrimitiveType.ConvertibleType], into array: ArrayType, offset: jsize) {
        jni.withEnv { $0.SetDoubleArrayRegion($1, array, offset, jsize(values.count), values) }
    }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(d: self)
    }
}


// MARK: JObjectConvertible

public protocol JObjectConvertible: JConvertible {
    static var javaClass: JClass { get }
}

extension JObjectConvertible {
    public static var jsig: String {
        return "L\(try! javaClass.jniName);"
    }

    public static func call(_ method: JavaMethodID, on obj: JavaObjectPointer, args: [JavaParameter]) throws -> Self {
        try fromJavaObject(try jni.withEnvThrowing { $0.CallObjectMethodA($1, obj, method, args) })
    }

    public static func callStatic(_ method: JavaMethodID, on cls: JavaClassPointer, args: [JavaParameter]) throws -> Self {
        try fromJavaObject(try jni.withEnvThrowing { $0.CallStaticObjectMethodA($1, cls, method, args) })
    }

    public static func load(_ field: JavaFieldID, of obj: JavaObjectPointer) throws -> Self {
        try fromJavaObject(jni.withEnv { $0.GetObjectField($1, obj, field) })
    }

    public func store(_ field: JavaFieldID, of obj: JavaObjectPointer) -> Void {
        jni.withEnv { $0.SetObjectField($1, obj, field, toJavaObject()) }
    }

    public static func loadStatic(_ field: JavaFieldID, of cls: JavaClassPointer) throws -> Self {
        try fromJavaObject(jni.withEnv { $0.GetStaticObjectField($1, cls, field) })
    }

    public func storeStatic(_ field: JavaFieldID, of cls: JavaClassPointer) -> Void {
        jni.withEnv { $0.SetStaticObjectField($1, cls, field, toJavaObject()) }
    }

    //  public static func toJavaArray(_ arr: [Self]) -> JavaArray? {
    //    let res = jni.NewObjectArray(env, jsize(arr.count), javaClass.javaObject, nil)
    //    for (index, element) in arr.enumerated() {
    //      if let obj = element.toJavaObject() {
    //        jni.SetObjectArrayElement(env, res, jsize(index), obj)
    //        jni.DeleteLocalRef(env, obj)
    //      }
    //    }
    //    return res
    //  }

    //  public static func fromJavaArray(_ arr: JavaArray?) -> [Self] {
    //    var res: [Self] = []
    //    let count = Int(jni.GetArrayLength(env, arr))
    //
    //    res.reserveCapacity(count)
    //
    //    for i in 0 ..< count{
    //      let obj = jni.GetObjectArrayElement(env, arr, jsize(i))
    //      res.append(fromJavaObject(obj))
    //      if obj != nil {
    //        jni.DeleteLocalRef(env, obj)
    //      }
    //    }
    //    return res
    //  }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(l: toJavaObject())
    }
}

// MARK: String

extension String: JObjectConvertible, JNullInitializable {
    fileprivate static let __class = findJavaClass(fqn: "java/lang/String")!

    public static var javaClass: JClass {
        return __class
    }

    public static func fromJavaObject(_ obj: JavaObjectPointer) throws -> String {
        try jni.withEnv { jnii, env in
            guard let chars = jnii.GetStringUTFChars(env, obj, nil) else {
                throw JNIError(description: "Could not get characters from String", clear: false)
            }
            defer { jnii.ReleaseStringUTFChars(env, obj, chars) }
            guard let str = String(validatingUTF8: chars) else {
                throw JNIError(description: "Could not get valid UTF8 characters from String", clear: false)
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

// MARK: JObject

public class JObject : @unchecked Sendable {
    public let ptr: JavaObjectPointer

    fileprivate static let Object__getClass = Object._class.getMethodID(name: "getClass", sig: "()Ljava/lang/Class;")!

    private lazy var _cls = Result {
        JClass(try jni.synchronized(ptr) { try jni.withEnvThrowing { $0.CallObjectMethodA($1, ptr, Self.Object__getClass, []) } }!)
    }

    public var cls: JClass { get { try! _cls.get() } } // force-unwrap because it is common and should always work

    public init(_ ptr: JavaObjectPointer) {
        self.ptr = jni.newGlobalRef(ptr)
    }

    public convenience init?(_ ptr: JavaObjectPointer?) {
        if let _ptr = ptr {
            self.init(_ptr as JavaObjectPointer)
        } else {
            return nil
        }
    }

    deinit {
        jni.deleteGlobalRef(ptr)
    }


    public func get<T: JConvertible>(field: JavaFieldID) throws -> T {
        return try T.load(field, of: ptr)
    }

    public func get<T: JConvertible>(field: String, sig: String) throws -> T {
        guard let fieldId = cls.getFieldID(name: field, sig: sig) else {
            throw JNIError(description: "Cannot find field \(field) with signature \(sig)", clear: true)
        }
        return try self.get(field: fieldId)
    }

    public func get<T: JConvertible>(field: String) throws -> T {
        return try self.get(field: field, sig: T.jsig)
    }


    public func set<T: JConvertible>(field: JavaFieldID, value: T) {
        value.store(field, of: ptr)
    }

    public func set<T: JConvertible>(field: String, sig: String, value: T) throws {
        guard let fieldId = cls.getFieldID(name: field, sig: sig) else {
            throw JNIError(description: "Cannot find field \(field) with signature \(sig)", clear: true)
        }
        value.store(fieldId, of: ptr)
    }

    public func set<T: JConvertible>(field: String, value: T) throws {
        try self.set(field: field, sig: T.jsig, value: value)
    }


    public func call(method: JavaMethodID, _ args : [JavaParameter]) throws -> Void {
        try jni.withEnvThrowing { $0.CallVoidMethodA($1, ptr, method, args) }
    }

    public func call(method: JavaMethodID, _ args : JParameterConvertible...) throws -> Void {
        try call(method: method, args.map { $0.toJavaParameter() }) as Void
    }

    public func call(method: String, _ args : JConvertible...) throws -> Void {
        let sig = "(\(args.reduce("", { $0 + type(of: $1).jsig})))V"
        guard let methodId = cls.getMethodID(name: method, sig: sig) else  {
            throw JNIError(description: "Cannot find method \(method) with signature \(sig)", clear: true)
        }
        return try call(method: methodId, args.map { $0.toJavaParameter() }) as Void
    }


    public func call<T>(method: JavaMethodID, _ args: [JavaParameter]) throws -> T where T: JConvertible {
        return try T.call(method, on: ptr, args: args)
    }

    public func call<T>(method: JavaMethodID, _ args: JParameterConvertible...) throws -> T where T: JConvertible {
        return try call(method: method, args.map { $0.toJavaParameter() })
    }

    public func call<T>(method: String, _ args : JConvertible...) throws -> T where T: JConvertible {
        let sig = "(\(args.reduce("", { $0 + type(of: $1).jsig})))\(T.jsig)"
        guard let methodId = cls.getMethodID(name: method, sig: sig) else  {
            throw JNIError(description: "Cannot find method \(method) with signature \(sig)", clear: true)
        }
        return try call(method: methodId, args.map { $0.toJavaParameter() })
    }
}


extension JObject : JParameterConvertible {
    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(l: ptr)
    }
}

// MARK: JClass

public final class JClass : JObject {
    fileprivate static let _getName = Class__class.getMethodID(name: "getName", sig: "()Ljava/lang/String;")!

    private lazy var _name: Result<String, Error> = Result { try call(method: Self._getName) }

    public var name: String {
        get throws {
            try _name.get()
        }
    }

    public var jniName: String {
        get throws {
            try name.split(separator: ".").joined(separator: "/")
        }
    }

    fileprivate convenience init(_ obj: JavaObjectPointer, name: String) {
        self.init(obj)
    }

    public convenience init(name: String) throws {
        let jniName = name.split(separator: ".").joined(separator: "/")

        guard let jclazz = jni.findClass(jniName) else {
            throw ClassNotFoundError(name: name)
        }

        self.init(jclazz, name: name)
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

    public func create(ctor: JavaMethodID, _ args: [JavaParameter]) throws -> JavaObjectPointer {
        guard let obj = try jni.withEnvThrowing({ $0.NewObjectA($1, self.ptr, ctor, args) }) else {
            throw JNIError(clear: true) // init should never return nil
        }
        return obj
    }

    public func create(ctor: JavaMethodID, _ params: JavaParameter...) throws -> JavaObjectPointer {
        try create(ctor: ctor, params)
    }

    public func create(ctor: JavaMethodID, _ args: JParameterConvertible...) throws -> JavaObjectPointer {
        try create(ctor: ctor, args.map { $0.toJavaParameter() })
    }

    public func create(_ args: JConvertible...) throws -> JavaObjectPointer {
        let sig = args.reduce("", { $0 + type(of: $1).jsig })
        guard let ctorId = getMethodID(name: "<init>", sig: "(\(sig))V") else {
            throw JNIError(description: "Cannot find constructor with signature (\(sig))V", clear: true)
        }
        return try create(ctor: ctorId, args.map { $0.toJavaParameter() })
    }


    public func getStatic<T: JConvertible>(field: JavaFieldID) throws -> T {
        return try T.loadStatic(field, of: ptr)
    }

    public func getStatic<T: JConvertible>(field: String) throws -> T {
        guard let fieldId = getStaticFieldID(name: field, sig: T.jsig) else {
            throw JNIError(description: "Cannot find static field \(field) with signature \(T.jsig)", clear: true)
        }
        return try self.getStatic(field: fieldId)
    }


    public func setStatic<T: JConvertible>(field: JavaFieldID, value: T) {
        value.storeStatic(field, of: self.ptr)
    }

    public func setStatic<T: JConvertible>(field: String, value: T) throws {
        guard let fieldId = getStaticFieldID(name: field, sig: T.jsig) else {
            throw JNIError(description: "Cannot find static field \(field) with signature \(T.jsig)", clear: true)
        }
        value.storeStatic(fieldId, of: self.ptr)
    }

    public func callStatic(method: JavaMethodID, _ args : [JavaParameter]) throws -> Void {
        try jni.withEnvThrowing { $0.CallStaticVoidMethodA($1, self.ptr, method, args) }
    }

    public func callStatic(method: JavaMethodID, _ args : JParameterConvertible...) throws -> Void {
        try callStatic(method: method, args.map { $0.toJavaParameter() })
    }

    public func callStatic(method: String, _ args : JConvertible...) throws -> Void {
        try callStatic(method: method, args: args)
    }

    public func callStatic(method: String, args: [JConvertible]) throws -> Void {
        let sig = "(\(args.reduce("", { $0 + type(of: $1).jsig})))V"
        try callStatic(method: method, sig: sig, args: args) as Void
    }

    public func callStatic(method: String, sig: String, _ args : JConvertible...) throws -> Void {
        try callStatic(method: method, sig: sig, args: args)
    }

    public func callStatic(method: String, sig: String, args : [JConvertible]) throws -> Void {
        guard let methodId = getStaticMethodID(name: method, sig: sig) else  {
            throw JNIError(description: "Cannot find static method \(method) with signature \(sig)", clear: true)
        }
        try callStatic(method: methodId, args.map { $0.toJavaParameter() }) as Void
    }


    public func callStatic<T: JConvertible>(method: JavaMethodID, _ args: [JavaParameter]) throws -> T {
        return try T.callStatic(method, on: self.ptr, args: args)
    }

    public func callStatic<T: JConvertible>(method: JavaMethodID, _ args: JParameterConvertible...) throws -> T {
        return try callStatic(method: method, args.map { $0.toJavaParameter() })
    }

    public func callStatic<T>(method: String, _ args : JConvertible...) throws -> T where T: JConvertible {
        return try callStatic(method: method, args: args)
    }

    public func callStatic<T>(method: String, args: [JConvertible]) throws -> T where T: JConvertible {
        let sig = "(\(args.reduce("", { $0 + type(of: $1).jsig})))\(T.jsig)"
        return try callStatic(method: method, sig: sig, args: args)
    }

    public func callStatic<T>(method: String, sig: String, _ args : JConvertible...) throws -> T where T: JConvertible {
        return try callStatic(method: method, sig: sig, args: args)
    }

    public func callStatic<T>(method: String, sig: String, args : [JConvertible]) throws -> T where T: JConvertible {
        guard let methodId = getStaticMethodID(name: method, sig: sig) else  {
            throw JNIError(description: "Cannot find static method \(method) with signature \(sig)", clear: true)
        }
        return try callStatic(method: methodId, args.map { $0.toJavaParameter() })
    }
}


// MARK: JThrowable

public final class Throwable: Object {
    public final override class var javaClass: JClass { return __class }
    fileprivate static let __class = findJavaClass(fqn: "java/lang/Throwable")!
    fileprivate static let __method__init = __class.getMethodID(name: "<init>", sig: "()V")!
    fileprivate static let __method__getMessage = __class.getMethodID(name: "getMessage", sig: "()Ljava/lang/String;")!
    fileprivate static let __method__getLocalizedMessage = __class.getMethodID(name: "getLocalizedMessage", sig: "()Ljava/lang/String;")!

    public func getMessage() throws -> String? {
        try self.javaObject.call(method: Self.__method__getMessage, [])
    }

    public func getLocalizedMessage() throws -> String? {
        try self.javaObject.call(method: Self.__method__getLocalizedMessage, [])
    }

    public func toError() -> JavaException {
        return JavaException(description: (try? toString()) ?? "A java exception occurred, and an error was raised when trying to get the exception message")
    }
}

public struct JavaException: Error, CustomStringConvertible {
    public let description: String
}

// MARK: Class book-keeping

fileprivate var __classnameToSwiftClass = Dictionary<String, AnyClass>()
fileprivate var __swiftClassToClassname = Dictionary<ObjectIdentifier, String>()

public func registerJavaClass<T: ObjectProtocol>(_ type: T.Type, fqn: String) -> Void {
    __classnameToSwiftClass[fqn] = type
    __swiftClassToClassname[ObjectIdentifier(type)] = fqn
}


public func findJavaClass(fqn: String) -> JClass? {
    if let jcls = jni.findClass(fqn) {
        let cls = JClass(jcls, name: fqn)
        return cls
    } else {
        jni.checkExceptionAndClear()
    }

    return nil
}


internal func getJavaClass<T: ObjectProtocol>(from type: T.Type) throws -> JClass {
    let typeId = ObjectIdentifier(type)
    guard let fqn = __swiftClassToClassname[typeId] else {
        let fqn = String(String(reflecting: type).map {
            $0 == "." ? "/" : $0
        })

        guard let _cls = findJavaClass(fqn: fqn) else {
            throw JNIError(description: "Cannot find Java class '\(fqn)'", clear: true)
        }

        __swiftClassToClassname[typeId] = fqn
        __classnameToSwiftClass[fqn] = type

        return _cls
    }

    guard let cls = findJavaClass(fqn: fqn) else {
        throw JNIError(description: "Cannot find Java class '\(fqn)'", clear: true)
    }

    return cls
}


internal func mapJavaObject<T: ObjectProtocol>(_ obj: JavaObjectPointer) throws -> T {
    guard let jcls = jni.getObjectClass(obj) else {
        throw JNIError(description: "Cannot get Java class from Java object", clear: true)
    }

    let cls = JClass(jcls)
    let fqn = try! String(cls.name.map{($0 == ".") ? "/" : $0})

    if let clazz = __classnameToSwiftClass[fqn] {
        return (clazz as! T.Type).init(obj)
    } else {
        return T.init(obj)
    }
}


// MARK: ObjectProtocol

public protocol ObjectProtocol: AnyObject, JObjectConvertible {
    init(_ obj: JavaObjectPointer)
    var javaObject: JObject { get }
}


public extension ObjectProtocol {
    func toJavaObject() -> JavaObjectPointer? {
        return javaObject.ptr
    }

    static func fromJavaObject(_ obj: JavaObjectPointer?) throws -> Self {
        guard let _obj = obj else {
            throw JNIError(description: "Cannot instantiate non-null object from nil", clear: true)
        }
        return try mapJavaObject(_obj)
    }
}

public extension ObjectProtocol {
    static var JavaClass: Class<Self> {
        return Class<Self>(self.javaClass.ptr)
    }
}

// MARK: ObjectBase

open class ObjectBase: ObjectProtocol {
    public let javaObject: JObject

    open class var javaClass: JClass {
        return try! getJavaClass(from: self)
    }

    public required init(_ obj: JavaObjectPointer) {
        javaObject = JObject(obj)
    }

    public required init(ctor: JavaMethodID, _ args: [JavaParameter]) throws {
        let obj = try type(of: self).javaClass.create(ctor: ctor, args)
        javaObject = JObject(obj)

        if let ptr_field = javaObject.cls.getFieldID(name: "_ptr", sig: "J") {
            let ptr = unsafeBitCast(self, to: Int.self)
            javaObject.set(field: ptr_field, value: Int64(ptr))
        }
    }
}


extension ObjectBase: Equatable {
    public static func == (lhs: ObjectBase, rhs: ObjectBase) -> Bool {
        return jni.withEnv { $0.IsSameObject($1, lhs.javaObject.ptr, rhs.javaObject.ptr) != 0 }
    }
}


public protocol JInterfaceProxy where Self: Object {
    associatedtype Proto: JObjectConvertible
}

public func cast<T: JInterfaceProxy>(_ obj: Object?, to: T.Type) -> T.Proto? {
    guard let _obj = obj else { return nil}

    guard let proto = _obj as? T.Proto else  {
        return T.init(_obj.javaObject.ptr) as? T.Proto
    }

    return proto
}


public func cast<T: JInterfaceProxy>(_ objs: [Object?], to type: T.Type) -> [T.Proto?] {
    return objs.map{cast($0, to: type)}
}

public protocol JParameterConvertible {
    func toJavaParameter() -> JavaParameter
}


// MARK: Object

open class Object: ObjectBase {
    fileprivate static let _class = JClass(jni.findClass("java/lang/Object")!)

    fileprivate static let _init = _class.getMethodID(name: "<init>", sig: "()V")!

    public init() throws {
        try super.init(ctor: Self._init, [])
    }

    public required init(_ obj: JavaObjectPointer) {
        super.init(obj)
    }

    public required init(ctor: JavaMethodID, _ args: [JavaParameter]) throws {
        try super.init(ctor: ctor, args)
    }

    fileprivate static let _finalize = _class.getMethodID(name: "finalize", sig: "()V")!

    open func finalize() throws {
        try self.javaObject.call(method: Self._finalize, [])
    }

    fileprivate static let _getClass = _class.getMethodID(name: "getClass", sig: "()Ljava/lang/Class;")!

    public func getClass<T0>() throws -> Class<T0>? where T0: Object {
        try self.javaObject.call(method: Self._getClass, [])
    }

    fileprivate static let _hashCode = _class.getMethodID(name: "hashCode", sig: "()I")!

    open func hashCode() throws -> Int32 {
        try self.javaObject.call(method: Self._hashCode, [])
    }

    fileprivate static let _equals = _class.getMethodID(name: "equals", sig: "(Ljava/lang/Object;)Z")!

    open func equals(obj: Object) throws -> Bool {
        try self.javaObject.call(method: Self._equals, [obj.toJavaParameter()])
    }

    fileprivate static let _clone = _class.getMethodID(name: "clone", sig: "()Ljava/lang/Object;")!

    open func clone() throws -> Object? {
        try self.javaObject.call(method: Self._clone, [])
    }

    fileprivate static let _toString = _class.getMethodID(name: "toString", sig: "()Ljava/lang/String;")!

    open func toString() throws -> String? {
        try self.javaObject.call(method: Self._toString, [])
    }

    fileprivate static let _notify = _class.getMethodID(name: "notify", sig: "()V")!

    public func notify() throws {
        try self.javaObject.call(method: Self._notify, [])
    }

    fileprivate static let _notifyAll = _class.getMethodID(name: "notifyAll", sig: "()V")!

    public func notifyAll() throws {
        try self.javaObject.call(method: Self._notifyAll, [])
    }

    fileprivate static let _wait1 = _class.getMethodID(name: "wait", sig: "(J)V")!

    public func wait(millis: Int64) throws {
        try self.javaObject.call(method: Self._wait1, [millis.toJavaParameter()])
    }

    fileprivate static let _wait2 = _class.getMethodID(name: "wait", sig: "(JI)V")!

    public func wait(millis: Int64, nanos: Int32) throws {
        try self.javaObject.call(method: Self._wait2, [millis.toJavaParameter(), nanos.toJavaParameter()])
    }

    fileprivate static let _wait0 = _class.getMethodID(name: "wait", sig: "()V")!

    public func wait() throws {
        try self.javaObject.call(method: Self._wait0, [])
    }
}


// MARK: Class

open class Class<T: JObjectConvertible>: Object {
    public static func forName<T0>(className: String) throws -> Class<T0>? where T0: Object {
        try Class__class.callStatic(method: Class__method__0, [className.toJavaParameter()])
    }

    open func newInstance() throws -> T? {
        try self.javaObject.call(method: Class__method__1, [])
    }

    open func isInstance(object: Object) throws -> Bool {
        try self.javaObject.call(method: Class__method__2, [object.toJavaParameter()])
    }

    open func isAssignableFrom<T0>(c: Class<T0>) throws -> Bool where T0: Object {
        try self.javaObject.call(method: Class__method__3, [c.toJavaParameter()])
    }

    open func isInterface() throws -> Bool {
        try self.javaObject.call(method: Class__method__4, [])
    }

    open func isArray() throws -> Bool {
        try self.javaObject.call(method: Class__method__5, [])
    }

    open func isPrimitive() throws -> Bool {
        try self.javaObject.call(method: Class__method__6, [])
    }

    open func isAnnotation() throws -> Bool {
        try self.javaObject.call(method: Class__method__7, [])
    }

    open func isSynthetic() throws -> Bool {
        try self.javaObject.call(method: Class__method__8, [])
    }

    open func getName() throws -> String? {
        try self.javaObject.call(method: Class__method__9, [])
    }

    open func getSuperclass<T0>() throws -> Class<T0>? where T0: Object {
        try self.javaObject.call(method: Class__method__10, [])
    }

//    open func getInterfaces<T0>() throws -> [Class<T0>?] where T0: Object {
//        try self.javaObject.call(method: Class__method__11, [])
//    }

    open func getComponentType<T0>() throws -> Class<T0>? where T0: Object {
        try self.javaObject.call(method: Class__method__12, [])
    }

    open func getModifiers() throws -> Int32 {
        try self.javaObject.call(method: Class__method__13, [])
    }

//    open func getSigners() throws -> [Object?] {
//        try self.javaObject.call(method: Class__method__14, [])
//    }

    open func getDeclaringClass<T0>() throws -> Class<T0>? where T0: Object {
        try self.javaObject.call(method: Class__method__15, [])
    }

    open func getEnclosingClass<T0>() throws -> Class<T0>? where T0: Object {
        try self.javaObject.call(method: Class__method__16, [])
    }

    open func getSimpleName() throws -> String? {
        try self.javaObject.call(method: Class__method__17, [])
    }

    open func getCanonicalName() throws -> String? {
        try self.javaObject.call(method: Class__method__18, [])
    }

    open func isAnonymousClass() throws -> Bool {
        try self.javaObject.call(method: Class__method__19, [])
    }

    open func isLocalClass() throws -> Bool {
        try self.javaObject.call(method: Class__method__20, [])
    }

    open func isMemberClass() throws -> Bool {
        try self.javaObject.call(method: Class__method__21, [])
    }

//    open func getClasses<T0>() throws -> [Class<T0>?] where T0: Object {
//        try self.javaObject.call(method: Class__method__22, [])
//    }

//    open func getDeclaredClasses<T0>() throws -> [Class<T0>?] where T0: Object {
//        try self.javaObject.call(method: Class__method__23, [])
//    }

//    open func getResource(name: String) throws -> URL? {
//        try self.javaObject.call(method: Class__method__24, [name.toJavaParameter()])
//    }

    open func desiredAssertionStatus() throws -> Bool {
        try self.javaObject.call(method: Class__method__25, [])
    }

    open func isEnum() throws -> Bool {
        try self.javaObject.call(method: Class__method__26, [])
    }

//    open func getEnumConstants() throws -> [T?] {
//        try self.javaObject.call(method: Class__method__27, [])
//    }
//
//    open func cast(obj: Object?) throws -> T? {
//        try self.javaObject.call(method: Class__method__28, [obj.toJavaParameter()])
//    }
//
//    open func asSubclass<U, T0>(clazz: Class<U>?) throws -> Class<T0>? where U: Object, T0: Object {
//        try self.javaObject.call(method: Class__method__29, [clazz.toJavaParameter()])
//    }
}


private let Class__class = findJavaClass(fqn: "java/lang/Class")!

private let Class__method__0 = Class__class.getStaticMethodID(name: "forName", sig: "(Ljava/lang/String;)Ljava/lang/Class;")!
private let Class__method__1 = Class__class.getMethodID(name: "newInstance", sig: "()Ljava/lang/Object;")!
private let Class__method__2 = Class__class.getMethodID(name: "isInstance", sig: "(Ljava/lang/Object;)Z")!
private let Class__method__3 = Class__class.getMethodID(name: "isAssignableFrom", sig: "(Ljava/lang/Class;)Z")!
private let Class__method__4 = Class__class.getMethodID(name: "isInterface", sig: "()Z")!
private let Class__method__5 = Class__class.getMethodID(name: "isArray", sig: "()Z")!
private let Class__method__6 = Class__class.getMethodID(name: "isPrimitive", sig: "()Z")!
private let Class__method__7 = Class__class.getMethodID(name: "isAnnotation", sig: "()Z")!
private let Class__method__8 = Class__class.getMethodID(name: "isSynthetic", sig: "()Z")!
private let Class__method__9 = Class__class.getMethodID(name: "getName", sig: "()Ljava/lang/String;")!
private let Class__method__10 = Class__class.getMethodID(name: "getSuperclass", sig: "()Ljava/lang/Class;")!
private let Class__method__11 = Class__class.getMethodID(name: "getInterfaces", sig: "()[Ljava/lang/Class;")!
private let Class__method__12 = Class__class.getMethodID(name: "getComponentType", sig: "()Ljava/lang/Class;")!
private let Class__method__13 = Class__class.getMethodID(name: "getModifiers", sig: "()I")!
private let Class__method__14 = Class__class.getMethodID(name: "getSigners", sig: "()[Ljava/lang/Object;")!
private let Class__method__15 = Class__class.getMethodID(name: "getDeclaringClass", sig: "()Ljava/lang/Class;")!
private let Class__method__16 = Class__class.getMethodID(name: "getEnclosingClass", sig: "()Ljava/lang/Class;")!
private let Class__method__17 = Class__class.getMethodID(name: "getSimpleName", sig: "()Ljava/lang/String;")!
private let Class__method__18 = Class__class.getMethodID(name: "getCanonicalName", sig: "()Ljava/lang/String;")!
private let Class__method__19 = Class__class.getMethodID(name: "isAnonymousClass", sig: "()Z")!
private let Class__method__20 = Class__class.getMethodID(name: "isLocalClass", sig: "()Z")!
private let Class__method__21 = Class__class.getMethodID(name: "isMemberClass", sig: "()Z")!
private let Class__method__22 = Class__class.getMethodID(name: "getClasses", sig: "()[Ljava/lang/Class;")!
private let Class__method__23 = Class__class.getMethodID(name: "getDeclaredClasses", sig: "()[Ljava/lang/Class;")!
private let Class__method__24 = Class__class.getMethodID(name: "getResource", sig: "(Ljava/lang/String;)Ljava/net/URL;")!
private let Class__method__25 = Class__class.getMethodID(name: "desiredAssertionStatus", sig: "()Z")!
private let Class__method__26 = Class__class.getMethodID(name: "isEnum", sig: "()Z")!
private let Class__method__27 = Class__class.getMethodID(name: "getEnumConstants", sig: "()[Ljava/lang/Object;")!
private let Class__method__28 = Class__class.getMethodID(name: "cast", sig: "(Ljava/lang/Object;)Ljava/lang/Object;")!
private let Class__method__29 = Class__class.getMethodID(name: "asSubclass", sig: "(Ljava/lang/Class;)Ljava/lang/Class;")!


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

