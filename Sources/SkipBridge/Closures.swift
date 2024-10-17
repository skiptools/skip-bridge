// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A Swift object that is backed by a Java closure in the form of a `kotlin.jvm.functions.FunctionN` object.
public final class JavaBackedClosure<R>: JObject {
    public func invoke() throws -> R {
        let object: JavaObjectPointer? = try call(method: Java_Function0_invoke_methodID, args: [])
        return returnValue(for: object)
    }

    public func invoke(_ p0: JConvertible?) throws -> R {
        let p0_java = (p0?.toJavaObject()).toJavaParameter()
        let object: JavaObjectPointer? = try call(method: Java_Function1_invoke_methodID, args: [p0_java])
        return returnValue(for: object)
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

/// A Swift reference type that wraps a 0-parameters closure.
public final class SwiftClosure0 {
    public static func javaObject<R>(for closure: @escaping () -> R) -> JavaObjectPointer {
        let swiftPeer = SwiftClosure0(closure: closure)
        let swiftPeerPtr = SwiftObjectPointer.pointer(to: swiftPeer, retain: true)
        return try! Java_SwiftBackedFunction0_class.create(ctor: Java_SwiftBackedFunction0_constructor_methodID, args: [swiftPeerPtr.toJavaParameter()])
    }

    public static func closure<R>(forJavaObject function: JavaObjectPointer) -> () -> R {
        if let ptr = SwiftObjectPointer.filterPeer(of: function) {
            let closure: SwiftClosure0 = ptr.pointee()!
            return closure.closure as! () -> R
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

#endif
