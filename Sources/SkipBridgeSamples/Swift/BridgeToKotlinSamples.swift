
// SKIP @bridgeToKotlin
public let globalBridgeInt64Field: Int64 = Int64(123).multiplex(with: Int64(456))

// SKIP @bridgeToKotlin
public let globalBridgeDoubleField: Double = Double(123).multiplex(with: Double(456))

// SKIP @bridgeToKotlin
public let globalBridgeInt8Field: Int8 = Int8(16).multiplex(with: Int8(7))

// SKIP @bridgeToKotlin
public let globalBridgeUInt8Field: UInt8 = UInt8(16).multiplex(with: UInt8(15))

// SKIP @bridgeToKotlin
public let globalBridgeStringField = "abc" + "123"

// SKIP @bridgeToKotlin
public let globalBridgeUTF8String1Field = "😀" + ""

// SKIP @bridgeToKotlin
public let globalBridgeUTF8String2Field = "🚀" + "123"

// SKIP @bridgeToKotlin
public let globalBridgeUTF8String3Field = "😀" + "🚀"

// SKIP @bridgeToKotlin
public let globalJavaGetFileSeparator: String = try! getJavaProperty("file.separator")

// SKIP @bridgeToKotlin
public let globalCompiledtoTranspiledCall = transpiledGlobalFuction(n1: 1.1, n2: 2)

// SKIP @bridgeToKotlin
public var globalBridgeOptionalIntField: Int? = 1

// SKIP @bridgeToKotlin
public class CompiledClass {
    public var publicVar: String = "publicVar"
    public var helper = CompiledHelper(i: 99)

    public init() {
    }
}

// SKIP @bridgeToKotlin
public class CompiledHelper {
    public var i: Int

    public init(i: Int) {
        self.i = i
    }
}

// Testing helpers: we can only access test transpiled-to-compiled bridging by going
// through a compiled function
// SKIP @bridgeToKotlin
public func compiledFuncToTranspiledClassPublicVar(value: String) -> String {
    let c = TranspiledClass()
    c.publicVar = value
    return c.publicVar
}
// SKIP @bridgeToKotlin
public func compiledFuncToTranspiledVar(value: Int) -> Int {
    transpiledVar = value
    return transpiledVar
}
// SKIP @bridgeToKotlin
public func compiledFuncToTranspiledOptionalVar(value: Int?) -> Int? {
    transpiledOptionalVar = value
    return transpiledOptionalVar
}
// SKIP @bridgeToKotlin
public func compiledFuncToTranspiledComputedVar() -> Int {
    return transpiledComputedVar
}
// SKIP @bridgeToKotlin
public func compiledFuncToTranspiledCompiledVar() -> String {
    return transpiledCompiledVar.publicVar
}
// SKIP @bridgeToKotlin
public var compiledVarOfTranspiledType = TranspiledClass()
// SKIP @bridgeToKotlin
public var compiledComputedVarOfTranspiledType: TranspiledClass {
    // Test case where the native wrapper will be dealloc'd immediately
    return TranspiledClass()
}
// SKIP @bridgeToKotlin
public func compiledFuncToTranspiledVarOfTranspiledType(value: Int) -> Int {
    let c = compiledVarOfTranspiledType
    c.helper.i = value
    return c.helper.i
}
// SKIP @bridgeToKotlin
public func compiledFuncToTranspiledVarOfCompiledType(value: String) -> String {
    let c = compiledVarOfTranspiledType
    c.compiled = CompiledClass()
    c.compiled.publicVar = value
    return c.compiled.publicVar
}

protocol Multiplex {
    func multiplex(with: Self) -> Self
}

extension Multiplex where Self : Numeric {
    func multiplex(with: Self) -> Self {
        self * with
    }
}

extension Int8 : Multiplex { }
extension Int16 : Multiplex { }
extension Int32 : Multiplex { }
extension Int64 : Multiplex { }
extension UInt8 : Multiplex { }
extension UInt16 : Multiplex { }
extension UInt32 : Multiplex { }
extension UInt64 : Multiplex { }
extension Float : Multiplex { }
extension Double : Multiplex { }

#if canImport(SkipBridge)
import SkipBridge

private func getJavaProperty(_ propertyName: String) throws -> String {
    let systemClass = try JClass(name: "java/lang/System")
    let getProperty = systemClass.getStaticMethodID(name: "getProperty", sig: "(Ljava/lang/String;)Ljava/lang/String;")!
    return try systemClass.callStatic(method: getProperty, args: [propertyName.toJavaParameter()])
}
#endif

