// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP

/// An opaque reference to a Swift object.
public typealias SwiftObjectPointer = Int64
public let SwiftObjectNil = Int64(0)

/// Return a Swift object pointer to a Kotlin instance, else `SwiftObjectNil`.
public func Swift_projection(of object: Any, options: Int, peerOnly: Bool) -> SwiftObjectPointer {
    if peerOnly {
        let peer = (object as? SwiftPeerBridged)?.Swift_peer()
        return peer ?? SwiftObjectNil
    } else {
        let projection = (object as? SwiftProjectable)?.Swift_projection(options: options)
        return projection ?? SwiftObjectNil
    }
}

/// Protocol added to a Kotlin type that can project to Swift.
public protocol SwiftProjectable {
    func Swift_projection(options: Int) -> SwiftObjectPointer
}

/// Protocol added to a Kotlin projection type backed by a Swift peer object.
public protocol SwiftPeerBridged {
    func Swift_peer() -> SwiftObjectPointer
}

extension SwiftPeerBridged: SwiftProjectable {
    public func Swift_projection(options: Int) -> SwiftObjectPointer {
        return Swift_peer()
    }
}

/// Marker type used to guarantee uniqueness of our `Swift_peer` constructor.
public final class SwiftPeerMarker {
}

#endif
