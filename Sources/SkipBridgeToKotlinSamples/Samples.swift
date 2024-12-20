// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridgeToKotlinSamplesHelpers

// MARK: Global constants

public let swiftBoolConstant = true
// TODO: Char
public let swiftDoubleConstant = 1.0
public let swiftFloatConstant: Float = 2.0
public let swiftInt8Constant: Int8 = 3
public let swiftInt16Constant: Int16 = 4
public let swiftInt32Constant: Int32 = 5
public let swiftInt64Constant: Int64 = 6
public let swiftIntConstant = 7
// TODO: Unsigned values
public let swiftStringConstant = "s"
public let swiftClassConstant = SwiftHelperClass()
public let swiftKotlinClassConstant = KotlinHelperClass()

// MARK: Global optional constants

public let swiftOptionalBoolConstant: Bool? = true
// TODO: Optional char
public let swiftOptionalDoubleConstant: Double? = 1.0
public let swiftOptionalFloatConstant: Float? = 2.0
public let swiftOptionalInt8Constant: Int8? = nil
public let swiftOptionalInt16Constant: Int16? = 3
public let swiftOptionalInt32Constant: Int32? = 4
public let swiftOptionalInt64Constant: Int64? = 5
public let swiftOptionalIntConstant: Int? = 6
// TODO: Unsigned values
public let swiftOptionalStringConstant: String? = "s"
public let swiftOptionalClassConstant: SwiftHelperClass? = SwiftHelperClass()
public let swiftOptionalKotlinClassConstant: KotlinHelperClass? = KotlinHelperClass()

// MARK: Global vars

public var swiftBoolVar = true
// TODO: Char
public var swiftDoubleVar = 1.0
public var swiftFloatVar: Float = 2.0
public var swiftInt8Var: Int8 = 3
public var swiftInt16Var: Int16 = 4
public var swiftInt32Var: Int32 = 5
public var swiftInt64Var: Int64 = 6
public var swiftIntVar = 7
// TODO: Unsigned values
public var swiftStringVar = "s"
public var swiftClassVar = SwiftHelperClass()
public var swiftBaseClassVar = SwiftClass()
public var swiftInnerClassVar = SwiftHelperClass.Inner()
public var swiftKotlinClassVar = KotlinHelperClass()
public var swiftAnyVar: Any = "a"
public var swiftAnyHashableVar: AnyHashable = 1

// MARK: Global optional vars

public var swiftOptionalBoolVar: Bool? = true
// TODO: Optional char
public var swiftOptionalDoubleVar: Double? = 1.0
public var swiftOptionalFloatVar: Float? = 2.0
public var swiftOptionalInt8Var: Int8? = nil
public var swiftOptionalInt16Var: Int16? = 3
public var swiftOptionalInt32Var: Int32? = 4
public var swiftOptionalInt64Var: Int64? = 5
public var swiftOptionalIntVar: Int? = 6
// TODO: Unsigned values
public var swiftOptionalStringVar: String? = "s"
public var swiftOptionalClassVar: SwiftHelperClass? = SwiftHelperClass()
public var swiftOptionalKotlinClassVar: KotlinHelperClass? = KotlinHelperClass()

// MARK: Global computed vars

public var swiftIntComputedVar: Int {
    get {
        return swiftIntVar
    }
    set {
        swiftIntVar = newValue
    }
}

public var swiftClassComputedVar: SwiftHelperClass {
    get {
        return swiftClassVar
    }
    set {
        swiftClassVar = newValue
    }
}

public var swiftKotlinClassComputedVar: KotlinHelperClass {
    get {
        return swiftKotlinClassVar
    }
    set {
        swiftKotlinClassVar = newValue
    }
}

// MARK: Classes

public class SwiftClass {
    public static let staticIntConstant = 1
    public static var staticIntVar = 1
    public static func staticFunc(string: String) -> String {
        return "swift" + string
    }

    public let intConstant = 1
    public let swiftClassConstant = SwiftHelperClass()

    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public var swiftClassVar = SwiftHelperClass()
    public var optionalKotlinClassVar: KotlinHelperClass?

    public var optionalSwiftProtocolVar: (any SwiftProtocol)?
    public var optionalKotlinProtocolVar: (any KotlinProtocol)?

    public var swiftStructVar = SwiftStruct(string: "1")
    public var kotlinStructVar = KotlinStruct(string: "2")

    public init() {
    }
}

public final class SwiftSubclass: SwiftClass {
    public var stringVar: String

    public init(string: String) {
        self.stringVar = string
        super.init()
    }
}

public final class SwiftHelperClass: SwiftProtocol, Comparable, Identifiable {
    public var id: String {
        return stringVar
    }
    public var stringVar = "s"

    public init() {
    }

    public init(string: String?) throws {
        self.stringVar = string!
    }

    public func stringValue() -> String {
        return stringVar
    }

    public static func ==(lhs: SwiftHelperClass, rhs: SwiftHelperClass) -> Bool {
        return lhs.stringVar == rhs.stringVar
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringVar)
    }

    public static func <(lhs: SwiftHelperClass, rhs: SwiftHelperClass) -> Bool {
        return lhs.stringVar < rhs.stringVar
    }

    public class Inner {
        public var intVar = 0

        public init() {
        }
    }
}

public protocol SwiftProtocol: Hashable {
    func stringValue() -> String
}

public struct SwiftStruct {
    public var intVar = 1

    public init(string: String) {
        self.intVar = Int(string) ?? 0
    }

    public func intFunc() -> Int {
        return intVar
    }

    public mutating func setIntFunc(_ i: Int) {
        self.intVar = i
    }
}

public enum SwiftEnum: String, CaseIterable {
    case name
    case age = "years"

    public func isName() -> Bool {
        return self == .name
    }

    public var intValue: Int {
        switch self {
        case .name: return 0
        case .age: return 1
        }
    }

    public init(intValue: Int) {
        switch intValue {
        case 0: self = .name
        default: self = .age
        }
    }
}

// MARK: Closures

public var swiftClosure0Var: () -> Void = { print("original") }
public var swiftClosure1Var: (Int) -> String = { i in "value = \(i)" }
public var swiftClosure1PrimitivesVar: (Int64) -> Int = { l in Int(l / 1000) }
public var swiftClosure1OptionalsVar: (String?) -> Int? = { s in s?.count }

// MARK: Containers

public var swiftIntArrayVar = [1, 2, 3]
public var swiftStringSetVar: Set<String> = ["a", "b", "c"]
public var swiftIntStringDictionaryVar = [1: "a", 2: "b", 3: "c"]
public var swiftIntStringTuple = (1, "s")

// MARK: Functions

public func swiftThrowingFunction(shouldThrow: Bool) throws -> Int {
    if shouldThrow {
        throw SwiftSampleError()
    } else {
        return 1
    }
}

public func swiftThrowingVoidFunction(shouldThrow: Bool) throws {
    if shouldThrow {
        throw SwiftSampleError()
    }
}

// MARK: Async

public func swiftAsync0Function() async {
    try? await Task.sleep(nanoseconds: 10_000_000)
}

public func swiftAsync1Function(i: Int) async -> Int {
    try? await Task.sleep(nanoseconds: 10_000_000)
    return i + 1
}

public func swiftAsyncThrowingFunction(shouldThrow: Bool) async throws -> Int {
    if shouldThrow {
        throw SwiftSampleError()
    } else {
        return 1
    }
}

public func swiftAsyncThrowingVoidFunction(shouldThrow: Bool) async throws {
    if shouldThrow {
        throw SwiftSampleError()
    }
}

// MARK: Unicode

public let swiftUTF8StringVar1 = "😀" + ""
public let swiftUTF8StringVar2 = "🚀" + "123" + "456"
public let swiftUTF8StringVar3 = "😀" + "🚀"

// MARK: Observation

#if compiler(>=6.0)
public func swiftExerciseObservable() {
    if #available(macOS 14, iOS 17, *) {
        let obj = ObservedClass()
        obj.i += 1
    }
}
#endif

// MARK: Bridged Types

public func swiftMakeURL(matching url: URL) -> URL? {
    return URL(string: url.absoluteString)
}

public func swiftMakeUUID(matching uuid: UUID) -> UUID? {
    return UUID(uuidString: uuid.uuidString)
}

public func swiftMakeData(matching data: Data) -> Data {
    var copy = Data()
    copy.append(data)
    return copy
}

public func swiftMakeDate(matching date: Date) -> Date {
    return Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
}

struct SwiftSampleError: Error {
}

// MARK: Sanity check
// This code is not supported by our transpiler and ensures that we're compiling to native Swift

public func multiplyInt32s(i1: Int32, i2: Int32) -> Int32 {
    i1.multiplex(with: i2)
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
