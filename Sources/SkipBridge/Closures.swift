// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A Swift object that is backed by a Java closure in the form of a `kotlin.jvm.functions.FunctionN` object.
public final class JavaBackedClosure<R>: JObject {
    private let options: JConvertibleOptions

    public init(_ ptr: JavaObjectPointer, options: JConvertibleOptions) {
        self.options = options
        super.init(ptr)
    }

    public func invoke() throws -> R {
        return try jniContext {
            let object: JavaObjectPointer? = try call(method: Java_Function0_invoke_methodID, options: options, args: [])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: Any?) throws -> R {
        return try jniContext {
            let p0_java = ((p0 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let object: JavaObjectPointer? = try call(method: Java_Function1_invoke_methodID, options: options, args: [p0_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: Any?, _ p1: Any?) throws -> R {
        return try jniContext {
            let p0_java = ((p0 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p1_java = ((p1 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let object: JavaObjectPointer? = try call(method: Java_Function2_invoke_methodID, options: options, args: [p0_java, p1_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: Any?, _ p1: Any?, _ p2: Any?) throws -> R {
        return try jniContext {
            let p0_java = ((p0 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p1_java = ((p1 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p2_java = ((p2 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let object: JavaObjectPointer? = try call(method: Java_Function3_invoke_methodID, options: options, args: [p0_java, p1_java, p2_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: Any?, _ p1: Any?, _ p2: Any?, _ p3: Any?) throws -> R {
        return try jniContext {
            let p0_java = ((p0 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p1_java = ((p1 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p2_java = ((p2 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p3_java = ((p3 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let object: JavaObjectPointer? = try call(method: Java_Function4_invoke_methodID, options: options, args: [p0_java, p1_java, p2_java, p3_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: Any?, _ p1: Any?, _ p2: Any?, _ p3: Any?, _ p4: Any?) throws -> R {
        return try jniContext {
            let p0_java = ((p0 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p1_java = ((p1 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p2_java = ((p2 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p3_java = ((p3 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let p4_java = ((p4 as? JConvertible)?.toJavaObject(options: options)).toJavaParameter(options: options)
            let object: JavaObjectPointer? = try call(method: Java_Function5_invoke_methodID, options: options, args: [p0_java, p1_java, p2_java, p3_java, p4_java])
            return returnValue(for: object)
        }
    }

    private func returnValue(for object: JavaObjectPointer?) -> R {
        guard R.self != Void.self else {
            return () as! R
        }
        return (R.self as! JConvertible.Type).fromJavaObject(object, options: options) as! R
    }
}

private let Java_Function0_class = try! JClass(name: "kotlin/jvm/functions/Function0")
private let Java_Function0_invoke_methodID = Java_Function0_class.getMethodID(name: "invoke", sig: "()Ljava/lang/Object;")!
private let Java_Function1_class = try! JClass(name: "kotlin/jvm/functions/Function1")
private let Java_Function1_invoke_methodID = Java_Function1_class.getMethodID(name: "invoke", sig: "(Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Function2_class = try! JClass(name: "kotlin/jvm/functions/Function2")
private let Java_Function2_invoke_methodID = Java_Function2_class.getMethodID(name: "invoke", sig: "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Function3_class = try! JClass(name: "kotlin/jvm/functions/Function3")
private let Java_Function3_invoke_methodID = Java_Function3_class.getMethodID(name: "invoke", sig: "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Function4_class = try! JClass(name: "kotlin/jvm/functions/Function4")
private let Java_Function4_invoke_methodID = Java_Function4_class.getMethodID(name: "invoke", sig: "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Function5_class = try! JClass(name: "kotlin/jvm/functions/Function5")
private let Java_Function5_invoke_methodID = Java_Function5_class.getMethodID(name: "invoke", sig: "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;")!

/// A Swift reference type that wraps a 0-parameters closure.
public final class SwiftClosure0 {
    public static func javaObject<R>(for closure: (() -> R)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure0(closure: closure, options: options)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction0_class.create(ctor: Java_SwiftBackedFunction0_constructor_methodID, options: options, args: [swiftPeerPtr.toJavaParameter(options: options)])
    }

    public static func closure<R>(forJavaObject function: JavaObjectPointer?, options: JConvertibleOptions) -> (() -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.tryPeer(of: function, options: options) {
            let closure: SwiftClosure0 = ptr.pointee()!
            return { closure.closure() as! R }
        } else {
            let closure = JavaBackedClosure<R>(function, options: options)
            return { try! closure.invoke() }
        }
    }

    public let closure: () -> Any?
    public let returnType: Any.Type
    public let options: JConvertibleOptions

    public init<R>(closure: @escaping () -> R, options: JConvertibleOptions) {
        self.closure = closure
        self.returnType = R.self
        self.options = options
    }
}

private let Java_SwiftBackedFunction0_class = try! JClass(name: "skip/bridge/kt/SwiftBackedFunction0")
private let Java_SwiftBackedFunction0_constructor_methodID = Java_SwiftBackedFunction0_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction0_Swift_1release")
public func SwiftBackedFunction0_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure0.self)
}
@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction0_Swift_1invoke")
public func SwiftBackedFunction0_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) -> JavaObjectPointer? {
    let value_swift: SwiftClosure0 = Swift_peer.pointee()!
    let c_return_swift = value_swift.closure()
    return value_swift.returnType == Void.self ? nil : (c_return_swift as? JConvertible)?.toJavaObject(options: value_swift.options)
}

/// A Swift reference type that wraps a 1-parameter closure.
public final class SwiftClosure1 {
    public static func javaObject<P0, R>(for closure: ((P0) -> R)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure1(closure: closure, options: options)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction1_class.create(ctor: Java_SwiftBackedFunction1_constructor_methodID, options: options, args: [swiftPeerPtr.toJavaParameter(options: options)])
    }

    public static func closure<P0, R>(forJavaObject function: JavaObjectPointer?, options: JConvertibleOptions) -> ((P0) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.tryPeer(of: function, options: options) {
            let closure: SwiftClosure1 = ptr.pointee()!
            return { p0 in closure.closure(p0) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function, options: options)
            return { p0 in try! closure.invoke(p0) }
        }
    }

    public let closure: (Any?) -> Any?
    public let p0Type: Any.Type
    public let returnType: Any.Type
    public let options: JConvertibleOptions

    public init<P0, R>(closure: @escaping (P0) -> R, options: JConvertibleOptions) {
        self.closure = { p0 in closure(p0 as! P0) }
        self.p0Type = P0.self
        self.returnType = R.self
        self.options = options
    }
}
private let Java_SwiftBackedFunction1_class = try! JClass(name: "skip/bridge/kt/SwiftBackedFunction1")
private let Java_SwiftBackedFunction1_constructor_methodID = Java_SwiftBackedFunction1_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction1_Swift_1release")
public func SwiftBackedFunction1_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure1.self)
}
@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction1_Swift_1invoke")
public func SwiftBackedFunction1_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure1 = Swift_peer.pointee()!
    let p0_swift = AnyBridging.fromAnyTypeJavaObject(p0, toBaseType: value_swift.p0Type, options: value_swift.options)
    let c_return_swift = value_swift.closure(p0_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as? JConvertible)?.toJavaObject(options: value_swift.options)
}

/// A Swift reference type that wraps a 2-parameter closure.
public final class SwiftClosure2 {
    public static func javaObject<P0, P1, R>(for closure: ((P0, P1) -> R)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure2(closure: closure, options: options)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction2_class.create(ctor: Java_SwiftBackedFunction2_constructor_methodID, options: options, args: [swiftPeerPtr.toJavaParameter(options: options)])
    }

    public static func closure<P0, P1, R>(forJavaObject function: JavaObjectPointer?, options: JConvertibleOptions) -> ((P0, P1) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.tryPeer(of: function, options: options) {
            let closure: SwiftClosure2 = ptr.pointee()!
            return { p0, p1 in closure.closure(p0, p1) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function, options: options)
            return { p0, p1 in try! closure.invoke(p0, p1) }
        }
    }

    public let closure: (Any?, Any?) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let returnType: Any.Type
    public let options: JConvertibleOptions

    public init<P0, P1, R>(closure: @escaping (P0, P1) -> R, options: JConvertibleOptions) {
        self.closure = { p0, p1 in closure(p0 as! P0, p1 as! P1) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.returnType = R.self
        self.options = options
    }
}
private let Java_SwiftBackedFunction2_class = try! JClass(name: "skip/bridge/kt/SwiftBackedFunction2")
private let Java_SwiftBackedFunction2_constructor_methodID = Java_SwiftBackedFunction2_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction2_Swift_1release")
public func SwiftBackedFunction2_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure2.self)
}
@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction2_Swift_1invoke")
public func SwiftBackedFunction2_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure2 = Swift_peer.pointee()!
    let p0_swift = AnyBridging.fromAnyTypeJavaObject(p0, toBaseType: value_swift.p0Type, options: value_swift.options)
    let p1_swift = AnyBridging.fromAnyTypeJavaObject(p1, toBaseType: value_swift.p1Type, options: value_swift.options)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as? JConvertible)?.toJavaObject(options: value_swift.options)
}

/// A Swift reference type that wraps a 3-parameter closure.
public final class SwiftClosure3 {
    public static func javaObject<P0, P1, P2, R>(for closure: ((P0, P1, P2) -> R)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure3(closure: closure, options: options)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction3_class.create(ctor: Java_SwiftBackedFunction3_constructor_methodID, options: options, args: [swiftPeerPtr.toJavaParameter(options: options)])
    }

    public static func closure<P0, P1, P2, R>(forJavaObject function: JavaObjectPointer?, options: JConvertibleOptions) -> ((P0, P1, P2) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.tryPeer(of: function, options: options) {
            let closure: SwiftClosure3 = ptr.pointee()!
            return { p0, p1, p2 in closure.closure(p0, p1, p2) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function, options: options)
            return { p0, p1, p2 in try! closure.invoke(p0, p1, p2) }
        }
    }

    public let closure: (Any?, Any?, Any?) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let p2Type: Any.Type
    public let returnType: Any.Type
    public let options: JConvertibleOptions

    public init<P0, P1, P2, R>(closure: @escaping (P0, P1, P2) -> R, options: JConvertibleOptions) {
        self.closure = { p0, p1, p2 in closure(p0 as! P0, p1 as! P1, p2 as! P2) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.p2Type = P2.self
        self.returnType = R.self
        self.options = options
    }
}
private let Java_SwiftBackedFunction3_class = try! JClass(name: "skip/bridge/kt/SwiftBackedFunction3")
private let Java_SwiftBackedFunction3_constructor_methodID = Java_SwiftBackedFunction3_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction3_Swift_1release")
public func SwiftBackedFunction3_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure2.self)
}
@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction3_Swift_1invoke")
public func SwiftBackedFunction3_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?, _ p2: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure3 = Swift_peer.pointee()!
    let p0_swift = AnyBridging.fromAnyTypeJavaObject(p0, toBaseType: value_swift.p0Type, options: value_swift.options)
    let p1_swift = AnyBridging.fromAnyTypeJavaObject(p1, toBaseType: value_swift.p1Type, options: value_swift.options)
    let p2_swift = AnyBridging.fromAnyTypeJavaObject(p2, toBaseType: value_swift.p2Type, options: value_swift.options)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift, p2_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as? JConvertible)?.toJavaObject(options: value_swift.options)
}

/// A Swift reference type that wraps a 4-parameter closure.
public final class SwiftClosure4 {
    public static func javaObject<P0, P1, P2, P3, R>(for closure: ((P0, P1, P2, P3) -> R)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure4(closure: closure, options: options)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction4_class.create(ctor: Java_SwiftBackedFunction4_constructor_methodID, options: options, args: [swiftPeerPtr.toJavaParameter(options: options)])
    }

    public static func closure<P0, P1, P2, P3, R>(forJavaObject function: JavaObjectPointer?, options: JConvertibleOptions) -> ((P0, P1, P2, P3) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.tryPeer(of: function, options: options) {
            let closure: SwiftClosure4 = ptr.pointee()!
            return { p0, p1, p2, p3 in closure.closure(p0, p1, p2, p3) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function, options: options)
            return { p0, p1, p2, p3 in try! closure.invoke(p0, p1, p2, p3) }
        }
    }

    public let closure: (Any?, Any?, Any?, Any?) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let p2Type: Any.Type
    public let p3Type: Any.Type
    public let returnType: Any.Type
    public let options: JConvertibleOptions

    public init<P0, P1, P2, P3, R>(closure: @escaping (P0, P1, P2, P3) -> R, options: JConvertibleOptions) {
        self.closure = { p0, p1, p2, p3 in closure(p0 as! P0, p1 as! P1, p2 as! P2, p3 as! P3) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.p2Type = P2.self
        self.p3Type = P3.self
        self.returnType = R.self
        self.options = options
    }
}
private let Java_SwiftBackedFunction4_class = try! JClass(name: "skip/bridge/kt/SwiftBackedFunction4")
private let Java_SwiftBackedFunction4_constructor_methodID = Java_SwiftBackedFunction4_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction4_Swift_1release")
public func SwiftBackedFunction4_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure4.self)
}
@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction4_Swift_1invoke")
public func SwiftBackedFunction4_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?, _ p2: JavaObjectPointer?, _ p3: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure4 = Swift_peer.pointee()!
    let p0_swift = AnyBridging.fromAnyTypeJavaObject(p0, toBaseType: value_swift.p0Type, options: value_swift.options)
    let p1_swift = AnyBridging.fromAnyTypeJavaObject(p1, toBaseType: value_swift.p1Type, options: value_swift.options)
    let p2_swift = AnyBridging.fromAnyTypeJavaObject(p2, toBaseType: value_swift.p2Type, options: value_swift.options)
    let p3_swift = AnyBridging.fromAnyTypeJavaObject(p3, toBaseType: value_swift.p3Type, options: value_swift.options)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift, p2_swift, p3_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as? JConvertible)?.toJavaObject(options: value_swift.options)
}

/// A Swift reference type that wraps a 5-parameter closure.
public final class SwiftClosure5 {
    public static func javaObject<P0, P1, P2, P3, P4, R>(for closure: ((P0, P1, P2, P3, P4) -> R)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure5(closure: closure, options: options)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction5_class.create(ctor: Java_SwiftBackedFunction5_constructor_methodID, options: options, args: [swiftPeerPtr.toJavaParameter(options: options)])
    }

    public static func closure<P0, P1, P2, P3, P4, R>(forJavaObject function: JavaObjectPointer?, options: JConvertibleOptions) -> ((P0, P1, P2, P3, P4) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.tryPeer(of: function, options: options) {
            let closure: SwiftClosure5 = ptr.pointee()!
            return { p0, p1, p2, p3, p4 in closure.closure(p0, p1, p2, p3, p4) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function, options: options)
            return { p0, p1, p2, p3, p4 in try! closure.invoke(p0, p1, p2, p3, p4) }
        }
    }

    public let closure: (Any?, Any?, Any?, Any?, Any?) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let p2Type: Any.Type
    public let p3Type: Any.Type
    public let p4Type: Any.Type
    public let returnType: Any.Type
    public let options: JConvertibleOptions

    public init<P0, P1, P2, P3, P4, R>(closure: @escaping (P0, P1, P2, P3, P4) -> R, options: JConvertibleOptions) {
        self.closure = { p0, p1, p2, p3, p4 in closure(p0 as! P0, p1 as! P1, p2 as! P2, p3 as! P3, p4 as! P4) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.p2Type = P2.self
        self.p3Type = P3.self
        self.p4Type = P4.self
        self.returnType = R.self
        self.options = options
    }
}
private let Java_SwiftBackedFunction5_class = try! JClass(name: "skip/bridge/kt/SwiftBackedFunction5")
private let Java_SwiftBackedFunction5_constructor_methodID = Java_SwiftBackedFunction5_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction5_Swift_1release")
public func SwiftBackedFunction5_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure5.self)
}
@_cdecl("Java_skip_bridge_kt_SwiftBackedFunction5_Swift_1invoke")
public func SwiftBackedFunction5_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?, _ p2: JavaObjectPointer?, _ p3: JavaObjectPointer?, _ p4: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure5 = Swift_peer.pointee()!
    let p0_swift = AnyBridging.fromAnyTypeJavaObject(p0, toBaseType: value_swift.p0Type, options: value_swift.options)
    let p1_swift = AnyBridging.fromAnyTypeJavaObject(p1, toBaseType: value_swift.p1Type, options: value_swift.options)
    let p2_swift = AnyBridging.fromAnyTypeJavaObject(p2, toBaseType: value_swift.p2Type, options: value_swift.options)
    let p3_swift = AnyBridging.fromAnyTypeJavaObject(p3, toBaseType: value_swift.p3Type, options: value_swift.options)
    let p4_swift = AnyBridging.fromAnyTypeJavaObject(p4, toBaseType: value_swift.p4Type, options: value_swift.options)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift, p2_swift, p3_swift, p4_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as? JConvertible)?.toJavaObject(options: value_swift.options)
}
