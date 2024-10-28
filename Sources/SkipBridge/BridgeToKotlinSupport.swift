//// Copyright 2024 Skip
////
//// This is free software: you can redistribute and/or modify it
//// under the terms of the GNU Lesser General Public License 3.0
//// as published by the Free Software Foundation https://fsf.org
//
//#if !SKIP
//
///// Protocol added to `@BridgeToKotlin` types.
//public protocol BridgedToKotlin: JObjectProtocol, JConvertible {
//}
//
//#else
//
///// Protocol added to the generated class for a Swift class bridged to Kotlin.
//public protocol SwiftPeerBridged {
//    func Swift_bridgedPeer() -> SwiftObjectPointer
//}
//
///// Return an object's peer if it is `SwiftPeerBridged`, else `SwiftObjectNil`.
//public func Swift_bridgedPeer(object: Any) -> SwiftObjectPointer {
//    return (object as? SwiftPeerBridged)?.Swift_bridgedPeer() ?? SwiftObjectNil
//}
//
///// Marker type used to guarantee uniqueness of our `Swift_peer` constructor.
//public final class SwiftPeerMarker {
//}
//
//#endif
//
///// An opaque reference to a Swift object.
//public typealias SwiftObjectPointer = Int64
//public let SwiftObjectNil = Int64(0)
//
//#if !SKIP
//
//extension SwiftObjectPointer {
//    /// Get a pointer to the given object.
//    public static func pointer<T: AnyObject>(to object: T?, retain: Bool) -> SwiftObjectPointer {
//        guard let object else {
//            return SwiftObjectNil
//        }
//        let unmanaged = retain ? Unmanaged.passRetained(object) : Unmanaged.passUnretained(object)
//        let rawPtr = unmanaged.toOpaque()
//        return SwiftObjectPointer(Int(bitPattern: rawPtr))
//    }
//
//    /// Return the object for this pointer.
//    public func pointee<T: AnyObject>() -> T? {
//        guard self != SwiftObjectNil else {
//            return nil
//        }
//        let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self))!
//        return Unmanaged<T>.fromOpaque(rawPtr).takeUnretainedValue()
//    }
//
//    /// Increment the reference count for a Swift object held by Java.
//    public func retained<T: AnyObject>(as type: T.Type) -> SwiftObjectPointer {
//        guard self != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self)) else {
//            return self
//        }
//        let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
//        let refUnmanaged = unmanaged.retain()
//        return SwiftObjectPointer(Int(bitPattern: refUnmanaged.toOpaque()))
//    }
//
//    /// Decrement the reference count for a Swift object held by Java.
//    public func release<T: AnyObject>(as type: T.Type) {
//        guard self != SwiftObjectNil, let rawPtr = UnsafeMutableRawPointer(bitPattern: Int(self)) else {
//            return
//        }
//        let unmanaged = Unmanaged<T>.fromOpaque(rawPtr)
//        unmanaged.release()
//    }
//}
//
//extension SwiftObjectPointer {
//    /// Return the `Swift_peer` of the given `SwiftPeerBridged` object.
//    public static func peer(of bridged: JavaObjectPointer) -> SwiftObjectPointer {
//        return try! SwiftObjectPointer.call(Java_SwiftPeerBridged_peer_methodID, on: bridged, args: [])
//    }
//
//    /// Check whether the given object is `SwiftPeerBridged` and if so, return its `Swift_peer`.
//    public static func filterPeer(of bridged: JavaObjectPointer) -> SwiftObjectPointer? {
//        let ptr: SwiftObjectPointer = try! Java_fileClass.callStatic(method: Java_peer_methodID, args: [bridged.toJavaParameter()])
//        return ptr == SwiftObjectNil ? nil : ptr
//    }
//}
//private let Java_fileClass = try! JClass(name: "skip/bridge/BridgeToKotlinSupportKt")
//private let Java_peer_methodID = Java_fileClass.getStaticMethodID(name: "Swift_bridgedPeer", sig: "(Ljava/lang/Object;)J")!
//private let Java_SwiftPeerBridged_class = try! JClass(name: "skip/bridge/SwiftPeerBridged")
//private let Java_SwiftPeerBridged_peer_methodID = Java_SwiftPeerBridged_class.getMethodID(name: "Swift_bridgedPeer", sig: "()J")!
//
//#endif
