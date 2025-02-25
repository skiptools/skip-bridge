// Copyright 2024–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
/// A dynamic object is able to represent any Kotlin object using dynamic member lookups
/// in Swift and reflection in Kotlin.
@dynamicMemberLookup
open class AnyDynamicObject: JObjectProtocol, JConvertible {
    private var object: JObject!
    private var options: JConvertibleOptions!

    /// Supply the class name of the object and arguments to pass to the constructor.
    public convenience init(className: String, options: JConvertibleOptions = .kotlincompat, _ arguments: Any?...) throws {
        try self.init(className: className, options: options, arguments: arguments)
    }

    /// Supply the class name of the object and arguments to pass to the constructor.
    public init(className: String, options: JConvertibleOptions = .kotlincompat, arguments: [Any?]) throws {
        try jniContext {
            let arguments: [Any?]? = arguments.isEmpty ? nil : arguments
            let ptr = try Java_reflectorClass.create(ctor: Java_reflectorClassNameConstructor, options: options, args: [className.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
            self.object = JObject(ptr)
            self.options = options
        }
    }

    /// Supply the class name of the statics to access.
    public init(forStaticsOfClassName className: String, options: JConvertibleOptions = .kotlincompat) throws {
        try jniContext {
            let ptr = try Java_reflectorClass.create(ctor: Java_reflectorStaticsOfClassNameConstructor, options: options, args: [className.toJavaParameter(options: options)])
            self.object = JObject(ptr)
            self.options = options
        }
    }

    /// Interact wih the given Kotlin object in Swift.
    public required init(for object: JavaObjectPointer, options: JConvertibleOptions = .kotlincompat) throws {
        try jniContext {
            let reflectorPtr = try Java_reflectorClass.create(ctor: Java_reflectorConstructor, options: options, args: [object.toJavaParameter(options: options)])
            self.object = JObject(reflectorPtr)
            self.options = options
        }
    }

    public subscript(dynamicMember member: String) -> Bool? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorBooleanProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    // TODO: Character
//    public subscript(dynamicMember member: String) -> Character? {
//        get {
//            jniContext {
//                return try! object.call(method: Java_reflectorCharProperty, options: options, args: [member.toJavaParameter(options: options)])
//            }
//        }
//        set {
//            jniContext {
//                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
//            }
//        }
//    }

    public subscript(dynamicMember member: String) -> Double? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorDoubleProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Float? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorFloatProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorIntProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int8? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorByteProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int16? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorShortProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int32? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorIntProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int64? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorLongProperty, options: options, args: [member.toJavaParameter(options: options)])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    // Allow assignment to any generated AnyDynamicObject type. This is also the fallback the compiler uses in call
    // chaining, i.e. when evaluating `a.b` in `let x: Int = a.b.c`

    public subscript<T: AnyDynamicObject>(dynamicMember member: String) -> T? {
        get {
            jniContext {
                guard let ptr = try! object.call(method: Java_reflectorObjectProperty, options: options, args: [member.toJavaParameter(options: options)]) as JavaObjectPointer? else {
                    return nil
                }
                return try! T.init(for: ptr, options: options)
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    // Allow assignment of return values to any JConvertible

    public subscript<T: JConvertible>(dynamicMember member: String) -> T? {
        get {
            jniContext {
                if T.self == String.self {
                    let string: String? = try! object.call(method: Java_reflectorStringProperty, options: options, args: [member.toJavaParameter(options: options)])
                    return string as! T?
                } else {
                    guard let ptr = try! object.call(method: Java_reflectorObjectProperty, options: options, args: [member.toJavaParameter(options: options)]) as JavaObjectPointer? else {
                        return nil
                    }
                    return T.fromJavaObject(ptr, options: options)
                }
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: options, args: [member.toJavaParameter(options: options), newValue.toJavaParameter(options: options)])
            }
        }
    }

    // Swift will call this variant when invoking a method, i.e. `let x: Int = a.f()`

    public subscript(dynamicMember member: String) -> AnyDynamicObjectFunction {
        return AnyDynamicObjectFunction(object: object, name: member, options: options)
    }

    // JConvertible

    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Self {
        return try! .init(for: obj!, options: options)
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let ptr: JavaObjectPointer = try! object.call(method: Java_reflectorReflecting, options: options, args: [])
        return ptr
    }
}

private let Java_reflectorClass = try! JClass(name: "tools.skip.bridge.Reflector")
private let Java_reflectorConstructor = Java_reflectorClass.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;)V")!
private let Java_reflectorClassNameConstructor = Java_reflectorClass.getMethodID(name: "<init>", sig: "(Ljava/lang/String;Ljava/util/List;)V")!
private let Java_reflectorStaticsOfClassNameConstructor = Java_reflectorClass.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
private let Java_reflectorReflecting = Java_reflectorClass.getMethodID(name: "getReflecting", sig: "()Ljava/lang/Object;")!
private let Java_reflectorSetProperty = Java_reflectorClass.getMethodID(name: "setProperty", sig: "(Ljava/lang/String;Ljava/lang/Object;)V")!
private let Java_reflectorBooleanProperty = Java_reflectorClass.getMethodID(name: "booleanProperty", sig: "(Ljava/lang/String;)Ljava/lang/Boolean;")!
private let Java_reflectorByteProperty = Java_reflectorClass.getMethodID(name: "byteProperty", sig: "(Ljava/lang/String;)Ljava/lang/Byte;")!
private let Java_reflectorCharProperty = Java_reflectorClass.getMethodID(name: "charProperty", sig: "(Ljava/lang/String;)Ljava/lang/Character;")!
private let Java_reflectorDoubleProperty = Java_reflectorClass.getMethodID(name: "doubleProperty", sig: "(Ljava/lang/String;)Ljava/lang/Double;")!
private let Java_reflectorFloatProperty = Java_reflectorClass.getMethodID(name: "floatProperty", sig: "(Ljava/lang/String;)Ljava/lang/Float;")!
private let Java_reflectorIntProperty = Java_reflectorClass.getMethodID(name: "intProperty", sig: "(Ljava/lang/String;)Ljava/lang/Integer;")!
private let Java_reflectorLongProperty = Java_reflectorClass.getMethodID(name: "longProperty", sig: "(Ljava/lang/String;)Ljava/lang/Long;")!
private let Java_reflectorShortProperty = Java_reflectorClass.getMethodID(name: "shortProperty", sig: "(Ljava/lang/String;)Ljava/lang/Short;")!
private let Java_reflectorStringProperty = Java_reflectorClass.getMethodID(name: "stringProperty", sig: "(Ljava/lang/String;)Ljava/lang/String;")!
private let Java_reflectorObjectProperty = Java_reflectorClass.getMethodID(name: "objectProperty", sig: "(Ljava/lang/String;)Ljava/lang/Object;")!

/// A dynamic object function that can be called with any arguments.
@dynamicCallable
public struct AnyDynamicObjectFunction {
    let object: JObject
    let name: String
    let options: JConvertibleOptions

    public func dynamicallyCall(withArguments: [Any?]) throws {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            try object.call(method: Java_reflectorVoidFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            try object.call(method: Java_reflectorVoidKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Bool? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorBooleanFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Bool? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorBooleanKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    // TODO: Character
//    public func dynamicallyCall(withArguments: [Any?]) throws -> Character? {
//        try jniContext {
//            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
//            return try object.call(method: Java_reflectorCharFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlinCompatContainer)])
//        }
//    }
//
//    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Character? {
//        try jniContext {
//            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
//            return try object.call(method: Java_reflectorCharKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
//        }
//    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Double? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorDoubleFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Double? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorDoubleKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Float? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorFloatFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Float? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorFloatKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorIntFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorIntKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int8? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorByteFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int8? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorByteKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int16? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorShortFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int16? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorShortKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int32? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorIntFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int32? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorIntKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int64? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorLongFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int64? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorLongKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
        }
    }

    public func dynamicallyCall<T: AnyDynamicObject>(withArguments: [Any?]) throws -> T? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            guard let ptr = try object.call(method: Java_reflectorObjectFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))]) as JavaObjectPointer? else {
                return nil
            }
            return try T.init(for: ptr, options: options)
        }
    }

    public func dynamicallyCall<T: AnyDynamicObject>(withKeywordArguments: [String: Any?]) throws -> T? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            guard let ptr = try object.call(method: Java_reflectorObjectKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))]) as JavaObjectPointer? else {
                return nil
            }
            return try T.init(for: ptr, options: options)
        }
    }

    public func dynamicallyCall<T: JConvertible>(withArguments: [Any?]) throws -> T? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            if T.self == String.self {
                let string: String? = try object.call(method: Java_reflectorStringFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
                return string as! T?
            } else {
                guard let ptr = try object.call(method: Java_reflectorObjectFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))]) as JavaObjectPointer? else {
                    return nil
                }
                return T.fromJavaObject(ptr, options: options)
            }
        }
    }

    public func dynamicallyCall<T: JConvertible>(withKeywordArguments: [String: Any?]) throws -> T? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            if T.self == String.self {
                let string: String? = try object.call(method: Java_reflectorStringKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))])
                return string as! T?
            } else {
                guard let ptr = try object.call(method: Java_reflectorObjectKeywordFunction, options: options, args: [name.toJavaParameter(options: options), arguments.toJavaParameter(options: options.union(.kotlincompatContainer))]) as JavaObjectPointer? else {
                    return nil
                }
                return T.fromJavaObject(ptr, options: options)
            }
        }
    }
}

private let Java_reflectorVoidFunction = Java_reflectorClass.getMethodID(name: "voidFunction", sig: "(Ljava/lang/String;Ljava/util/List;)V")!
private let Java_reflectorVoidKeywordFunction = Java_reflectorClass.getMethodID(name: "voidFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)V")!
private let Java_reflectorBooleanFunction = Java_reflectorClass.getMethodID(name: "booleanFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Boolean;")!
private let Java_reflectorBooleanKeywordFunction = Java_reflectorClass.getMethodID(name: "booleanFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Boolean;")!
private let Java_reflectorByteFunction = Java_reflectorClass.getMethodID(name: "byteFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Byte;")!
private let Java_reflectorByteKeywordFunction = Java_reflectorClass.getMethodID(name: "byteFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Byte;")!
private let Java_reflectorCharFunction = Java_reflectorClass.getMethodID(name: "charFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Character;")!
private let Java_reflectorCharKeywordFunction = Java_reflectorClass.getMethodID(name: "charFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Character;")!
private let Java_reflectorDoubleFunction = Java_reflectorClass.getMethodID(name: "doubleFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Double;")!
private let Java_reflectorDoubleKeywordFunction = Java_reflectorClass.getMethodID(name: "doubleFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Double;")!
private let Java_reflectorFloatFunction = Java_reflectorClass.getMethodID(name: "floatFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Float;")!
private let Java_reflectorFloatKeywordFunction = Java_reflectorClass.getMethodID(name: "floatFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Float;")!
private let Java_reflectorIntFunction = Java_reflectorClass.getMethodID(name: "intFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Integer;")!
private let Java_reflectorIntKeywordFunction = Java_reflectorClass.getMethodID(name: "intFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Integer;")!
private let Java_reflectorLongFunction = Java_reflectorClass.getMethodID(name: "longFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Long;")!
private let Java_reflectorLongKeywordFunction = Java_reflectorClass.getMethodID(name: "longFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Long;")!
private let Java_reflectorShortFunction = Java_reflectorClass.getMethodID(name: "shortFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Short;")!
private let Java_reflectorShortKeywordFunction = Java_reflectorClass.getMethodID(name: "shortFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Short;")!
private let Java_reflectorStringFunction = Java_reflectorClass.getMethodID(name: "stringFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/String;")!
private let Java_reflectorStringKeywordFunction = Java_reflectorClass.getMethodID(name: "stringFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/String;")!
private let Java_reflectorObjectFunction = Java_reflectorClass.getMethodID(name: "objectFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Object;")!
private let Java_reflectorObjectKeywordFunction = Java_reflectorClass.getMethodID(name: "objectFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Object;")!
