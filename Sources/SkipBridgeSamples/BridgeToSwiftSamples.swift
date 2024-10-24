// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridge

// MARK: Global constants

// SKIP @BridgeToSwift
public let kotlinBoolConstant = true
// TODO: Char
// SKIP @BridgeToSwift
public let kotlinDoubleConstant = 1.0
// SKIP @BridgeToSwift
public let kotlinFloatConstant = Float(2.0)
// SKIP @BridgeToSwift
public let kotlinInt8Constant = Int8(3)
// SKIP @BridgeToSwift
public let kotlinInt16Constant = Int16(4)
// SKIP @BridgeToSwift
public let kotlinInt32Constant = Int32(5)
// SKIP @BridgeToSwift
public let kotlinInt64Constant = Int64(6)
// SKIP @BridgeToSwift
public let kotlinIntConstant = 7
// TODO: Unsigned values
// SKIP @BridgeToSwift
public let kotlinStringConstant = "s"
// SKIP @BridgeToSwift
public var kotlinClassConstant = KotlinHelperClass()
// SKIP @BridgeToSwift
public var kotlinSwiftClassConstant = SwiftHelperClass()

// MARK: Global optional constants

// SKIP @BridgeToSwift
public let kotlinOptionalBoolConstant: Bool? = true
//- TODO: Optional char
// SKIP @BridgeToSwift
public let kotlinOptionalDoubleConstant: Double? = 1.0
// SKIP @BridgeToSwift
public let kotlinOptionalFloatConstant: Float? = Float(2.0)
// SKIP @BridgeToSwift
public let kotlinOptionalInt8Constant: Int8? = nil
// SKIP @BridgeToSwift
public let kotlinOptionalInt16Constant: Int16? = Int16(3)
// SKIP @BridgeToSwift
public let kotlinOptionalInt32Constant: Int32? = Int32(4)
// SKIP @BridgeToSwift
public let kotlinOptionalInt64Constant: Int64? = Int64(5)
// SKIP @BridgeToSwift
public let kotlinOptionalIntConstant: Int? = 6
// TODO: Unsigned values
// SKIP @BridgeToSwift
public let kotlinOptionalStringConstant: String? = "s"
// SKIP @BridgeToSwift
public let kotlinOptionalClassConstant: KotlinHelperClass? = KotlinHelperClass()
// SKIP @BridgeToSwift
public let kotlinOptionalSwiftClassConstant: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global vars

// SKIP @BridgeToSwift
public var kotlinBoolVar = true
// TODO: Char
// SKIP @BridgeToSwift
public var kotlinDoubleVar = 1.0
// SKIP @BridgeToSwift
public var kotlinFloatVar = Float(2.0)
// SKIP @BridgeToSwift
public var kotlinInt8Var = Int8(3)
// SKIP @BridgeToSwift
public var kotlinInt16Var = Int16(4)
// SKIP @BridgeToSwift
public var kotlinInt32Var = Int32(5)
// SKIP @BridgeToSwift
public var kotlinInt64Var = Int64(6)
// SKIP @BridgeToSwift
public var kotlinIntVar = 7
// TODO: Unsigned values
// SKIP @BridgeToSwift
public var kotlinStringVar = "s"
// SKIP @BridgeToSwift
public var kotlinClassVar = KotlinHelperClass()
// SKIP @BridgeToSwift
public var kotlinSwiftClassVar = SwiftHelperClass()

// MARK: Global optional vars

// SKIP @BridgeToSwift
public var kotlinOptionalBoolVar: Bool? = true
// TODO: Optional char
// SKIP @BridgeToSwift
public var kotlinOptionalDoubleVar: Double? = 1.0
// SKIP @BridgeToSwift
public var kotlinOptionalFloatVar: Float? = Float(2.0)
// SKIP @BridgeToSwift
public var kotlinOptionalInt8Var: Int8? = nil
// SKIP @BridgeToSwift
public var kotlinOptionalInt16Var: Int16? = Int16(3)
// SKIP @BridgeToSwift
public var kotlinOptionalInt32Var: Int32? = Int32(4)
// SKIP @BridgeToSwift
public var kotlinOptionalInt64Var: Int64? = Int64(5)
// SKIP @BridgeToSwift
public var kotlinOptionalIntVar: Int? = 6
// TODO: Unsigned values
// SKIP @BridgeToSwift
public var kotlinOptionalStringVar: String? = "s"
// SKIP @BridgeToSwift
public var kotlinOptionalClassVar: KotlinHelperClass? = KotlinHelperClass()
// SKIP @BridgeToSwift
public var kotlinOptionalSwiftClassVar: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global computed vars

// SKIP @BridgeToSwift
public var kotlinIntComputedVar: Int {
    get {
        return kotlinIntVar
    }
    set {
        kotlinIntVar = newValue
    }
}

// SKIP @BridgeToSwift
public var kotlinClassComputedVar: KotlinHelperClass {
    get {
        return kotlinClassVar
    }
    set {
        kotlinClassVar = newValue
    }
}

// SKIP @BridgeToSwift
public var kotlinSwiftClassComputedVar: SwiftHelperClass {
    get {
        return kotlinSwiftClassVar
    }
    set {
        kotlinSwiftClassVar = newValue
    }
}

// MARK: Classes

// SKIP @BridgeToSwift
public class KotlinClass {
    public let intConstant = 1
    public let kotlinClassConstant = KotlinHelperClass()

    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public var kotlinClassVar = KotlinHelperClass()
    public var optionalSwiftClassVar = SwiftHelperClass()

    public init() {
    }
}

// SKIP @BridgeToSwift
public class KotlinHelperClass {
    public var stringVar = "s"

    public init() {
    }
}

// MARK: Closures

// SKIP @BridgeToSwift
public var kotlinClosure0Var: () -> Void = { print("original") }
// SKIP @BridgeToSwift
public var kotlinClosure1Var: (Int) -> String = { i in "value = \(i)" }
// SKIP @BridgeToSwift
public var kotlinClosure1PrimitivesVar: (Int64) -> Int = { l in Int(l / 1000) }
// SKIP @BridgeToSwift
public var kotlinClosure1OptionalsVar: (String?) -> Int? = { s in s?.count }

// MARK: Containers

// SKIP @BridgeToSwift
public var kotlinIntArrayVar = [1, 2, 3]
// SKIP @BridgeToSwift
public var kotlinIntStringDictionaryVar = [1: "a", 2: "b", 3: "c"]

// MARK: Functions

//// SKIP @BridgeToSwift
//public func kotlinThrowingFunction() throws {
//    throw KotlinError()
//}

// MARK: Async

// SKIP @BridgeToSwift
public func kotlinAsync0Function() async {
    try? await Task.sleep(nanoseconds: 10_000_000)
}

// SKIP @BridgeToSwift
public func kotlinAsync1Function(i: Int) async -> Int {
    try? await Task.sleep(nanoseconds: 10_000_000)
    return i + 1
}

struct KotlinError: Error {
}
