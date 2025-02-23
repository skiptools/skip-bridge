// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// Utility type used to provide an `AnyHashable` equivalent to Kotlin, where the underlying type
/// is not necessarily bridged.
public final class SwiftHashable: Hashable {
    private let comparator: (Any) -> Bool
    private let hasher: (inout Hasher) -> Void

    public init<T>(_ value: T) where T : Hashable {
        self.value = value
        self.hasher = { $0.combine(value) }
        self.comparator = { value == $0 as! T }
    }

    public let value: Any

    public func hash(into hasher: inout Hasher) {
        self.hasher(&hasher)
    }

    public static func ==(lhs: SwiftHashable, rhs: SwiftHashable) -> Bool {
        return lhs.comparator(rhs.value)
    }
}

extension SwiftHashable: BridgedToKotlin, BridgedFinalClass {
    private static let Java_class = try! JClass(name: "skip.bridge.SwiftHashable")

    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Self {
        let ptr = SwiftObjectPointer.peer(of: obj!, options: options)
        return ptr.pointee()!
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let Swift_peer = SwiftObjectPointer.pointer(to: self, retain: true)
        return try! Self.Java_class.create(ctor: Self.Java_constructor_methodID, options: options, args: [Swift_peer.toJavaParameter(options: options)])
    }

    private static let Java_constructor_methodID = Java_class.getMethodID(name: "<init>", sig: "(J)V")!
}

@_cdecl("Java_skip_bridge_SwiftHashable_Swift_1release")
public func SwiftHashable_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftHashable.self)
}

@_cdecl("Java_skip_bridge_SwiftHashable_Swift_1hashCode")
public func SwiftHashable_Swift_hashCode(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) -> Int64 {
    let hashable: SwiftHashable = Swift_peer.pointee()!
    return Int64(hashable.hashValue)
}

@_cdecl("Java_skip_bridge_SwiftHashable_Swift_1equals")
public func SwiftHashable_Swift_equals(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ other: SwiftObjectPointer) -> Bool {
    let hashable: SwiftHashable = Swift_peer.pointee()!
    let other: SwiftHashable? = other.pointee()
    return hashable == other
}

@_cdecl("Java_skip_bridge_SwiftHashable_Swift_1projectionImpl")
public func SwiftHashable_Swift_projectionImpl(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ options: Int32) -> JavaObjectPointer {
    let projection = SwiftHashable.fromJavaObject(Java_target, options: JConvertibleOptions(rawValue: Int(options)))
    let factory: () -> Any = { projection }
    return SwiftClosure0.javaObject(for: factory, options: [])!
}

#if SKIP

// SKIP @nobridge
public final class SwiftHashable: SwiftPeerBridged, skip.lib.SwiftProjecting {
    var Swift_peer: SwiftObjectPointer = SwiftObjectNil

    public init(Swift_peer: SwiftObjectPointer) {
        self.Swift_peer = Swift_peer
    }

    deinit {
        Swift_release(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    // SKIP EXTERN
    private func Swift_release(Swift_peer: SwiftObjectPointer)

    public override func Swift_peer() -> SwiftObjectPointer {
        return Swift_peer
    }

    public override func equals(other: Any?) -> Bool {
        if !(other is SwiftPeerBridged) {
            return false
        }
        return Swift_equals(Swift_peer, other.Swift_peer())
    }
    // SKIP EXTERN
    private func Swift_equals(Swift_peer: SwiftObjectPointer, other: SwiftObjectPointer) -> Bool

    public override func hashCode() -> Int {
        return Swift_hashCode(Swift_peer).toInt()
    }
    // SKIP EXTERN
    private func Swift_hashCode(Swift_peer: SwiftObjectPointer) -> Int64

    public override func Swift_projection(options: Int) -> () -> Any {
        return Swift_projectionImpl(options)
    }
    // SKIP EXTERN
    private func Swift_projectionImpl(options: Int) -> () -> Any
}

#endif
