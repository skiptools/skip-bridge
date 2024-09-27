
// SKIP @bridge
public let globalBridgeInt64Field: Int64 = Int64(123).multiplex(with: Int64(456))

// SKIP @bridge
public let globalBridgeDoubleField: Double = Double(123).multiplex(with: Double(456))

// SKIP @bridge
public let globalBridgeInt8Field: Int8 = Int8(16).multiplex(with: Int8(7))

// SKIP @bridge
public let globalBridgeUInt8Field: UInt8 = UInt8(16).multiplex(with: UInt8(15))

// SKIP @bridge
public let globalBridgeStringField = "abc" + "123"

// SKIP @bridge
public let globalBridgeUTF8String1Field = "😀" + ""

// SKIP @bridge
public let globalBridgeUTF8String2Field = "🚀" + "123"

// SKIP @bridge
public let globalBridgeUTF8String3Field = "😀" + "🚀"

// SKIP @bridge
public let globalJavaGetFileSeparator: String = try! getJavaProperty("file.separator")

// SKIP @bridge
public let globalCompiledtoTranspiledCall = transpiledGlobalFuction(n1: 1.1, n2: 2)

// SKIP @bridge
public class CompiledClass {
    public var publicVar: String = "publicVar"

    public init() {
    }
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
    let systemClass = try JClass(name: "java.lang.System")
    let getProperty = systemClass.getStaticMethodID(name: "getProperty", sig: "(Ljava/lang/String;)Ljava/lang/String;")!
    return try systemClass.callStatic(method: getProperty, [propertyName.toJavaParameter()])
}
#endif

