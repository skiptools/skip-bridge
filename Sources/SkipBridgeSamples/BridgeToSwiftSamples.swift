
#if SKIP

// SKIP @bridgeToSwift
public func transpiledGlobalFuction(n1: Float, n2: Int8) -> Double {
    return Double(n1) + Double(n2)
}

// SKIP @bridgeToSwift
public var transpiledVar = 99

// SKIP @bridgeToSwift
public var transpiledOptionalVar: Int? = 1

// SKIP @bridgeToSwift
public var transpiledComputedVar: Int {
    return 100
}

// SKIP @bridgeToSwift
public var transpiledCompiledVar = CompiledClass()

// SKIP @bridgeToSwift
public class TranspiledClass {
    public var publicVar: String = "publicVar"
    public var helper = TranspiledHelper(i: 99)
    public var compiled = CompiledClass()

    public init() {
    }

    public func transpiledFromCompiled() -> Int64 {
        return 123
    }
}

// SKIP @bridgeToSwift
public class TranspiledHelper {
    public var i: Int

    public init(i: Int) {
        self.i = i
    }
}

#endif
