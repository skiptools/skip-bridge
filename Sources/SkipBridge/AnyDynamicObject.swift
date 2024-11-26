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

    /// Supply the class name of the statics to access.
    public init(reflectingStaticsOfClassName: String) throws {
        try jniContext {
            let ptr = try Java_reflectorClass.create(ctor: Java_reflectorStaticsOfClassNameConstructor, args: [reflectingStaticsOfClassName.toJavaParameter(options: [])])
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

    // TODO: Character
//    public subscript(dynamicMember member: String) -> Character {
//        get {
//            jniContext {
//                let ret: Character? = try! object.call(method: Java_reflectorCharProperty, options: [], args: [member.toJavaParameter(options: [])])
//                return ret!
//            }
//        }
//        set {
//            jniContext {
//                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Character?).toJavaParameter(options: [])])
//            }
//        }
//    }
//
//    public subscript(dynamicMember member: String) -> Character? {
//        get {
//            jniContext {
//                return try! object.call(method: Java_reflectorCharProperty, options: [], args: [member.toJavaParameter(options: [])])
//            }
//        }
//        set {
//            jniContext {
//                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
//            }
//        }
//    }

    public subscript(dynamicMember member: String) -> Double {
        get {
            jniContext {
                let ret: Double? = try! object.call(method: Java_reflectorDoubleProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Double?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Double? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorDoubleProperty, options: [], args: [member.toJavaParameter(options: [])])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Float {
        get {
            jniContext {
                let ret: Float? = try! object.call(method: Java_reflectorFloatProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Float?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Float? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorFloatProperty, options: [], args: [member.toJavaParameter(options: [])])
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

    public subscript(dynamicMember member: String) -> Int8 {
        get {
            jniContext {
                let ret: Int8? = try! object.call(method: Java_reflectorByteProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Int8?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int8? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorByteProperty, options: [], args: [member.toJavaParameter(options: [])])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int16 {
        get {
            jniContext {
                let ret: Int16? = try! object.call(method: Java_reflectorShortProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Int16?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int16? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorShortProperty, options: [], args: [member.toJavaParameter(options: [])])
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), newValue.toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int32 {
        get {
            jniContext {
                let ret: Int32? = try! object.call(method: Java_reflectorIntProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Int32?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int32? {
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

    public subscript(dynamicMember member: String) -> Int64 {
        get {
            jniContext {
                let ret: Int64? = try! object.call(method: Java_reflectorLongProperty, options: [], args: [member.toJavaParameter(options: [])])
                return ret!
            }
        }
        set {
            jniContext {
                try! object.call(method: Java_reflectorSetProperty, options: [], args: [member.toJavaParameter(options: []), (newValue as Int64?).toJavaParameter(options: [])])
            }
        }
    }

    public subscript(dynamicMember member: String) -> Int64? {
        get {
            jniContext {
                return try! object.call(method: Java_reflectorLongProperty, options: [], args: [member.toJavaParameter(options: [])])
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
                if T.self == String.self {
                    let ret: String? = try! object.call(method: Java_reflectorStringProperty, options: [], args: [member.toJavaParameter(options: [])])
                    return ret! as! T
                } else {
                    let ptr: JavaObjectPointer? = try! object.call(method: Java_reflectorObjectProperty, options: [], args: [member.toJavaParameter(options: [])])
                    return T.fromJavaObject(ptr!, options: .kotlincompat)
                }
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
                if T.self == String.self {
                    let string: String? = try! object.call(method: Java_reflectorStringProperty, options: [], args: [member.toJavaParameter(options: [])])
                    return string as! T?
                } else {
                    guard let ptr = try! object.call(method: Java_reflectorObjectProperty, options: [], args: [member.toJavaParameter(options: [])]) as JavaObjectPointer? else {
                        return nil
                    }
                    return T.fromJavaObject(ptr, options: .kotlincompat)
                }
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

    // TODO: Character
//    public func dynamicallyCall(withArguments: [Any?]) throws -> Character {
//        try jniContext {
//            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
//            let ret: Character? = try object.call(method: Java_reflectorCharFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
//            return ret!
//        }
//    }
//
//    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Character {
//        try jniContext {
//            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
//            let ret: Character? = try object.call(method: Java_reflectorCharKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
//            return ret!
//        }
//    }
//
//    public func dynamicallyCall(withArguments: [Any?]) throws -> Character? {
//        try jniContext {
//            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
//            return try object.call(method: Java_reflectorCharFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
//        }
//    }
//
//    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Character? {
//        try jniContext {
//            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
//            return try object.call(method: Java_reflectorCharKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
//        }
//    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Double {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Double? = try object.call(method: Java_reflectorDoubleFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Double {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Double? = try object.call(method: Java_reflectorDoubleKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Double? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorDoubleFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Double? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorDoubleKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Float {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Float? = try object.call(method: Java_reflectorFloatFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Float {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Float? = try object.call(method: Java_reflectorFloatKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Float? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorFloatFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Float? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorFloatKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
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

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int8 {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Int8? = try object.call(method: Java_reflectorByteFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int8 {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Int8? = try object.call(method: Java_reflectorByteKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int8? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorByteFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int8? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorByteKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int16 {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Int16? = try object.call(method: Java_reflectorShortFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int16 {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Int16? = try object.call(method: Java_reflectorShortKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int16? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorShortFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int16? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorShortKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int32 {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Int32? = try object.call(method: Java_reflectorIntFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int32 {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Int32? = try object.call(method: Java_reflectorIntKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int32? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorIntFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int32? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorIntKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int64 {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            let ret: Int64? = try object.call(method: Java_reflectorLongFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int64 {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            let ret: Int64? = try object.call(method: Java_reflectorLongKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
            return ret!
        }
    }

    public func dynamicallyCall(withArguments: [Any?]) throws -> Int64? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            return try object.call(method: Java_reflectorLongFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
        }
    }

    public func dynamicallyCall(withKeywordArguments: [String: Any?]) throws -> Int64? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            return try object.call(method: Java_reflectorLongKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
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
            if T.self == String.self {
                let ret: String? = try object.call(method: Java_reflectorStringFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
                return ret! as! T
            } else {
                let ptr: JavaObjectPointer? = try object.call(method: Java_reflectorObjectFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
                return T.fromJavaObject(ptr!, options: .kotlincompat)
            }
        }
    }

    public func dynamicallyCall<T: JConvertible>(withKeywordArguments: [String: Any?]) throws -> T {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            if T.self == String.self {
                let ret: String? = try object.call(method: Java_reflectorStringKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
                return ret! as! T
            } else {
                let ptr: JavaObjectPointer? = try object.call(method: Java_reflectorObjectKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
                return T.fromJavaObject(ptr!, options: .kotlincompat)
            }
        }
    }

    public func dynamicallyCall<T: JConvertible>(withArguments: [Any?]) throws -> T? {
        try jniContext {
            let arguments: [Any?]? = withArguments.isEmpty ? nil : withArguments
            if T.self == String.self {
                let string: String? = try object.call(method: Java_reflectorStringFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
                return string as! T?
            } else {
                guard let ptr = try object.call(method: Java_reflectorObjectFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)]) as JavaObjectPointer? else {
                    return nil
                }
                return T.fromJavaObject(ptr, options: .kotlincompat)
            }
        }
    }

    public func dynamicallyCall<T: JConvertible>(withKeywordArguments: [String: Any?]) throws -> T? {
        try jniContext {
            let arguments: [String: Any?]? = withKeywordArguments.isEmpty ? nil : withKeywordArguments
            if T.self == String.self {
                let string: String? = try object.call(method: Java_reflectorStringKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)])
                return string as! T?
            } else {
                guard let ptr = try object.call(method: Java_reflectorObjectKeywordFunction, options: [], args: [name.toJavaParameter(options: []), arguments.toJavaParameter(options: .kotlincompat)]) as JavaObjectPointer? else {
                    return nil
                }
                return T.fromJavaObject(ptr, options: .kotlincompat)
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
