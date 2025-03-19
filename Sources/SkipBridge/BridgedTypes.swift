// Copyright 2024–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

//
// NOTE:
// Keep this in sync with our transpiled type below.
//

/// Supported bridged type constants.
public enum BridgedTypes: String {
    case boolean_
    case byte_
    case char_
    case double_
    case float_
    case int_
    case long_
    case short_
    case string_

    case byteArray
    case date
    case flow
    case list
    case locale
    case map
    case result
    case set
    case throwable
    case uuid
    case uri

    case swiftArray
    case swiftAsyncStream
    case swiftAsyncThrowingStream
    case swiftData
    case swiftDate
    case swiftDictionary
    case swiftLocale
    case swiftResult
    case swiftSet
    case swiftUUID
    case swiftURL

    case other
}

#if SKIP

// SKIP @nobridge
public enum BridgedTypes {
    case boolean_
    case byte_
    case char_
    case double_
    case float_
    case int_
    case long_
    case short_
    case string_

    case byteArray
    case date
    case flow
    case list
    case locale
    case map
    case result
    case set
    case throwable
    case uuid
    case uri

    case swiftArray
    case swiftAsyncStream
    case swiftAsyncThrowingStream
    case swiftData
    case swiftDate
    case swiftDictionary
    case swiftLocale
    case swiftResult
    case swiftSet
    case swiftUUID
    case swiftURL

    case other
}

// SKIP @nobridge
public func bridgedTypeOf(_ object: Any) -> BridgedTypes {
    // Likely most common case is a custom-bridged object
    guard !(object is SwiftProjecting) else {
        return .other
    }

    if object is Bool {
        return .boolean_
    } else if object is Int8 {
        return .byte_
    } else if object is Character {
        return .char_
    } else if object is Double {
        return .double_
    } else if object is Float {
        return .float_
    } else if object is Int {
        return .int_
    } else if object is Int64 {
        return .long_
    } else if object is Int16 {
        return .short_
    } else if object is String {
        return .string_
    }

    if object is kotlin.ByteArray {
        return .byteArray
    } else if object is java.util.Date {
        return .date
    } else if object is kotlinx.coroutines.flow.Flow<Any> {
        return .flow
    } else if object is kotlin.collections.List<Any> {
        return .list
    } else if object is java.util.Locale {
        return .locale
    } else if object is kotlin.collections.Map<Any, Any> {
        return .map
    } else if object is kotlin.Result<Any> {
        return .result
    } else if object is kotlin.collections.Set<Any> {
        return .set
    } else if object is kotlin.Throwable {
        return .throwable
    } else if object is java.util.UUID {
        return .uuid
    } else if object is java.net.URI {
        return .uri
    }

    // Use class name so that we don't have a dependency on Skip libraries for these types
    // SKIP INSERT: val className = object_::class.java.name
    switch className {
    case "skip.lib.Array":
        return .swiftArray
    case "skip.lib.AsyncStream":
        return .swiftAsyncStream
    case "skip.lib.AsyncThrowingStream":
        return .swiftAsyncThrowingStream
    case "skip.foundation.Data":
        return .swiftData
    case "skip.foundation.Date":
        return .swiftDate
    case "skip.lib.Dictionary":
        return .swiftDictionary
    case "skip.foundation.Locale":
        return .swiftLocale
    case "skip.lib.Result":
        return .swiftResult
    case "skip.lib.Set":
        return .swiftSet
    default:
        return .other
    }
}

#endif

/// Utilities to convert unknown bridged objects.
public struct AnyBridging {
    private static var JThrowableErrorConverterInit = false

    private static func initJThrowableErrorConverter() {
        if JThrowableErrorConverterInit { return }
        JThrowableErrorConverterInit = true
        JThrowable.errorConverter = { ptr, options in
            AnyBridging.fromJavaObject(ptr, options: options, fallback: {
                JThrowable.descriptionToError(ptr, options: options)
            }) as? Error
        }
    }

    /// Convert an unknown-typed Swift instance to its Java form.
    public static func toJavaObject(_ value: Any?, options: JConvertibleOptions) -> JavaObjectPointer? {
        initJThrowableErrorConverter()
        guard let value else {
            return nil
        }
        if let convertible = value as? JConvertible {
            return convertible.toJavaObject(options: options)
        } else if let error = value as? Error {
            return JThrowable.toThrowable(error, options: options)
        } else {
            // Was this a double optional nil? Is there a way to check? Any casts to Optional<Any> always succeed
            if String(describing: value) == "nil" && Mirror(reflecting: value).displayStyle == .optional {
                return nil
            }
            fatalError("Unable to bridge Swift instance \(value) of type: \(type(of: value))")
        }
    }

    /// Convert a Kotlin/Java instance of a known base type to its Swift projection.
    public static func fromJavaObject<T>(_ ptr: JavaObjectPointer?, toBaseType: T.Type, options: JConvertibleOptions) -> T? {
        initJThrowableErrorConverter()
        guard let ptr else {
            return nil
        }
        // Convert non-polymorphic JConvertibles directly, else fall back to AnyBridging
        if let convertibleType = T.self as? JConvertible.Type, !(T.self is AnyObject.Type) || (T.self is BridgedFinalClass.Type) {
            return convertibleType.fromJavaObject(ptr, options: options) as? T
        } else {
            return AnyBridging.fromJavaObject(ptr, options: options) as? T
        }
    }

    /// Convert an unknown Kotlin/Java instance to its Swift projection.
    public static func fromJavaObject(_ ptr: JavaObjectPointer?, options: JConvertibleOptions, fallback: (() -> Any)? = nil) -> Any? {
        initJThrowableErrorConverter()
        guard let ptr else {
            return nil
        }
        if let projection = tryProjection(of: ptr, options: options) {
            return projection
        }

        let bridgedTypeString = bridgedTypeString(of: ptr, options: options)
        let bridgedType = BridgedTypes(rawValue: bridgedTypeString) ?? .other
        switch bridgedType {
        case .boolean_:
            return Bool.fromJavaObject(ptr, options: options)
        case .byte_:
            return Int8.fromJavaObject(ptr, options: options)
        case .char_:
            // TODO
            // return Character.fromJavaObject(ptr, options: options)
            fatalError("Character is not yet bridgable")
        case .double_:
            return Double.fromJavaObject(ptr, options: options)
        case .float_:
            return Float.fromJavaObject(ptr, options: options)
        case .int_:
            return Int.fromJavaObject(ptr, options: options)
        case .long_:
            return Int64.fromJavaObject(ptr, options: options)
        case .short_:
            return Int16.fromJavaObject(ptr, options: options)
        case .string_:
            return String.fromJavaObject(ptr, options: options)
        case .byteArray:
            return Data.fromJavaObject(ptr, options: options)
        case .date:
            return Date.fromJavaObject(ptr, options: options)
        case .flow:
            return AsyncStream<Any>.fromJavaObject(ptr, options: options)
        case .list:
            return Array<Any>.fromJavaObject(ptr, options: options)
        case .locale:
            return Locale.fromJavaObject(ptr, options: options)
        case .map:
            return Dictionary<AnyHashable, Any>.fromJavaObject(ptr, options: options)
        case .result:
            return Result<Any, Error>.fromJavaObject(ptr, options: options)
        case .set:
            return Array<AnyHashable>.fromJavaObject(ptr, options: options)
        case .throwable:
            return JThrowable.descriptionToError(ptr, options: options)
        case .uuid:
            return UUID.fromJavaObject(ptr, options: options)
        case .uri:
            return URL.fromJavaObject(ptr, options: options)
        case .swiftArray:
            return Array<Any>.fromJavaObject(ptr, options: options)
        case .swiftAsyncStream:
            return AsyncStream<Any>.fromJavaObject(ptr, options: options)
        case .swiftAsyncThrowingStream:
            return AsyncThrowingStream<Any, Error>.fromJavaObject(ptr, options: options)
        case .swiftData:
            return Data.fromJavaObject(ptr, options: options)
        case .swiftDate:
            return Date.fromJavaObject(ptr, options: options)
        case .swiftDictionary:
            return Dictionary<AnyHashable, Any>.fromJavaObject(ptr, options: options)
        case .swiftLocale:
            return Locale.fromJavaObject(ptr, options: options)
        case .swiftResult:
            return Result<Any, Error>.fromJavaObject(ptr, options: options)
        case .swiftSet:
            return Set<AnyHashable>.fromJavaObject(ptr, options: options)
        case .swiftUUID:
            return UUID.fromJavaObject(ptr, options: options)
        case .swiftURL:
            return URL.fromJavaObject(ptr, options: options)
        case .other:
            if let fallback {
                return fallback()
            } else {
                fatalError("Unable to bridge Kotlin/Java instance \(ptr)")
            }
        }
    }

    /// Convert a Kotlin/Java instance of an `Any` base type to its Swift projection.
    public static func fromAnyTypeJavaObject(_ ptr: JavaObjectPointer?, toBaseType: Any.Type, options: JConvertibleOptions) -> Any? {
        initJThrowableErrorConverter()
        guard let ptr else {
            return nil
        }
        // Convert non-polymorphic JConvertibles directly, else fall back to AnyBridging
        if let convertibleType = toBaseType as? JConvertible.Type, !(toBaseType is AnyObject.Type) || (toBaseType is BridgedFinalClass.Type) {
            return convertibleType.fromJavaObject(ptr, options: options)
        } else {
            return AnyBridging.fromJavaObject(ptr, options: options)
        }
    }

    private static func tryProjection(of ptr: JavaObjectPointer, options: JConvertibleOptions) -> Any? {
        let ptr_java = ptr.toJavaParameter(options: options)
        let options_java = options.rawValue.toJavaParameter(options: options)
        let closure_java: JavaObjectPointer? = try! Java_fileClass.callStatic(method: Java_tryProjection_methodID, options: options, args: [ptr_java, options_java])
        let closure: (() -> Any)? = SwiftClosure0.closure(forJavaObject: closure_java, options: options)
        return closure?()
    }

    private static func bridgedTypeString(of ptr: JavaObjectPointer, options: JConvertibleOptions) -> String {
        let ptr_java = ptr.toJavaParameter(options: options)
        return try! Java_fileClass.callStatic(method: Java_bridgedTypeString_methodID, options: options, args: [ptr_java])
    }
}

private let Java_fileClass = try! JClass(name: "skip/bridge/BridgeSupportKt")
private let Java_tryProjection_methodID = Java_fileClass.getStaticMethodID(name: "Swift_projection", sig: "(Ljava/lang/Object;I)Lkotlin/jvm/functions/Function0;")!
private let Java_bridgedTypeString_methodID = Java_fileClass.getStaticMethodID(name: "bridgedTypeStringOf", sig: "(Ljava/lang/Object;)Ljava/lang/String;")!

//
// NOTE:
// The Kotlin version of custom converting types should conform to `SwiftCustomBridged`.
// If it also conforms to `KotlinConverting`, it should convert to and from its underlying
// Kotlin type when the `kotlincompat` option is given.
//

public typealias JObjectConvertible = JObjectProtocol & JConvertible

// MARK: Array

extension Array: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Array<Element> {
        let isKotlincompatContainer = options.contains(.kotlincompatContainer)
        let options = options.subtracting(.kotlincompatContainer)
        // let list = arr.kotlin(nocopy: true)
        let list_java: JavaObjectPointer
        if isKotlincompatContainer || options.contains(.kotlincompat) {
            list_java = obj!
        } else {
            list_java = try! JavaObjectPointer.call(Java_SkipArray_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        let count = try! Int32.call(Java_List_size_methodID, on: list_java, options: options, args: [])
        var arr = Array<Element>()
        for i in 0..<count {
            // arr.append(list.get(i))
            let element_java = try! JavaObjectPointer?.call(Java_List_get_methodID, on: list_java, options: options, args: [i.toJavaParameter(options: options)])
            let element = AnyBridging.fromJavaObject(element_java, toBaseType: Element.self, options: options)!
            arr.append(element)
            if let element_java {
                jni.deleteLocalRef(element_java)
            }
        }
        return arr
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let isKotlincompatContainer = options.contains(.kotlincompatContainer)
        let options = options.subtracting(.kotlincompatContainer)
        // let list = ArrayList(count)
        let list_java = try! Java_ArrayList.create(ctor: Java_ArrayList_constructor_methodID, options: options, args: [Int32(self.count).toJavaParameter(options: options)])
        for element in self {
            // list.add(element)
            let element_java = AnyBridging.toJavaObject(element, options: options)
            let _ = try! Bool.call(Java_ArrayList_add_methodID, on: list_java, options: options, args: [element_java.toJavaParameter(options: options)])
            if let element_java {
                jni.deleteLocalRef(element_java)
            }
        }
        if isKotlincompatContainer || options.contains(.kotlincompat) {
            return list_java
        } else {
            // return Array(list, nocopy: true, shared: false)
            let arr_java = try! Java_SkipArray.create(ctor: Java_SkipArray_constructor_methodID, options: options, args: [list_java.toJavaParameter(options: options), true.toJavaParameter(options: options), false.toJavaParameter(options: options)])
            return arr_java
        }
    }
}

private let Java_SkipArray = try! JClass(name: "skip/lib/Array")
private let Java_SkipArray_constructor_methodID = Java_SkipArray.getMethodID(name: "<init>", sig: "(Ljava/lang/Iterable;ZZ)V")!
private let Java_SkipArray_kotlin_methodID = Java_SkipArray.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/List;")!
private let Java_ArrayList = try! JClass(name: "java/util/ArrayList")
private let Java_ArrayList_constructor_methodID = Java_ArrayList.getMethodID(name: "<init>", sig: "(I)V")!
private let Java_ArrayList_add_methodID = Java_ArrayList.getMethodID(name: "add", sig: "(Ljava/lang/Object;)Z")!
private let Java_List = try! JClass(name: "java/util/List")
private let Java_List_size_methodID = Java_List.getMethodID(name: "size", sig: "()I")!
private let Java_List_get_methodID = Java_List.getMethodID(name: "get", sig: "(I)Ljava/lang/Object;")!

// MARK: AsyncStream

extension AsyncStream: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> AsyncStream<Element> {
        let bridgingDataSourceConstructorMethodID: JavaMethodID
        if options.contains(.kotlincompat) {
            bridgingDataSourceConstructorMethodID = Java_SkipAsyncStreamBridgingDataSource_flowConstructor_methodID
        } else {
            // if let dataSource = stream.swiftDataSource
            let swiftDataSource_java: JavaObjectPointer? = try! obj!.call(method: Java_SkipAsyncStream_swiftDataSource_methodID, options: options, args: [])
            if let swiftDataSource_java {
                // return dataSource.Swift_producer
                let ptr: SwiftObjectPointer = try! swiftDataSource_java.call(method: Java_SkipAsyncStreamSwiftDataSource_Swift_producer_methodID, options: options, args: [])
                let box: TypeErasedAsyncStreamBox = ptr.pointee()!
                return box.stream as! AsyncStream<Element>
            } else {
                bridgingDataSourceConstructorMethodID = Java_SkipAsyncStreamBridgingDataSource_streamConstructor_methodID
            }
        }

        // let dataSource = AsyncStreamBridgingDataSource(stream or flow)
        let dataSource_java = try! Java_SkipAsyncStreamBridgingDataSource.create(ctor: bridgingDataSourceConstructorMethodID, options: options, args: [obj.toJavaParameter(options: options)])
        return AsyncStream { continuation in
            let onNext: (Element) -> Void = {
                continuation.yield($0)
            }
            let onFinish: (JavaObjectPointer?) -> Void = { _ in
                continuation.finish()
            }
            jniContext {
                let onNext_java = SwiftClosure1.javaObject(for: onNext, options: []).toJavaParameter(options: options)
                let onFinish_java = SwiftClosure1.javaObject(for: onFinish, options: []).toJavaParameter(options: options)
                // dataSource.collect(onNext, onFinish)
                try! dataSource_java.call(method: Java_SkipAsyncStreamBridgingDataSource_collect_methodID, options: options, args: [onNext_java, onFinish_java])
            }
        }
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        // let dataSource = AsyncStreamSwiftDataSource(self)
        let box = TypeErasedAsyncStreamBox(stream: self, options: options, next: {
            var itr = makeAsyncIterator()
            return await itr.next()
        })
        let ptr = SwiftObjectPointer.pointer(to: box, retain: true)
        let dataSource_java = try! Java_SkipAsyncStreamSwiftDataSource.create(ctor: Java_SkipAsyncStreamSwiftDataSource_constructor_methodID, options: options, args: [ptr.toJavaParameter(options: options)])
        if options.contains(.kotlincompat) {
            // return dataSource.asFlow()
            let flow_java: JavaObjectPointer = try! dataSource_java.call(method: Java_SkipAsyncStreamSwiftDataSource_asFlow_methodID, options: options, args: [])
            return flow_java
        } else {
            // return AsyncStream(dataSource)
            let stream_java: JavaObjectPointer = try! Java_SkipAsyncStream.create(ctor: Java_SkipAsyncStream_constructor_methodID, options: options, args: [dataSource_java.toJavaParameter(options: options)])
            return stream_java
        }
    }
}

extension AsyncThrowingStream: JObjectConvertible where Failure == Error {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> AsyncThrowingStream<Element, Failure> {
        let bridgingDataSourceConstructorMethodID: JavaMethodID
        if options.contains(.kotlincompat) {
            bridgingDataSourceConstructorMethodID = Java_SkipAsyncStreamBridgingDataSource_flowConstructor_methodID
        } else {
            // if let dataSource = stream.swiftDataSource
            let swiftDataSource_java: JavaObjectPointer? = try! obj!.call(method: Java_SkipAsyncThrowingStream_swiftDataSource_methodID, options: options, args: [])
            if let swiftDataSource_java {
                // return dataSource.Swift_producer
                let ptr: SwiftObjectPointer = try! swiftDataSource_java.call(method: Java_SkipAsyncThrowingStreamSwiftDataSource_Swift_producer_methodID, options: options, args: [])
                let box: TypeErasedAsyncStreamBox = ptr.pointee()!
                return box.stream as! AsyncThrowingStream<Element, Failure>
            } else {
                bridgingDataSourceConstructorMethodID = Java_SkipAsyncStreamBridgingDataSource_throwingStreamConstructor_methodID
            }
        }

        // let dataSource = AsyncStreamBridgingDataSource(stream or flow)
        let dataSource_java = try! Java_SkipAsyncStreamBridgingDataSource.create(ctor: bridgingDataSourceConstructorMethodID, options: options, args: [obj.toJavaParameter(options: options)])
        return AsyncThrowingStream { continuation in
            let onNext: (Element) -> Void = {
                continuation.yield($0)
            }
            let onFinish: (JavaObjectPointer?) -> Void = {
                let error = JThrowable.toError($0, options: options)
                continuation.finish(throwing: error)
            }
            jniContext {
                let onNext_java = SwiftClosure1.javaObject(for: onNext, options: options).toJavaParameter(options: options)
                let onFinish_java = SwiftClosure1.javaObject(for: onFinish, options: options).toJavaParameter(options: options)
                // dataSource.collect(onNext, onFinish)
                try! dataSource_java.call(method: Java_SkipAsyncStreamBridgingDataSource_collect_methodID, options: options, args: [onNext_java, onFinish_java])
            }
        }
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        // let dataSource = AsyncStreamSwiftDataSource(self)
        let box = TypeErasedAsyncStreamBox(stream: self, options: options, next: {
            var itr = makeAsyncIterator()
            return try await itr.next()
        })
        let ptr = SwiftObjectPointer.pointer(to: box, retain: true)
        let dataSource_java = try! Java_SkipAsyncThrowingStreamSwiftDataSource.create(ctor: Java_SkipAsyncThrowingStreamSwiftDataSource_constructor_methodID, options: options, args: [ptr.toJavaParameter(options: options)])
        if options.contains(.kotlincompat) {
            // return dataSource.asFlow()
            let flow_java: JavaObjectPointer = try! dataSource_java.call(method: Java_SkipAsyncThrowingStreamSwiftDataSource_asFlow_methodID, options: options, args: [])
            return flow_java
        } else {
            // return AsyncThrowingStream(dataSource)
            let stream_java: JavaObjectPointer = try! Java_SkipAsyncThrowingStream.create(ctor: Java_SkipAsyncThrowingStream_constructor_methodID, options: options, args: [dataSource_java.toJavaParameter(options: options)])
            return stream_java
        }
    }
}

private final class TypeErasedAsyncStreamBox {
    let stream: Any
    let options: JConvertibleOptions
    let next: () async throws -> Any?

    init(stream: Any, options: JConvertibleOptions, next: @escaping () async throws -> Any?) {
        self.stream = stream
        self.options = options
        self.next = next
    }
}

@_cdecl("Java_skip_lib_AsyncStreamSwiftDataSource_Swift_1next")
public func AsyncStreamSwiftDataSource_Swift_next(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_producer: SwiftObjectPointer, _ callback: JavaObjectPointer) {
    let box_swift: TypeErasedAsyncStreamBox = Swift_producer.pointee()!
    let callback_swift = SwiftClosure1.closure(forJavaObject: callback, options: box_swift.options)! as (Any?) -> Void
    Task {
        let next_swift = try! await box_swift.next()
        callback_swift(next_swift)
    }
}

@_cdecl("Java_skip_lib_AsyncStreamSwiftDataSource_Swift_1release")
public func AsyncStreamSwiftDataSource_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_producer: SwiftObjectPointer) -> SwiftObjectPointer {
    Swift_producer.release(as: TypeErasedAsyncStreamBox.self)
    return SwiftObjectNil
}

@_cdecl("Java_skip_lib_AsyncThrowingStreamSwiftDataSource_Swift_1next")
public func AsyncThrowingStreamSwiftDataSource_Swift_next(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_producer: SwiftObjectPointer, _ callback: JavaObjectPointer) {
    let box_swift: TypeErasedAsyncStreamBox = Swift_producer.pointee()!
    let callback_swift = SwiftClosure2.closure(forJavaObject: callback, options: box_swift.options)! as (Any?, JavaObjectPointer?) -> Void
    Task {
        do {
            let next_swift = try await box_swift.next()
            callback_swift(next_swift, nil)
        } catch {
            jniContext {
                callback_swift(nil, JThrowable.toThrowable(error, options: [])!)
            }
        }
    }
}

@_cdecl("Java_skip_lib_AsyncThrowingStreamSwiftDataSource_Swift_1release")
public func AsyncThrowingStreamSwiftDataSource_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_producer: SwiftObjectPointer) -> SwiftObjectPointer {
    Swift_producer.release(as: TypeErasedAsyncStreamBox.self)
    return SwiftObjectNil
}

private let Java_SkipAsyncStream = try! JClass(name: "skip/lib/AsyncStream")
private let Java_SkipAsyncStream_constructor_methodID = Java_SkipAsyncStream.getMethodID(name: "<init>", sig: "(Lskip/lib/AsyncStreamSwiftDataSource;)V")!
private let Java_SkipAsyncStream_swiftDataSource_methodID = Java_SkipAsyncStream.getMethodID(name: "getSwiftDataSource", sig: "()Lskip/lib/AsyncStreamSwiftDataSource;")!

private let Java_SkipAsyncThrowingStream = try! JClass(name: "skip/lib/AsyncThrowingStream")
private let Java_SkipAsyncThrowingStream_constructor_methodID = Java_SkipAsyncThrowingStream.getMethodID(name: "<init>", sig: "(Lskip/lib/AsyncThrowingStreamSwiftDataSource;)V")!
private let Java_SkipAsyncThrowingStream_swiftDataSource_methodID = Java_SkipAsyncThrowingStream.getMethodID(name: "getSwiftDataSource", sig: "()Lskip/lib/AsyncThrowingStreamSwiftDataSource;")!

private let Java_SkipAsyncStreamBridgingDataSource = try! JClass(name: "skip/lib/AsyncStreamBridgingDataSource")
private let Java_SkipAsyncStreamBridgingDataSource_flowConstructor_methodID = Java_SkipAsyncStreamBridgingDataSource.getMethodID(name: "<init>", sig: "(Lkotlinx/coroutines/flow/Flow;)V")!
private let Java_SkipAsyncStreamBridgingDataSource_streamConstructor_methodID = Java_SkipAsyncStreamBridgingDataSource.getMethodID(name: "<init>", sig: "(Lskip/lib/AsyncStream;)V")!
private let Java_SkipAsyncStreamBridgingDataSource_throwingStreamConstructor_methodID = Java_SkipAsyncStreamBridgingDataSource.getMethodID(name: "<init>", sig: "(Lskip/lib/AsyncThrowingStream;)V")!
private let Java_SkipAsyncStreamBridgingDataSource_collect_methodID = Java_SkipAsyncStreamBridgingDataSource.getMethodID(name: "collect", sig: "(Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;)V")!

private let Java_SkipAsyncStreamSwiftDataSource = try! JClass(name: "skip/lib/AsyncStreamSwiftDataSource")
private let Java_SkipAsyncStreamSwiftDataSource_constructor_methodID = Java_SkipAsyncStreamSwiftDataSource.getMethodID(name: "<init>", sig: "(J)V")!
private let Java_SkipAsyncStreamSwiftDataSource_Swift_producer_methodID = Java_SkipAsyncStreamSwiftDataSource.getMethodID(name: "getSwift_producer", sig: "()J")!
private let Java_SkipAsyncStreamSwiftDataSource_asFlow_methodID = Java_SkipAsyncStreamSwiftDataSource.getMethodID(name: "asFlow", sig: "()Lkotlinx/coroutines/flow/Flow;")!

private let Java_SkipAsyncThrowingStreamSwiftDataSource = try! JClass(name: "skip/lib/AsyncThrowingStreamSwiftDataSource")
private let Java_SkipAsyncThrowingStreamSwiftDataSource_constructor_methodID = Java_SkipAsyncThrowingStreamSwiftDataSource.getMethodID(name: "<init>", sig: "(J)V")!
private let Java_SkipAsyncThrowingStreamSwiftDataSource_Swift_producer_methodID = Java_SkipAsyncThrowingStreamSwiftDataSource.getMethodID(name: "getSwift_producer", sig: "()J")!
private let Java_SkipAsyncThrowingStreamSwiftDataSource_asFlow_methodID = Java_SkipAsyncThrowingStreamSwiftDataSource.getMethodID(name: "asFlow", sig: "()Lkotlinx/coroutines/flow/Flow;")!

// MARK: Data

extension Data: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Data {
        let kotlinByteArray: JavaObjectPointer
        if options.contains(.kotlincompat) {
            kotlinByteArray = obj!
        } else {
            kotlinByteArray = try! JavaObjectPointer.call(Java_SkipData_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        let (bytes, length) = jni.getByteArrayElements(kotlinByteArray)
        defer { jni.releaseByteArrayElements(kotlinByteArray, elements: bytes, mode: .unpin) }
        guard let bytes else {
            return Data()
        }
        return Data(bytes: bytes, count: Int(length))
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        self.withUnsafeBytes { buffer in
            let kotlinByteArray = jni.newByteArray(buffer.baseAddress, size: Int32(count))!
            if options.contains(.kotlincompat) {
                return kotlinByteArray
            } else {
                return try! Java_SkipData.create(ctor: Java_SkipData_constructor_methodID, options: options, args: [kotlinByteArray.toJavaParameter(options: options)])
            }
        }
    }
}

private let Java_SkipData = try! JClass(name: "skip/foundation/Data")
private let Java_SkipData_constructor_methodID = Java_SkipData.getMethodID(name: "<init>", sig: "([B)V")!
private let Java_SkipData_kotlin_methodID = Java_SkipData.getMethodID(name: "kotlin", sig: "(Z)[B")!

// MARK: Date

extension Date: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Date {
        let timeInterval: Double
        if options.contains(.kotlincompat) {
            let millis = try! Int64.call(Java_Date_getTime_methodID, on: obj!, options: options, args: [])
            timeInterval = Double(millis) / 1000.0
        } else {
            timeInterval = try! Double.call(Java_SkipDate_timeIntervalSince1970_methodID, on: obj!, options: options, args: [])
        }
        return Date(timeIntervalSince1970: timeInterval)
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let millis = Int64(timeIntervalSince1970 * 1000.0)
        let utilDate = try! Java_Date.create(ctor: Java_Date_constructor_methodID, options: options, args: [millis.toJavaParameter(options: options)])
        if options.contains(.kotlincompat) {
            return utilDate
        } else {
            return try! Java_SkipDate.create(ctor: Java_SkipDate_constructor_methodID, options: options, args: [utilDate.toJavaParameter(options: options)])
        }
    }
}

private let Java_SkipDate = try! JClass(name: "skip/foundation/Date")
private let Java_SkipDate_constructor_methodID = Java_SkipDate.getMethodID(name: "<init>", sig: "(Ljava/util/Date;)V")!
private let Java_SkipDate_timeIntervalSince1970_methodID = Java_SkipDate.getMethodID(name: "getTimeIntervalSince1970", sig: "()D")!
private let Java_Date = try! JClass(name: "java/util/Date")
private let Java_Date_constructor_methodID = Java_Date.getMethodID(name: "<init>", sig: "(J)V")!
private let Java_Date_getTime_methodID = Java_Date.getMethodID(name: "getTime", sig: "()J")!

// MARK: Dictionary

extension Dictionary: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Dictionary<Key, Value> {
        let isKotlincompatContainer = options.contains(.kotlincompatContainer)
        let options = options.subtracting(.kotlincompatContainer)
        // let map = dict.kotlin(nocopy: true)
        let map_java: JavaObjectPointer
        if isKotlincompatContainer || options.contains(.kotlincompat) {
            map_java = obj!
        } else {
            map_java = try! JavaObjectPointer.call(Java_SkipDictionary_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        // let keySet = map.keySet()
        let keySet_java = try! JavaObjectPointer.call(Java_Map_keySet_methodID, on: map_java, options: options, args: [])
        let iterator_java = try! JavaObjectPointer.call(Java_Set_iterator_methodID, on: keySet_java, options: options, args: [])
        let size = try! Int32.call(Java_Set_size_methodID, on: keySet_java, options: options, args: [])
        var dict = Dictionary<Key, Value>()
        for _ in 0..<size {
            // let key = itr.next(); let value = map.get(key)
            let key_java = try! JavaObjectPointer?.call(Java_Iterator_next_methodID, on: iterator_java, options: options, args: [])
            let value_java = try! JavaObjectPointer?.call(Java_Map_get_methodID, on: map_java, options: options, args: [key_java.toJavaParameter(options: options)])
            let key = AnyBridging.fromJavaObject(key_java, toBaseType: Key.self, options: options)!
            let value = AnyBridging.fromJavaObject(value_java, toBaseType: Value.self, options: options)!
            dict[key] = value
            if let key_java {
                jni.deleteLocalRef(key_java)
            }
            if let value_java {
                jni.deleteLocalRef(value_java)
            }
        }
        return dict
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let isKotlincompatContainer = options.contains(.kotlincompatContainer)
        let options = options.subtracting(.kotlincompatContainer)
        // let map = LinkedHashMap(count)
        let map_java = try! Java_LinkedHashMap.create(ctor: Java_LinkedHashMap_constructor_methodID, options: options, args: [Int32(self.count).toJavaParameter(options: options)])
        for (key, value) in self {
            // map.put(key, value)
            let key_java = AnyBridging.toJavaObject(key, options: options)
            let value_java = AnyBridging.toJavaObject(value, options: options)
            let _ = try! JavaObjectPointer?.call(Java_LinkedHashMap_put_methodID, on: map_java, options: options, args: [key_java.toJavaParameter(options: options), value_java.toJavaParameter(options: options)])
            if let key_java {
                jni.deleteLocalRef(key_java)
            }
            if let value_java {
                jni.deleteLocalRef(value_java)
            }
        }
        if isKotlincompatContainer || options.contains(.kotlincompat) {
            return map_java
        } else {
            // return Dictionary(map, nocopy: true, shared: false)
            let dict_java = try! Java_SkipDictionary.create(ctor: Java_SkipDictionary_constructor_methodID, options: options, args: [map_java.toJavaParameter(options: options), true.toJavaParameter(options: options), false.toJavaParameter(options: options)])
            return dict_java
        }
    }
}

private let Java_SkipDictionary = try! JClass(name: "skip/lib/Dictionary")
private let Java_SkipDictionary_constructor_methodID = Java_SkipDictionary.getMethodID(name: "<init>", sig: "(Ljava/util/Map;ZZ)V")!
private let Java_SkipDictionary_kotlin_methodID = Java_SkipDictionary.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/Map;")!
private let Java_LinkedHashMap = try! JClass(name: "java/util/LinkedHashMap")
private let Java_LinkedHashMap_constructor_methodID = Java_LinkedHashMap.getMethodID(name: "<init>", sig: "(I)V")!
private let Java_LinkedHashMap_put_methodID = Java_LinkedHashMap.getMethodID(name: "put", sig: "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Map = try! JClass(name: "java/util/Map")
private let Java_Map_get_methodID = Java_Map.getMethodID(name: "get", sig: "(Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Map_keySet_methodID = Java_Map.getMethodID(name: "keySet", sig: "()Ljava/util/Set;")!
private let Java_Set = try! JClass(name: "java/util/Set")
private let Java_Set_size_methodID = Java_Set.getMethodID(name: "size", sig: "()I")!
private let Java_Set_iterator_methodID = Java_Set.getMethodID(name: "iterator", sig: "()Ljava/util/Iterator;")!
private let Java_Iterator = try! JClass(name: "java/util/Iterator")
private let Java_Iterator_next_methodID = Java_Iterator.getMethodID(name: "next", sig: "()Ljava/lang/Object;")!

// MARK: Locale

extension Locale: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Locale {
        let identifier: String
        if options.contains(.kotlincompat) {
            identifier = try! String.call(Java_Locale_toLanguageTag_methodID, on: obj!, options: options, args: []).replacing("-", with: "_")
        } else {
            identifier = try! String.call(Java_SkipLocale_identifier_methodID, on: obj!, options: options, args: [])
        }
        return Locale(identifier: identifier)
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        if options.contains(.kotlincompat) {
            let identifier = self.identifier.replacing("_", with: "-")
            return try! Java_Locale.callStatic(method: Java_Locale_forLanguageTag_methodID, options: options, args: [identifier.toJavaParameter(options: options)])
        } else {
            return try! Java_SkipLocale.create(ctor: Java_SkipLocale_constructor_methodID, options: options, args: [self.identifier.toJavaParameter(options: options)])
        }
    }
}

private let Java_SkipLocale = try! JClass(name: "skip/foundation/Locale")
private let Java_SkipLocale_constructor_methodID = Java_SkipLocale.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
private let Java_SkipLocale_identifier_methodID = Java_SkipLocale.getMethodID(name: "getIdentifier", sig: "()Ljava/lang/String;")!
private let Java_Locale = try! JClass(name: "java/util/Locale")
private let Java_Locale_forLanguageTag_methodID = Java_Locale.getStaticMethodID(name: "forLanguageTag", sig: "(Ljava/lang/String;)Ljava/util/Locale;")!
private let Java_Locale_toLanguageTag_methodID = Java_Locale.getMethodID(name: "toLanguageTag", sig: "()Ljava/lang/String;")!

// MARK: Result

extension Result: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Result<Success, Failure> {
        // let result = res.kotlin(nocopy: true)
        let pair_java: JavaObjectPointer
        if options.contains(.kotlincompat) {
            pair_java = obj!
        } else {
            pair_java = try! JavaObjectPointer.call(Java_SkipResult_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        let throwable_java: JavaObjectPointer? = try! pair_java.call(method: Java_Pair_second_methodID, options: options, args: [])
        if let throwable_java {
            let error = JThrowable.toError(throwable_java, options: options) as! Failure
            return .failure(error)
        } else {
            let success_java: JavaObjectPointer? = try! pair_java.call(method: Java_Pair_first_methodID, options: options, args: [])
            let success = AnyBridging.fromJavaObject(success_java, toBaseType: Success.self, options: options)!
            return .success(success)
        }
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let pair_java: JavaObjectPointer
        switch self {
        case .success(let value):
            let value_java = AnyBridging.toJavaObject(value, options: options)
            pair_java = try! Java_Pair.create(ctor: Java_Pair_constructor_methodID, options: options, args: [value_java.toJavaParameter(options: options), (nil as JavaObjectPointer?).toJavaParameter(options: options)])
        case .failure(let error):
            let value_java = JThrowable.toThrowable(error, options: options)!
            pair_java = try! Java_Pair.create(ctor: Java_Pair_constructor_methodID, options: options, args: [(nil as JavaObjectPointer?).toJavaParameter(options: options), value_java.toJavaParameter(options: options)])
        }
        guard !options.contains(.kotlincompat) else {
            return pair_java
        }
        let skipResult_java: JavaObjectPointer = try! Java_SkipResult_fileClass.callStatic(method: Java_SkipResult_constructor_methodID, options: options, args: [pair_java.toJavaParameter(options: options)])
        return skipResult_java
    }
}

private let Java_SkipResult = try! JClass(name: "skip/lib/Result")
private let Java_SkipResult_fileClass = try! JClass(name: "skip/lib/ResultKt")
private let Java_SkipResult_constructor_methodID = Java_SkipResult_fileClass.getStaticMethodID(name: "Result", sig: "(Lkotlin/Pair;)Lskip/lib/Result;")!
private let Java_SkipResult_kotlin_methodID = Java_SkipResult.getMethodID(name: "kotlin", sig: "(Z)Lkotlin/Pair;")!
private let Java_Pair = try! JClass(name: "kotlin/Pair")
private let Java_Pair_constructor_methodID = Java_Pair.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;Ljava/lang/Object;)V")!
private let Java_Pair_first_methodID = Java_Pair.getMethodID(name: "getFirst", sig: "()Ljava/lang/Object;")!
private let Java_Pair_second_methodID = Java_Pair.getMethodID(name: "getSecond", sig: "()Ljava/lang/Object;")!

// MARK: Set

extension Set: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Set<Element> {
        let isKotlincompatContainer = options.contains(.kotlincompatContainer)
        let options = options.subtracting(.kotlincompatContainer)
        // let set = set.kotlin(nocopy: true)
        let set_java: JavaObjectPointer
        if isKotlincompatContainer || options.contains(.kotlincompat) {
            set_java = obj!
        } else {
            set_java = try! JavaObjectPointer.call(Java_SkipSet_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        let iterator_java = try! JavaObjectPointer.call(Java_Set_iterator_methodID, on: set_java, options: options, args: [])
        let size = try! Int32.call(Java_Set_size_methodID, on: set_java, options: options, args: [])
        var set = Set<Element>()
        for _ in 0..<size {
            // set.insert(itr.next())
            let element_java = try! JavaObjectPointer?.call(Java_Iterator_next_methodID, on: iterator_java, options: options, args: [])
            let element = AnyBridging.fromJavaObject(element_java, toBaseType: Element.self, options: options)!
            set.insert(element)
            if let element_java {
                jni.deleteLocalRef(element_java)
            }

        }
        return set
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let isKotlincompatContainer = options.contains(.kotlincompatContainer)
        let options = options.subtracting(.kotlincompatContainer)
        // let set = LinkedHashSet()
        let hashset_java = try! Java_LinkedHashSet.create(ctor: Java_LinkedHashSet_constructor_methodID, options: options, args: [])
        for element in self {
            // set.add(element)
            let element_java = AnyBridging.toJavaObject(element, options: options)
            let _ = try! Bool.call(Java_LinkedHashSet_add_methodID, on: hashset_java, options: options, args: [element_java.toJavaParameter(options: options)])
            if let element_java {
                jni.deleteLocalRef(element_java)
            }
        }
        if isKotlincompatContainer || options.contains(.kotlincompat) {
            return hashset_java
        } else {
            // return Set(set, nocopy: true, shared: false)
            let set_java = try! Java_SkipSet.create(ctor: Java_SkipSet_constructor_methodID, options: options, args: [hashset_java.toJavaParameter(options: options), true.toJavaParameter(options: options), false.toJavaParameter(options: options)])
            return set_java
        }
    }
}

private let Java_SkipSet = try! JClass(name: "skip/lib/Set")
private let Java_SkipSet_constructor_methodID = Java_SkipSet.getMethodID(name: "<init>", sig: "(Ljava/lang/Iterable;ZZ)V")!
private let Java_SkipSet_kotlin_methodID = Java_SkipSet.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/Set;")!
private let Java_LinkedHashSet = try! JClass(name: "java/util/LinkedHashSet")
private let Java_LinkedHashSet_constructor_methodID = Java_LinkedHashSet.getMethodID(name: "<init>", sig: "()V")!
private let Java_LinkedHashSet_add_methodID = Java_LinkedHashSet.getMethodID(name: "add", sig: "(Ljava/lang/Object;)Z")!

// MARK: UUID

extension UUID: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> UUID {
        let uuidString: String
        if options.contains(.kotlincompat) {
            uuidString = try! String.call(Java_UUID_toString_methodID, on: obj!, options: options, args: [])
        } else {
            uuidString = try! String.call(Java_SkipUUID_uuidString_methodID, on: obj!, options: options, args: [])
        }
        return UUID(uuidString: uuidString)!
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let uuidString = self.uuidString
        if options.contains(.kotlincompat) {
            return try! Java_UUID.callStatic(method: Java_UUID_fromString_methodID, options: options, args: [uuidString.toJavaParameter(options: options)])
        } else {
            return try! Java_SkipUUID.create(ctor: Java_SkipUUID_constructor_methodID, options: options, args: [uuidString.toJavaParameter(options: options)])
        }
    }
}

private let Java_SkipUUID = try! JClass(name: "skip/foundation/UUID")
private let Java_SkipUUID_constructor_methodID = Java_SkipUUID.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
private let Java_SkipUUID_uuidString_methodID = Java_SkipUUID.getMethodID(name: "getUuidString", sig: "()Ljava/lang/String;")!
private let Java_UUID = try! JClass(name: "java/util/UUID")
private let Java_UUID_fromString_methodID = Java_UUID.getStaticMethodID(name: "fromString", sig: "(Ljava/lang/String;)Ljava/util/UUID;")!
private let Java_UUID_toString_methodID = Java_UUID.getMethodID(name: "toString", sig: "()Ljava/lang/String;")!

// MARK: URL

extension URL: JObjectConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> URL {
        let absoluteString: String
        if options.contains(.kotlincompat) {
            absoluteString = try! String.call(Java_URI_toString_methodID, on: obj!, options: options, args: [])
        } else {
            absoluteString = try! String.call(Java_SkipURL_absoluteString_methodID, on: obj!, options: options, args: [])
        }
        return URL(string: absoluteString)!
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let absoluteString = self.absoluteString
        if options.contains(.kotlincompat) {
            return try! Java_URI.create(ctor: Java_URI_constructor_methodID, options: options, args: [absoluteString.toJavaParameter(options: options)])
        } else {
            return try! Java_SkipURL.create(ctor: Java_SkipURL_constructor_methodID, options: options, args: [absoluteString.toJavaParameter(options: options), (nil as JavaObjectPointer?).toJavaParameter(options: options)])
        }
    }
}

private let Java_SkipURL = try! JClass(name: "skip/foundation/URL")
private let Java_SkipURL_constructor_methodID = Java_SkipURL.getMethodID(name: "<init>", sig: "(Ljava/lang/String;Lskip/foundation/URL;)V")!
private let Java_SkipURL_absoluteString_methodID = Java_SkipURL.getMethodID(name: "getAbsoluteString", sig: "()Ljava/lang/String;")!
private let Java_URI = try! JClass(name: "java/net/URI")
private let Java_URI_constructor_methodID = Java_URI.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
private let Java_URI_toString_methodID = Java_URI.getMethodID(name: "toString", sig: "()Ljava/lang/String;")!
