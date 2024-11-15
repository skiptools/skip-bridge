// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP

/// Protocol added to the generated class for a Swift class bridged to Kotlin.
public protocol SwiftPeerBridged {
    func Swift_bridgedPeer() -> SwiftObjectPointer
}

/// Return an object's peer if it is `SwiftPeerBridged`, else `SwiftObjectNil`.
public func Swift_bridgedPeer(object: Any) -> SwiftObjectPointer {
    return (object as? SwiftPeerBridged)?.Swift_bridgedPeer() ?? SwiftObjectNil
}

/// Marker type used to guarantee uniqueness of our `Swift_peer` constructor.
public final class SwiftPeerMarker {
}

/// An opaque reference to a Swift object.
public typealias SwiftObjectPointer = Int64
public let SwiftObjectNil = Int64(0)

#endif
