
#if SKIP

// SKIP @bridge
public func transpiledGlobalFuction(n1: Float, n2: Int8) -> Double {
    return Double(n1) + Double(n2)
}

// SKIP @bridge
public var transpiledVar = 99

// SKIP @bridge
public var transpiledComputedVar: Int {
    return 100
}

// SKIP @bridge
public class TranspiledClass {
    public var publicVar: String = "publicVar"
    public var helper = TranspiledHelper(i: 99)

    public init() {
    }

    public func transpiledFromCompiled() -> Int64 {
        return 123
    }
}

// SKIP @bridge
public class TranspiledHelper {
    public var i: Int

    public init(i: Int) {
        self.i = i
    }
}

#endif
