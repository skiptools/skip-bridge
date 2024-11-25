// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A dynamic object is able to represent any Kotlin object using dynamic member lookups
/// in Swift and reflection in Kotlin.
@dynamicMemberLookup
open class AnyDynamicObject: JObjectProtocol, JConvertible {
    private var object: JObject!

    /// Supply the class name of the object and arguments to pass to the constructor.
    public init(reflectingClassName: String, arguments: [Any?]) throws {
        try jniContext {
            let arguments: [Any?]? = arguments.isEmpty ? nil : arguments
            let ptr = try Java_reflectorClass.create(ctor: Java_reflectorClassNameConstructor, args: [reflectingClassName.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            self.object = JObject(ptr)
        }
    }

    /// Interact wih the given Kotlin object in Swift.
    public required init(reflecting: JavaObjectPointer) throws {
        try jniContext {
            let reflectorPtr = try Java_reflectorClass.create(ctor: Java_reflectorConstructor, args: [reflecting.toJavaParameter(options: [])])
            self.object = JObject(reflectorPtr)
        }
    }

    public subscript(dynamicMember member: String) -> Bool {
        get {
            jniContext {
                let ret: Bool? = try! object.call(method: Java_reflectorBooleanProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Bool?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Bool? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorBooleanProperty, options: [], args: [member.toJavaParameter(options: [])])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int {
        get {
            jniContext {
                let ret: Int? = try! object.call(method: Java_reflectorIntProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Int?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorIntProperty, options: [], args: [member.toJavaParameter(options: [])])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
            }
        }
    }

    // Allow assignment to any generated AnyDynamicObject type. This is also the fallback the compiler uses in call
    // chaining, i.e. when evaluating `a.b` in `let x: Int = a.b.c`

    public subscript<T: AnyDynamicObject>(dynamicMember member: String) -> T {
        get {
            jniContext {
                let ptr: JavaObjectPointer? = try! object.call(method: Java_reflectorObjectProperty, options: [], args: [member.toJavaParameter(options: [])])
                return try! T.init(reflecting: ptr!)
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
            }
        }
    }

    public subscript<T: AnyDynamicObject>(dynamicMember member: String) -> T? {
        get {
            jniContext {
                guard let ptr = try! object.call(method: Java_reflectorObjectProperty, options: [], args: [member.toJavaParameter(options: [])]) as JavaObjectPointer? else {
                    return nil
                }
                return try! T.init(reflecting: ptr)
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
            }
        }
    }

    // Allow assignment of return values to any JConvertible

    public subscript<T: JConvertible>(dynamicMember member: String) -> T {
        get {
            jniContext {
                let ptr: JavaObjectPointer? = try! object.call(method: Java_reflectorObjectProperty, options: [], args: [member.toJavaParameter(options: [])])
                return T.fromJavaObject(ptr!, options: .kotlincompat)
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: .kotlincompat)])
            }
        }
    }

    public subscript<T: JConvertible>(dynamicMember member: String) -> T? {
        get {
            jniContext {
                guard let ptr = try! object.call(method: Java_reflectorObjectProperty, options: [], args: [member.toJavaParameter(options: [])]) as JavaObjectPointer? else {
                    return nil
                }
                return T.fromJavaObject(ptr, options: .kotlincompat)
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: .kotlincompat)])
            }
        }
    }

    // Swift will call this variant when invoking a method, i.e. `let x: Int = a.f()`

    public subscript(dynamicMember member: String) -> AnyDynamicObjectFunction {
        return AnyDynamicObjectFunction(object: object, name: member)
    }

    // JConvertible

    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Self {
        return try! .init(reflecting: obj!)
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let ptr: JavaObjectPointer = try! object.call(method: Java_reflectorReflecting, options: [], args: [])
        return ptr
    }
}

private let Java_reflectorClass = try! JClass(name: "tools.skip.bridge.kt.Reflector")
private let Java_reflectorConstructor = Java_reflectorClass.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;)V")!
private let Java_reflectorReflecting = Java_reflectorClass.getMethodID(name: "getReflecting", sig: "()Ljava/lang/Object;")!
private let Java_reflectorClassNameConstructor = Java_reflectorClass.getMethodID(name: "<init>", sig: "(Ljava/lang/String;Ljava/util/List;)V")!
private let Java_reflectorSetProperty = Java_reflectorClass.getMethodID(name: "setProperty", sig: "(Ljava/lang/String;Ljava/lang/Object;)V")!
private let Java_reflectorBooleanProperty = Java_reflectorClass.getMethodID(name: "booleanProperty", sig: "(Ljava/lang/String;)Ljava/lang/Boolean;")!
private let Java_reflectorIntProperty = Java_reflectorClass.getMethodID(name: "intProperty", sig: "(Ljava/lang/String;)Ljava/lang/Integer;")!
private let Java_reflectorObjectProperty = Java_reflectorClass.getMethodID(name: "objectProperty", sig: "(Ljava/lang/String;)Ljava/lang/Object;")!

/// A dynamic object function that can be called with any arguments.
@dynamicCallable
public struct AnyDynamicObjectFunction {
    let object: JObject
    let name: String

    public func dynamicallyCall(withArguments: [Any?]) throws {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            try object.call(method: Java_reflectorVoidFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            try object.call(method: Java_reflectorVoidKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Bool {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Bool? = try object.call(method: Java_reflectorBooleanFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Bool {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Bool? = try object.call(method: Java_reflectorBooleanKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Bool? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorBooleanFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Bool? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorBooleanKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Int? = try object.call(method: Java_reflectorIntFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Int? = try object.call(method: Java_reflectorIntKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorIntFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorIntKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> String {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: String? = try object.call(method: Java_reflectorStringFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> String {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: String? = try object.call(method: Java_reflectorStringKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> String? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorStringFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> String? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorStringKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall<T: AnyDynamicObject>(withArguments: [Any?]) throws -> T {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ptr: JavaObjectPointer? = try object.call(method: Java_reflectorObjectFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return try T.init(reflecting: ptr!)
        }
    }

    public func dynamicallyCall<T: AnyDynamicObject>(withKeywordArguments: [String: Any?]) throws -> T {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ptr: JavaObjectPointer? = try object.call(method: Java_reflectorObjectKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return try T.init(reflecting: ptr!)
        }
    }

    public func dynamicallyCall<T: AnyDynamicObject>(withArguments: [Any?]) throws -> T? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            guard let ptr = try object.call(method: Java_reflectorObjectFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)]) as JavaObjectPointer? else {
                return nil
            }
            return try T.init(reflecting: ptr)
        }
    }

    public func dynamicallyCall<T: AnyDynamicObject>(withKeywordArguments: [String: Any?]) throws -> T? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            guard let ptr = try object.call(method: Java_reflectorObjectKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)]) as JavaObjectPointer? else {
                return nil
            }
            return try T.init(reflecting: ptr)
        }
    }

    public func dynamicallyCall<T: JConvertible>(withArguments: [Any?]) throws -> T {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ptr: JavaObjectPointer? = try object.call(method: Java_reflectorObjectFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return T.fromJavaObject(ptr!, options: .kotlincompat)
        }
    }

    public func dynamicallyCall<T: JConvertible>(withKeywordArguments: [String: Any?]) throws -> T {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ptr: JavaObjectPointer? = try object.call(method: Java_reflectorObjectKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return T.fromJavaObject(ptr!, options: .kotlincompat)
        }
    }

    public func dynamicallyCall<T: JConvertible>(withArguments: [Any?]) throws -> T? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            guard let ptr = try object.call(method: Java_reflectorObjectFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)]) as JavaObjectPointer? else {
                return nil
            }
            return T.fromJavaObject(ptr, options: .kotlincompat)
        }
    }

    public func dynamicallyCall<T: JConvertible>(withKeywordArguments: [String: Any?]) throws -> T? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            guard let ptr = try object.call(method: Java_reflectorObjectKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)]) as JavaObjectPointer? else {
                return nil
            }
            return T.fromJavaObject(ptr, options: .kotlincompat)
        }
    }
}

private let Java_reflectorVoidFunction = Java_reflectorClass.getMethodID(name: "voidFunction", sig: "(Ljava/lang/String;Ljava/util/List;)V")!
private let Java_reflectorVoidKeywordFunction = Java_reflectorClass.getMethodID(name: "voidFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)V")!
private let Java_reflectorBooleanFunction = Java_reflectorClass.getMethodID(name: "booleanFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Boolean;")!
private let Java_reflectorBooleanKeywordFunction = Java_reflectorClass.getMethodID(name: "booleanFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Boolean;")!
private let Java_reflectorIntFunction = Java_reflectorClass.getMethodID(name: "intFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Integer;")!
private let Java_reflectorIntKeywordFunction = Java_reflectorClass.getMethodID(name: "intFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Integer;")!
private let Java_reflectorStringFunction = Java_reflectorClass.getMethodID(name: "stringFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/String;")!
private let Java_reflectorStringKeywordFunction = Java_reflectorClass.getMethodID(name: "stringFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/String;")!
private let Java_reflectorObjectFunction = Java_reflectorClass.getMethodID(name: "objectFunction", sig: "(Ljava/lang/String;Ljava/util/List;)Ljava/lang/Object;")!
private let Java_reflectorObjectKeywordFunction = Java_reflectorClass.getMethodID(name: "objectFunction", sig: "(Ljava/lang/String;Ljava/util/Map;)Ljava/lang/Object;")!
