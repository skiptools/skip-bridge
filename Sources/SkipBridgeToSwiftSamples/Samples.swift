// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

import Foundation
import SkipBridgeToSwiftSamplesHelpers

// MARK: Global constants

public let kotlinBoolConstant = true
// TODO: Char
public let kotlinDoubleConstant = 1.0
public let kotlinFloatConstant = Float(2.0)
public let kotlinInt8Constant = Int8(3)
public let kotlinInt16Constant = Int16(4)
public let kotlinInt32Constant = Int32(5)
public let kotlinInt64Constant = Int64(6)
public let kotlinIntConstant = 7
// TODO: Unsigned values
public let kotlinStringConstant = "s"
public var kotlinClassConstant = KotlinHelperClass()
public var kotlinSwiftClassConstant = SwiftHelperClass()

// MARK: Global optional constants

public let kotlinOptionalBoolConstant: Bool? = true
//- TODO: Optional char
public let kotlinOptionalDoubleConstant: Double? = 1.0
public let kotlinOptionalFloatConstant: Float? = Float(2.0)
public let kotlinOptionalInt8Constant: Int8? = nil
public let kotlinOptionalInt16Constant: Int16? = Int16(3)
public let kotlinOptionalInt32Constant: Int32? = Int32(4)
public let kotlinOptionalInt64Constant: Int64? = Int64(5)
public let kotlinOptionalIntConstant: Int? = 6
// TODO: Unsigned values
public let kotlinOptionalStringConstant: String? = "s"
public let kotlinOptionalClassConstant: KotlinHelperClass? = KotlinHelperClass()
public let kotlinOptionalSwiftClassConstant: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global vars

public var kotlinBoolVar = true
// TODO: Char
public var kotlinDoubleVar = 1.0
public var kotlinFloatVar = Float(2.0)
public var kotlinInt8Var = Int8(3)
public var kotlinInt16Var = Int16(4)
public var kotlinInt32Var = Int32(5)
public var kotlinInt64Var = Int64(6)
public var kotlinIntVar = 7
// TODO: Unsigned values
public var kotlinStringVar = "s"
public var kotlinClassVar = KotlinHelperClass()
public var kotlinSwiftClassVar = SwiftHelperClass()

// MARK: Global optional vars

public var kotlinOptionalBoolVar: Bool? = true
// TODO: Optional char
public var kotlinOptionalDoubleVar: Double? = 1.0
public var kotlinOptionalFloatVar: Float? = Float(2.0)
public var kotlinOptionalInt8Var: Int8? = nil
public var kotlinOptionalInt16Var: Int16? = Int16(3)
public var kotlinOptionalInt32Var: Int32? = Int32(4)
public var kotlinOptionalInt64Var: Int64? = Int64(5)
public var kotlinOptionalIntVar: Int? = 6
// TODO: Unsigned values
public var kotlinOptionalStringVar: String? = "s"
public var kotlinOptionalClassVar: KotlinHelperClass? = KotlinHelperClass()
public var kotlinOptionalSwiftClassVar: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global computed vars

public var kotlinIntComputedVar: Int {
    get {
        return kotlinIntVar
    }
    set {
        kotlinIntVar = newValue
    }
}

public var kotlinClassComputedVar: KotlinHelperClass {
    get {
        return kotlinClassVar
    }
    set {
        kotlinClassVar = newValue
    }
}

public var kotlinSwiftClassComputedVar: SwiftHelperClass {
    get {
        return kotlinSwiftClassVar
    }
    set {
        kotlinSwiftClassVar = newValue
    }
}

// MARK: Classes

public class KotlinClass {
    public static let staticIntConstant = 1
    public static var staticIntVar = 1
    public static func staticFunc(string: String) -> String {
        return "kotlin" + string
    }

    public let intConstant = 1
    public let kotlinClassConstant = KotlinHelperClass()

    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public var kotlinClassVar = KotlinHelperClass()
    public var optionalSwiftClassVar: SwiftHelperClass?

    public var optionalKotlinProtocolVar: (any KotlinProtocol)?
    public var optionalSwiftProtocolVar: (any SwiftProtocol)?

    public var kotlinStructVar = KotlinStruct(string: "1")
    public var swiftStructVar = SwiftStruct(string: "2")

    public init() {
    }
}

public class KotlinHelperClass: KotlinProtocol, Comparable, Identifiable {
    public var id: String {
        return stringVar
    }
    public var stringVar = "s"

    public init() {
    }

    public func stringValue() -> String {
        return stringVar
    }

    public static func ==(lhs: KotlinHelperClass, rhs: KotlinHelperClass) -> Bool {
        return lhs.stringVar == rhs.stringVar
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringVar)
    }

    public static func <(lhs: KotlinHelperClass, rhs: KotlinHelperClass) -> Bool {
        return lhs.stringVar < rhs.stringVar
    }
}

public protocol KotlinProtocol: Hashable {
    func stringValue() -> String
}

public struct KotlinStruct {
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

public enum KotlinEnum: String, CaseIterable {
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

public var kotlinClosure0Var: () -> Void = { print("original") }
public var kotlinClosure1Var: (Int) -> String = { i in "value = \(i)" }
public var kotlinClosure1PrimitivesVar: (Int64) -> Int = { l in Int(l / 1000) }
public var kotlinClosure1OptionalsVar: (String?) -> Int? = { s in s?.count }

// MARK: Containers

public var kotlinIntArrayVar = [1, 2, 3]
public var kotlinIntStringDictionaryVar = [1: "a", 2: "b", 3: "c"]

// MARK: Functions

public func kotlinThrowingFunction(shouldThrow: Bool) throws -> Int {
    if shouldThrow {
        throw KotlinSampleError()
    } else {
        return 1
    }
}

public func kotlinThrowingVoidFunction(shouldThrow: Bool) throws {
    if shouldThrow {
        throw KotlinSampleError()
    }
}

// MARK: Async

public func kotlinAsync0Function() async {
    try? await Task.sleep(nanoseconds: 10_000_000)
}

public func kotlinAsync1Function(i: Int) async -> Int {
    try? await Task.sleep(nanoseconds: 10_000_000)
    return i + 1
}

public func kotlinAsyncThrowingFunction(shouldThrow: Bool) async throws -> Int {
    if shouldThrow {
        throw KotlinSampleError()
    } else {
        return 1
    }
}

public func kotlinAsyncThrowingVoidFunction(shouldThrow: Bool) async throws {
    if shouldThrow {
        throw KotlinSampleError()
    }
}

// MARK: Bridged Types

public func kotlinMakeURL(matching url: URL) -> URL? {
    return URL(string: url.absoluteString)
}

public func kotlinMakeUUID(matching uuid: UUID) -> UUID? {
    return UUID(uuidString: uuid.uuidString)
}

public func kotlinMakeData(matching data: Data) -> Data {
    var copy = Data()
    copy.append(data)
    return copy
}

public func kotlinMakeDate(matching date: Date) -> Date {
    return Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
}

struct KotlinSampleError: Error {
}

#endif
