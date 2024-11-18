// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// Protocol added to `@BridgeToKotlin` types.
public protocol BridgedToKotlin: JObjectProtocol, JConvertible {
}

/// An opaque reference to a Swift object.
public typealias SwiftObjectPointer = Int64
public let SwiftObjectNil = Int64(0)

extension SwiftObjectPointer {
    /// Get a pointer to the given object.
    public static func pointer<T: AnyObject>(to object: T?, retain: Bool) -> SwiftObjectPointer {
        guard let object else {
            return SwiftObjectNil
        }
        let unmanaged = retain ? Unmanaged.passRetained(object) : Unmanaged.passUnretained(object)
        let rawPtr = unmanaged.toOpaque()
        return SwiftObjectPointer(Int(bitPattern: rawPtr))
    }

    /// Return the object for this pointer.
    public func pointee<T: AnyObject>() -> T? {
        guard self != SwiftObjectNil else {
            return nil
        }
        let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self))!
        return Unmanaged<T>.fromOpaque(rawPtr).takeUnretainedValue()
    }

    /// Increment the reference count for a Swift object held by Java.
    public func retained<T: AnyObject>(as type: T.Type) -> SwiftObjectPointer {
        guard self != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self)) else {
            return self
        }
        let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
        let refUnmanaged = unmanaged.retain()
        return SwiftObjectPointer(Int(bitPattern: refUnmanaged.toOpaque()))
    }

    /// Decrement the reference count for a Swift object held by Java.
    public func release<T: AnyObject>(as type: T.Type) {
        guard self != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self)) else {
            return
        }
        let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
        unmanaged.release()
    }
}

extension SwiftObjectPointer {
    /// Return the `Swift_peer` of the given `SwiftPeerBridged` object.
    public static func peer(of bridged: JavaObjectPointer, options: JConvertibleOptions) -> SwiftObjectPointer {
        return try! SwiftObjectPointer.call(Java_SwiftPeerBridged_peer_methodID, on: bridged, options: options, args: [])
    }

    /// Check whether the given object is `SwiftPeerBridged` and if so, return its `Swift_peer`.
    public static func filterPeer(of bridged: JavaObjectPointer, options: JConvertibleOptions) -> SwiftObjectPointer? {
        let ptr: SwiftObjectPointer = try! Java_fileClass.callStatic(method: Java_peer_methodID, options: options, args: [bridged.toJavaParameter(options: options)])
        return ptr == SwiftObjectNil ? nil : ptr
    }
}
private let Java_fileClass = try! JClass(name: "skip/bridge/kt/BridgeToKotlinSupportKt")
private let Java_peer_methodID = Java_fileClass.getStaticMethodID(name: "Swift_bridgedPeer", sig: "(Ljava/lang/Object;)J")!
private let Java_SwiftPeerBridged_class = try! JClass(name: "skip/bridge/kt/SwiftPeerBridged")
private let Java_SwiftPeerBridged_peer_methodID = Java_SwiftPeerBridged_class.getMethodID(name: "Swift_bridgedPeer", sig: "()J")!

/// Reference type to hold a value type.
public final class SwiftValueTypeBox<T> {
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
}
