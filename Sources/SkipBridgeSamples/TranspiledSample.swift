
#if SKIP

// SKIP @bridge
public func transpiledGlobalFuction(n1: Float, n2: Int8) -> Double {
    return Double(n1) + Double(n2)
}

// SKIP @bridge
public class TranspiledClass {
    public var publicVar: String = "publicVar"

    public init() {
    }
}

#endif
