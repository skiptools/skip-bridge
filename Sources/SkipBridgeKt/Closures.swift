// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP

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

    override func Swift_peer() -> SwiftObjectPointer {
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

    override func Swift_peer() -> SwiftObjectPointer {
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

    override func Swift_peer() -> SwiftObjectPointer {
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

    override func Swift_peer() -> SwiftObjectPointer {
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

    override func Swift_peer() -> SwiftObjectPointer {
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

    override func Swift_peer() -> SwiftObjectPointer {
        return Swift_peer
    }
}

#endif
