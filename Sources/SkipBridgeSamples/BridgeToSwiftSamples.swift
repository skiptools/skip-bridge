// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridge

// MARK: Global constants

@BridgeToSwift public let kotlinBoolConstant = true
//- TODO: @BridgeToSwift public let kotlinCharacterConstant: Character = "a"
@BridgeToSwift public let kotlinDoubleConstant = 1.0
@BridgeToSwift public let kotlinFloatConstant = Float(2.0)
@BridgeToSwift public let kotlinInt8Constant = Int8(3)
@BridgeToSwift public let kotlinInt16Constant = Int16(4)
@BridgeToSwift public let kotlinInt32Constant = Int32(5)
@BridgeToSwift public let kotlinInt64Constant = Int64(6)
@BridgeToSwift public let kotlinIntConstant = 7
// TODO: Unsigned values
@BridgeToSwift public let kotlinStringConstant = "s"
@BridgeToSwift public var kotlinClassConstant = KotlinHelperClass()
@BridgeToSwift public var kotlinSwiftClassConstant = SwiftHelperClass()

// MARK: Global optional constants

@BridgeToSwift public let kotlinOptionalBoolConstant: Bool? = true
//- TODO: @BridgeToSwift public let kotlinOptionalCharacterConstant: Character? = "a"
@BridgeToSwift public let kotlinOptionalDoubleConstant: Double? = 1.0
@BridgeToSwift public let kotlinOptionalFloatConstant: Float? = Float(2.0)
@BridgeToSwift public let kotlinOptionalInt8Constant: Int8? = nil
@BridgeToSwift public let kotlinOptionalInt16Constant: Int16? = Int16(3)
@BridgeToSwift public let kotlinOptionalInt32Constant: Int32? = Int32(4)
@BridgeToSwift public let kotlinOptionalInt64Constant: Int64? = Int64(5)
@BridgeToSwift public let kotlinOptionalIntConstant: Int? = 6
// TODO: Unsigned values
@BridgeToSwift public let kotlinOptionalStringConstant: String? = "s"
@BridgeToSwift public let kotlinOptionalClassConstant: KotlinHelperClass? = KotlinHelperClass()
@BridgeToSwift public let kotlinOptionalSwiftClassConstant: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global vars

@BridgeToSwift public var kotlinBoolVar = true
//- TODO: @BridgeToSwift public var kotlinCharacterVar: Character = "a"
@BridgeToSwift public var kotlinDoubleVar = 1.0
@BridgeToSwift public var kotlinFloatVar = Float(2.0)
@BridgeToSwift public var kotlinInt8Var = Int8(3)
@BridgeToSwift public var kotlinInt16Var = Int16(4)
@BridgeToSwift public var kotlinInt32Var = Int32(5)
@BridgeToSwift public var kotlinInt64Var = Int64(6)
@BridgeToSwift public var kotlinIntVar = 7
// TODO: Unsigned values
@BridgeToSwift public var kotlinStringVar = "s"
@BridgeToSwift public var kotlinClassVar = KotlinHelperClass()
@BridgeToSwift public var kotlinSwiftClassVar = SwiftHelperClass()

// MARK: Global optional vars

@BridgeToSwift public var kotlinOptionalBoolVar: Bool? = true
//- TODO: @BridgeToSwift public var kotlinOptionalCharacterVar: Character? = "a"
@BridgeToSwift public var kotlinOptionalDoubleVar: Double? = 1.0
@BridgeToSwift public var kotlinOptionalFloatVar: Float? = Float(2.0)
@BridgeToSwift public var kotlinOptionalInt8Var: Int8? = nil
@BridgeToSwift public var kotlinOptionalInt16Var: Int16? = Int16(3)
@BridgeToSwift public var kotlinOptionalInt32Var: Int32? = Int32(4)
@BridgeToSwift public var kotlinOptionalInt64Var: Int64? = Int64(5)
@BridgeToSwift public var kotlinOptionalIntVar: Int? = 6
// TODO: Unsigned values
@BridgeToSwift public var kotlinOptionalStringVar: String? = "s"
@BridgeToSwift public var kotlinOptionalClassVar: KotlinHelperClass? = KotlinHelperClass()
@BridgeToSwift public var kotlinOptionalSwiftClassVar: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global computed vars

@BridgeToSwift
public var kotlinIntComputedVar: Int {
    get {
        return kotlinIntVar
    }
    set {
        kotlinIntVar = newValue
    }
}

@BridgeToSwift
public var kotlinClassComputedVar: KotlinHelperClass {
    get {
        return kotlinClassVar
    }
    set {
        kotlinClassVar = newValue
    }
}

@BridgeToSwift
public var kotlinSwiftClassComputedVar: SwiftHelperClass {
    get {
        return kotlinSwiftClassVar
    }
    set {
        kotlinSwiftClassVar = newValue
    }
}

// MARK: Classes

@BridgeToSwift
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

@BridgeToSwift
public class KotlinHelperClass {
    public var stringVar = "s"

    public init() {
    }
}

// MARK: Closures

@BridgeToSwift public var kotlinClosure1Var: (Int) -> String = { i in "value = \(i)" }
@BridgeToSwift public var kotlinClosure1PrimitivesVar: (Int64) -> Int = { l in Int(l / 1000) }
@BridgeToSwift public var kotlinClosure1OptionalsVar: (String?) -> Int? = { s in s?.count }

// MARK: Containers

@BridgeToSwift public var kotlinIntArrayVar = [1, 2, 3]
@BridgeToSwift public var kotlinIntStringDictionaryVar = [1: "a", 2: "b", 3: "c"]
