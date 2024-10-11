// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// This file is transpiled to Kotlin with downcalls generated for each @bridgeToSwift

// MARK: Global constants

// SKIP @bridgeToSwift
public let kotlinBoolConstant = true
//- SKIP @bridgeToSwift
//- TODO: public let kotlinCharacterConstant: Character = "a"
// SKIP @bridgeToSwift
public let kotlinDoubleConstant = 1.0
// SKIP @bridgeToSwift
public let kotlinFloatConstant = Float(2.0)
// SKIP @bridgeToSwift
public let kotlinInt8Constant = Int8(3)
// SKIP @bridgeToSwift
public let kotlinInt16Constant = Int16(4)
// SKIP @bridgeToSwift
public let kotlinInt32Constant = Int32(5)
// SKIP @bridgeToSwift
public let kotlinInt64Constant = Int64(6)
// SKIP @bridgeToSwift
public let kotlinIntConstant = 7
// TODO: Unsigned values
// SKIP @bridgeToSwift
public let kotlinStringConstant = "s"
// SKIP @bridgeToSwift
public var kotlinClassConstant = KotlinHelperClass()
// SKIP @bridgeToSwift
public var kotlinSwiftClassConstant = SwiftHelperClass()

// MARK: Global optional constants

// SKIP @bridgeToSwift
public let kotlinOptionalBoolConstant: Bool? = true
//- SKIP @bridgeToSwift
//- TODO: public let kotlinOptionalCharacterConstant: Character? = "a"
// SKIP @bridgeToSwift
public let kotlinOptionalDoubleConstant: Double? = 1.0
// SKIP @bridgeToSwift
public let kotlinOptionalFloatConstant: Float? = Float(2.0)
// SKIP @bridgeToSwift
public let kotlinOptionalInt8Constant: Int8? = nil
// SKIP @bridgeToSwift
public let kotlinOptionalInt16Constant: Int16? = Int16(3)
// SKIP @bridgeToSwift
public let kotlinOptionalInt32Constant: Int32? = Int32(4)
// SKIP @bridgeToSwift
public let kotlinOptionalInt64Constant: Int64? = Int64(5)
// SKIP @bridgeToSwift
public let kotlinOptionalIntConstant: Int? = 6
// TODO: Unsigned values
// SKIP @bridgeToSwift
public let kotlinOptionalStringConstant: String? = "s"
// SKIP @bridgeToSwift
public let kotlinOptionalClassConstant: KotlinHelperClass? = KotlinHelperClass()
// SKIP @bridgeToSwift
public let kotlinOptionalSwiftClassConstant: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global vars

// SKIP @bridgeToSwift
public var kotlinBoolVar = true
//- SKIP @bridgeToSwift
//- TODO: public var kotlinCharacterVar: Character = "a"
// SKIP @bridgeToSwift
public var kotlinDoubleVar = 1.0
// SKIP @bridgeToSwift
public var kotlinFloatVar = Float(2.0)
// SKIP @bridgeToSwift
public var kotlinInt8Var = Int8(3)
// SKIP @bridgeToSwift
public var kotlinInt16Var = Int16(4)
// SKIP @bridgeToSwift
public var kotlinInt32Var = Int32(5)
// SKIP @bridgeToSwift
public var kotlinInt64Var = Int64(6)
// SKIP @bridgeToSwift
public var kotlinIntVar = 7
// TODO: Unsigned values
// SKIP @bridgeToSwift
public var kotlinStringVar = "s"
// SKIP @bridgeToSwift
public var kotlinClassVar = KotlinHelperClass()
// SKIP @bridgeToSwift
public var kotlinSwiftClassVar = SwiftHelperClass()

// MARK: Global optional vars

// SKIP @bridgeToSwift
public var kotlinOptionalBoolVar: Bool? = true
//- SKIP @bridgeToSwift
//- TODO: public var kotlinOptionalCharacterVar: Character? = "a"
// SKIP @bridgeToSwift
public var kotlinOptionalDoubleVar: Double? = 1.0
// SKIP @bridgeToSwift
public var kotlinOptionalFloatVar: Float? = Float(2.0)
// SKIP @bridgeToSwift
public var kotlinOptionalInt8Var: Int8? = nil
// SKIP @bridgeToSwift
public var kotlinOptionalInt16Var: Int16? = Int16(3)
// SKIP @bridgeToSwift
public var kotlinOptionalInt32Var: Int32? = Int32(4)
// SKIP @bridgeToSwift
public var kotlinOptionalInt64Var: Int64? = Int64(5)
// SKIP @bridgeToSwift
public var kotlinOptionalIntVar: Int? = 6
// TODO: Unsigned values
// SKIP @bridgeToSwift
public var kotlinOptionalStringVar: String? = "s"
// SKIP @bridgeToSwift
public var kotlinOptionalClassVar: KotlinHelperClass? = KotlinHelperClass()
// SKIP @bridgeToSwift
public var kotlinOptionalSwiftClassVar: SwiftHelperClass? = SwiftHelperClass()

// MARK: Global computed vars

// SKIP @bridgeToSwift
public var kotlinIntComputedVar: Int {
    get {
        return kotlinIntVar
    }
    set {
        kotlinIntVar = newValue
    }
}

// SKIP @bridgeToSwift
public var kotlinClassComputedVar: KotlinHelperClass {
    get {
        return kotlinClassVar
    }
    set {
        kotlinClassVar = newValue
    }
}

// SKIP @bridgeToSwift
public var kotlinSwiftClassComputedVar: SwiftHelperClass {
    get {
        return kotlinSwiftClassVar
    }
    set {
        kotlinSwiftClassVar = newValue
    }
}

// MARK: Classes

// SKIP @bridgeToSwift
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

// SKIP @bridgeToSwift
public class KotlinHelperClass {
    public var stringVar = "s"

    public init() {
    }
}

// MARK: Closures

// SKIP @bridgeToSwift
public var kotlinClosure1Var: (Int) -> String = { i in "value = \(i)" }
// SKIP @bridgeToSwift
public var kotlinClosure1PrimitiveReturnVar: (String) -> Int = { s in s.count }
