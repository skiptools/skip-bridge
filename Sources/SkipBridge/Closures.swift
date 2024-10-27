// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A Swift object that is backed by a Java closure in the form of a `kotlin.jvm.functions.FunctionN` object.
public final class JavaBackedClosure<R>: JObject {
    public func invoke() throws -> R {
        return try jniContext {
            let object: JavaObjectPointer? = try call(method: Java_Function0_invoke_methodID, args: [])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: JConvertible?) throws -> R {
        return try jniContext {
            let p0_java = (p0?.toJavaObject()).toJavaParameter()
            let object: JavaObjectPointer? = try call(method: Java_Function1_invoke_methodID, args: [p0_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: JConvertible?, _ p1: JConvertible?) throws -> R {
        return try jniContext {
            let p0_java = (p0?.toJavaObject()).toJavaParameter()
            let p1_java = (p1?.toJavaObject()).toJavaParameter()
            let object: JavaObjectPointer? = try call(method: Java_Function2_invoke_methodID, args: [p0_java, p1_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: JConvertible?, _ p1: JConvertible?, _ p2: JConvertible?) throws -> R {
        return try jniContext {
            let p0_java = (p0?.toJavaObject()).toJavaParameter()
            let p1_java = (p1?.toJavaObject()).toJavaParameter()
            let p2_java = (p2?.toJavaObject()).toJavaParameter()
            let object: JavaObjectPointer? = try call(method: Java_Function3_invoke_methodID, args: [p0_java, p1_java, p2_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: JConvertible?, _ p1: JConvertible?, _ p2: JConvertible?, _ p3: JConvertible?) throws -> R {
        return try jniContext {
            let p0_java = (p0?.toJavaObject()).toJavaParameter()
            let p1_java = (p1?.toJavaObject()).toJavaParameter()
            let p2_java = (p2?.toJavaObject()).toJavaParameter()
            let p3_java = (p3?.toJavaObject()).toJavaParameter()
            let object: JavaObjectPointer? = try call(method: Java_Function4_invoke_methodID, args: [p0_java, p1_java, p2_java, p3_java])
            return returnValue(for: object)
        }
    }

    public func invoke(_ p0: JConvertible?, _ p1: JConvertible?, _ p2: JConvertible?, _ p3: JConvertible?, _ p4: JConvertible?) throws -> R {
        return try jniContext {
            let p0_java = (p0?.toJavaObject()).toJavaParameter()
            let p1_java = (p1?.toJavaObject()).toJavaParameter()
            let p2_java = (p2?.toJavaObject()).toJavaParameter()
            let p3_java = (p3?.toJavaObject()).toJavaParameter()
            let p4_java = (p4?.toJavaObject()).toJavaParameter()
            let object: JavaObjectPointer? = try call(method: Java_Function5_invoke_methodID, args: [p0_java, p1_java, p2_java, p3_java, p4_java])
            return returnValue(for: object)
        }
    }

    private func returnValue(for object: JavaObjectPointer?) -> R {
        guard R.self != Void.self else {
            return () as! R
        }
        return (R.self as! JConvertible.Type).fromJavaObject(object) as! R
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
    public static func javaObject<R>(for closure: (() -> R)?) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure0(closure: closure)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction0_class.create(ctor: Java_SwiftBackedFunction0_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public static func closure<R>(forJavaObject function: JavaObjectPointer?) -> (() -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.filterPeer(of: function) {
            let closure: SwiftClosure0 = ptr.pointee()!
            return { closure.closure() as! R }
        } else {
            let closure = JavaBackedClosure<R>(function)
            return { try! closure.invoke() }
        }
    }

    public let closure: () -> Any?
    public let returnType: Any.Type

    public init<R>(closure: @escaping () -> R) {
        self.closure = closure
        self.returnType = R.self
    }
}

private let Java_SwiftBackedFunction0_class = try! JClass(name: "skip/bridge/SwiftBackedFunction0")
private let Java_SwiftBackedFunction0_constructor_methodID = Java_SwiftBackedFunction0_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_SwiftBackedFunction0_Swift_1release")
func SwiftBackedFunction0_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure0.self)
}
@_cdecl("Java_skip_bridge_SwiftBackedFunction0_Swift_1invoke")
func SwiftBackedFunction0_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) -> JavaObjectPointer? {
    let value_swift: SwiftClosure0 = Swift_peer.pointee()!
    let c_return_swift = value_swift.closure()
    return value_swift.returnType == Void.self ? nil : (c_return_swift as! JConvertible).toJavaObject()
}

/// A Swift reference type that wraps a 1-parameter closure.
public final class SwiftClosure1 {
    public static func javaObject<P0: JConvertible, R>(for closure: ((P0) -> R)?) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure1(closure: closure)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction1_class.create(ctor: Java_SwiftBackedFunction1_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public static func closure<P0: JConvertible, R>(forJavaObject function: JavaObjectPointer?) -> ((P0) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.filterPeer(of: function) {
            let closure: SwiftClosure1 = ptr.pointee()!
            return { p0 in closure.closure(p0) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function)
            return { p0 in try! closure.invoke(p0) }
        }
    }

    public let closure: (JConvertible) -> Any?
    public let p0Type: Any.Type
    public let returnType: Any.Type

    public init<P0: JConvertible, R>(closure: @escaping (P0) -> R) {
        self.closure = { p0 in closure(p0 as! P0) }
        self.p0Type = P0.self
        self.returnType = R.self
    }
}
private let Java_SwiftBackedFunction1_class = try! JClass(name: "skip/bridge/SwiftBackedFunction1")
private let Java_SwiftBackedFunction1_constructor_methodID = Java_SwiftBackedFunction1_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_SwiftBackedFunction1_Swift_1release")
func SwiftBackedFunction1_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure1.self)
}
@_cdecl("Java_skip_bridge_SwiftBackedFunction1_Swift_1invoke")
func SwiftBackedFunction1_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure1 = Swift_peer.pointee()!
    let p0_swift = (value_swift.p0Type as! JConvertible.Type).fromJavaObject(p0)
    let c_return_swift = value_swift.closure(p0_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as! JConvertible).toJavaObject()
}

/// A Swift reference type that wraps a 2-parameter closure.
public final class SwiftClosure2 {
    public static func javaObject<P0: JConvertible, P1: JConvertible, R>(for closure: ((P0, P1) -> R)?) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure2(closure: closure)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction2_class.create(ctor: Java_SwiftBackedFunction2_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public static func closure<P0: JConvertible, P1: JConvertible, R>(forJavaObject function: JavaObjectPointer?) -> ((P0, P1) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.filterPeer(of: function) {
            let closure: SwiftClosure2 = ptr.pointee()!
            return { p0, p1 in closure.closure(p0, p1) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function)
            return { p0, p1 in try! closure.invoke(p0, p1) }
        }
    }

    public let closure: (JConvertible, JConvertible) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let returnType: Any.Type

    public init<P0: JConvertible, P1: JConvertible, R>(closure: @escaping (P0, P1) -> R) {
        self.closure = { p0, p1 in closure(p0 as! P0, p1 as! P1) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.returnType = R.self
    }
}
private let Java_SwiftBackedFunction2_class = try! JClass(name: "skip/bridge/SwiftBackedFunction2")
private let Java_SwiftBackedFunction2_constructor_methodID = Java_SwiftBackedFunction2_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_SwiftBackedFunction2_Swift_1release")
func SwiftBackedFunction2_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure2.self)
}
@_cdecl("Java_skip_bridge_SwiftBackedFunction2_Swift_1invoke")
func SwiftBackedFunction2_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure2 = Swift_peer.pointee()!
    let p0_swift = (value_swift.p0Type as! JConvertible.Type).fromJavaObject(p0)
    let p1_swift = (value_swift.p1Type as! JConvertible.Type).fromJavaObject(p1)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as! JConvertible).toJavaObject()
}

/// A Swift reference type that wraps a 3-parameter closure.
public final class SwiftClosure3 {
    public static func javaObject<P0: JConvertible, P1: JConvertible, P2: JConvertible, R>(for closure: ((P0, P1, P2) -> R)?) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure3(closure: closure)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction3_class.create(ctor: Java_SwiftBackedFunction3_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public static func closure<P0: JConvertible, P1: JConvertible, P2: JConvertible, R>(forJavaObject function: JavaObjectPointer?) -> ((P0, P1, P2) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.filterPeer(of: function) {
            let closure: SwiftClosure3 = ptr.pointee()!
            return { p0, p1, p2 in closure.closure(p0, p1, p2) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function)
            return { p0, p1, p2 in try! closure.invoke(p0, p1, p2) }
        }
    }

    public let closure: (JConvertible, JConvertible, JConvertible) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let p2Type: Any.Type
    public let returnType: Any.Type

    public init<P0: JConvertible, P1: JConvertible, P2: JConvertible, R>(closure: @escaping (P0, P1, P2) -> R) {
        self.closure = { p0, p1, p2 in closure(p0 as! P0, p1 as! P1, p2 as! P2) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.p2Type = P2.self
        self.returnType = R.self
    }
}
private let Java_SwiftBackedFunction3_class = try! JClass(name: "skip/bridge/SwiftBackedFunction3")
private let Java_SwiftBackedFunction3_constructor_methodID = Java_SwiftBackedFunction3_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_SwiftBackedFunction3_Swift_1release")
func SwiftBackedFunction3_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure2.self)
}
@_cdecl("Java_skip_bridge_SwiftBackedFunction3_Swift_1invoke")
func SwiftBackedFunction3_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?, _ p2: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure3 = Swift_peer.pointee()!
    let p0_swift = (value_swift.p0Type as! JConvertible.Type).fromJavaObject(p0)
    let p1_swift = (value_swift.p1Type as! JConvertible.Type).fromJavaObject(p1)
    let p2_swift = (value_swift.p2Type as! JConvertible.Type).fromJavaObject(p2)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift, p2_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as! JConvertible).toJavaObject()
}

/// A Swift reference type that wraps a 4-parameter closure.
public final class SwiftClosure4 {
    public static func javaObject<P0: JConvertible, P1: JConvertible, P2: JConvertible, P3: JConvertible, R>(for closure: ((P0, P1, P2, P3) -> R)?) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure4(closure: closure)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction4_class.create(ctor: Java_SwiftBackedFunction4_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public static func closure<P0: JConvertible, P1: JConvertible, P2: JConvertible, P3: JConvertible, R>(forJavaObject function: JavaObjectPointer?) -> ((P0, P1, P2, P3) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.filterPeer(of: function) {
            let closure: SwiftClosure4 = ptr.pointee()!
            return { p0, p1, p2, p3 in closure.closure(p0, p1, p2, p3) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function)
            return { p0, p1, p2, p3 in try! closure.invoke(p0, p1, p2, p3) }
        }
    }

    public let closure: (JConvertible, JConvertible, JConvertible, JConvertible) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let p2Type: Any.Type
    public let p3Type: Any.Type
    public let returnType: Any.Type

    public init<P0: JConvertible, P1: JConvertible, P2: JConvertible, P3: JConvertible, R>(closure: @escaping (P0, P1, P2, P3) -> R) {
        self.closure = { p0, p1, p2, p3 in closure(p0 as! P0, p1 as! P1, p2 as! P2, p3 as! P3) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.p2Type = P2.self
        self.p3Type = P3.self
        self.returnType = R.self
    }
}
private let Java_SwiftBackedFunction4_class = try! JClass(name: "skip/bridge/SwiftBackedFunction4")
private let Java_SwiftBackedFunction4_constructor_methodID = Java_SwiftBackedFunction4_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_SwiftBackedFunction4_Swift_1release")
func SwiftBackedFunction4_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure4.self)
}
@_cdecl("Java_skip_bridge_SwiftBackedFunction4_Swift_1invoke")
func SwiftBackedFunction4_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?, _ p2: JavaObjectPointer?, _ p3: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure4 = Swift_peer.pointee()!
    let p0_swift = (value_swift.p0Type as! JConvertible.Type).fromJavaObject(p0)
    let p1_swift = (value_swift.p1Type as! JConvertible.Type).fromJavaObject(p1)
    let p2_swift = (value_swift.p2Type as! JConvertible.Type).fromJavaObject(p2)
    let p3_swift = (value_swift.p3Type as! JConvertible.Type).fromJavaObject(p3)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift, p2_swift, p3_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as! JConvertible).toJavaObject()
}

/// A Swift reference type that wraps a 5-parameter closure.
public final class SwiftClosure5 {
    public static func javaObject<P0: JConvertible, P1: JConvertible, P2: JConvertible, P3: JConvertible, P4: JConvertible, R>(for closure: ((P0, P1, P2, P3, P4) -> R)?) -> JavaObjectPointer? {
        guard let closure else {
            return nil
        }
        let swiftPeer = SwiftClosure5(closure: closure)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction5_class.create(ctor: Java_SwiftBackedFunction5_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public static func closure<P0: JConvertible, P1: JConvertible, P2: JConvertible, P3: JConvertible, P4: JConvertible, R>(forJavaObject function: JavaObjectPointer?) -> ((P0, P1, P2, P3, P4) -> R)? {
        guard let function else {
            return nil
        }
        if let ptr = SwiftObjectPointer.filterPeer(of: function) {
            let closure: SwiftClosure5 = ptr.pointee()!
            return { p0, p1, p2, p3, p4 in closure.closure(p0, p1, p2, p3, p4) as! R }
        } else {
            let closure = JavaBackedClosure<R>(function)
            return { p0, p1, p2, p3, p4 in try! closure.invoke(p0, p1, p2, p3, p4) }
        }
    }

    public let closure: (JConvertible, JConvertible, JConvertible, JConvertible, JConvertible) -> Any?
    public let p0Type: Any.Type
    public let p1Type: Any.Type
    public let p2Type: Any.Type
    public let p3Type: Any.Type
    public let p4Type: Any.Type
    public let returnType: Any.Type

    public init<P0: JConvertible, P1: JConvertible, P2: JConvertible, P3: JConvertible, P4: JConvertible, R>(closure: @escaping (P0, P1, P2, P3, P4) -> R) {
        self.closure = { p0, p1, p2, p3, p4 in closure(p0 as! P0, p1 as! P1, p2 as! P2, p3 as! P3, p4 as! P4) }
        self.p0Type = P0.self
        self.p1Type = P1.self
        self.p2Type = P2.self
        self.p3Type = P3.self
        self.p4Type = P4.self
        self.returnType = R.self
    }
}
private let Java_SwiftBackedFunction5_class = try! JClass(name: "skip/bridge/SwiftBackedFunction5")
private let Java_SwiftBackedFunction5_constructor_methodID = Java_SwiftBackedFunction5_class.getMethodID(name: "<init>", sig: "(J)V")!

@_cdecl("Java_skip_bridge_SwiftBackedFunction5_Swift_1release")
func SwiftBackedFunction5_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftClosure5.self)
}
@_cdecl("Java_skip_bridge_SwiftBackedFunction5_Swift_1invoke")
func SwiftBackedFunction5_Swift_invoke(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ p0: JavaObjectPointer?, _ p1: JavaObjectPointer?, _ p2: JavaObjectPointer?, _ p3: JavaObjectPointer?, _ p4: JavaObjectPointer?) -> JavaObjectPointer? {
    let value_swift: SwiftClosure5 = Swift_peer.pointee()!
    let p0_swift = (value_swift.p0Type as! JConvertible.Type).fromJavaObject(p0)
    let p1_swift = (value_swift.p1Type as! JConvertible.Type).fromJavaObject(p1)
    let p2_swift = (value_swift.p2Type as! JConvertible.Type).fromJavaObject(p2)
    let p3_swift = (value_swift.p3Type as! JConvertible.Type).fromJavaObject(p3)
    let p4_swift = (value_swift.p4Type as! JConvertible.Type).fromJavaObject(p4)
    let c_return_swift = value_swift.closure(p0_swift, p1_swift, p2_swift, p3_swift, p4_swift)
    return value_swift.returnType == Void.self ? nil : (c_return_swift as! JConvertible).toJavaObject()
}

#else

/// A Swift-backed `kotlin.jvm.functions.Function0` implementor.
public final class SwiftBackedFunction0<R>: kotlin.jvm.functions.Function0<R>, SwiftPeerBridged {
    private var Swift_peer: SwiftObjectPointer

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func invoke() -> R {
        return Swift_invoke(Swift_peer) as! R
    }
    // SKIP EXTERN
    private func Swift_invoke(Swift_peer: SwiftObjectPointer) -> Any?

    override func Swift_bridgedPeer() -> SwiftObjectPointer {
        return Swift_peer
    }
}

/// A Swift-backed `kotlin.jvm.functions.Function1` implementor.
public final class SwiftBackedFunction1<P0, R>: kotlin.jvm.functions.Function1<P0, R>, SwiftPeerBridged {
    private var Swift_peer: SwiftObjectPointer

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func invoke(_ p0: P0) -> R {
        return Swift_invoke(Swift_peer, p0) as! R
    }
    // SKIP EXTERN
    private func Swift_invoke(Swift_peer: SwiftObjectPointer, p0: Any?) -> Any?

    override func Swift_bridgedPeer() -> SwiftObjectPointer {
        return Swift_peer
    }
}

/// A Swift-backed `kotlin.jvm.functions.Function2` implementor.
public final class SwiftBackedFunction2<P0, P1, R>: kotlin.jvm.functions.Function2<P0, P1, R>, SwiftPeerBridged {
    private var Swift_peer: SwiftObjectPointer

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func invoke(_ p0: P0, _ p1: P1) -> R {
        return Swift_invoke(Swift_peer, p0, p1) as! R
    }
    // SKIP EXTERN
    private func Swift_invoke(Swift_peer: SwiftObjectPointer, p0: Any?, p1: Any?) -> Any?

    override func Swift_bridgedPeer() -> SwiftObjectPointer {
        return Swift_peer
    }
}

/// A Swift-backed `kotlin.jvm.functions.Function3` implementor.
public final class SwiftBackedFunction3<P0, P1, P2, R>: kotlin.jvm.functions.Function3<P0, P1, P2, R>, SwiftPeerBridged {
    private var Swift_peer: SwiftObjectPointer

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func invoke(_ p0: P0, _ p1: P1, _ p2: P2) -> R {
        return Swift_invoke(Swift_peer, p0, p1, p2) as! R
    }
    // SKIP EXTERN
    private func Swift_invoke(Swift_peer: SwiftObjectPointer, p0: Any?, p1: Any?, p2: Any?) -> Any?

    override func Swift_bridgedPeer() -> SwiftObjectPointer {
        return Swift_peer
    }
}

/// A Swift-backed `kotlin.jvm.functions.Function4` implementor.
public final class SwiftBackedFunction4<P0, P1, P2, P3, R>: kotlin.jvm.functions.Function4<P0, P1, P2, P3, R>, SwiftPeerBridged {
    private var Swift_peer: SwiftObjectPointer

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func invoke(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) -> R {
        return Swift_invoke(Swift_peer, p0, p1, p2, p3) as! R
    }
    // SKIP EXTERN
    private func Swift_invoke(Swift_peer: SwiftObjectPointer, p0: Any?, p1: Any?, p2: Any?, p3: Any?) -> Any?

    override func Swift_bridgedPeer() -> SwiftObjectPointer {
        return Swift_peer
    }
}

/// A Swift-backed `kotlin.jvm.functions.Function5` implementor.
public final class SwiftBackedFunction5<P0, P1, P2, P3, P4, R>: kotlin.jvm.functions.Function5<P0, P1, P2, P3, P4, R>, SwiftPeerBridged {
    private var Swift_peer: SwiftObjectPointer

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func invoke(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) -> R {
        return Swift_invoke(Swift_peer, p0, p1, p2, p3, p4) as! R
    }
    // SKIP EXTERN
    private func Swift_invoke(Swift_peer: SwiftObjectPointer, p0: Any?, p1: Any?, p2: Any?, p3: Any?, p4: Any?) -> Any?

    override func Swift_bridgedPeer() -> SwiftObjectPointer {
        return Swift_peer
    }
}

#endif
