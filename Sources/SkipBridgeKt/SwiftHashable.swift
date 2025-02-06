// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP

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
