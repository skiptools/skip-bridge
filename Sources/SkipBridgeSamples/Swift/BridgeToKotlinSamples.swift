// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// MARK: Global constants

// SKIP @bridgeToKotlin
public let swiftBoolConstant = true
//- SKIP @bridgeToKotlin
//- TODO: public let swiftCharacterConstant: Character = "a"
// SKIP @bridgeToKotlin
public let swiftDoubleConstant = 1.0
// SKIP @bridgeToKotlin
public let swiftFloatConstant: Float = 2.0
// SKIP @bridgeToKotlin
public let swiftInt8Constant: Int8 = 3
// SKIP @bridgeToKotlin
public let swiftInt16Constant: Int16 = 4
// SKIP @bridgeToKotlin
public let swiftInt32Constant: Int32 = 5
// SKIP @bridgeToKotlin
public let swiftInt64Constant: Int64 = 6
// SKIP @bridgeToKotlin
public let swiftIntConstant = 7
// TODO: Unsigned values
// SKIP @bridgeToKotlin
public let swiftStringConstant = "s"
// SKIP @bridgeToKotlin
public let swiftClassConstant = SwiftHelperClass()
// SKIP @bridgeToKotlin
public let swiftKotlinClassConstant = KotlinHelperClass()

// MARK: Global optional constants

// SKIP @bridgeToKotlin
public let swiftOptionalBoolConstant: Bool? = true
//- SKIP @bridgeToKotlin
//- TODO: public let swiftOptionalCharacterConstant: Character? = "a"
// SKIP @bridgeToKotlin
public let swiftOptionalDoubleConstant: Double? = 1.0
// SKIP @bridgeToKotlin
public let swiftOptionalFloatConstant: Float? = 2.0
// SKIP @bridgeToKotlin
public let swiftOptionalInt8Constant: Int8? = nil
// SKIP @bridgeToKotlin
public let swiftOptionalInt16Constant: Int16? = 3
// SKIP @bridgeToKotlin
public let swiftOptionalInt32Constant: Int32? = 4
// SKIP @bridgeToKotlin
public let swiftOptionalInt64Constant: Int64? = 5
// SKIP @bridgeToKotlin
public let swiftOptionalIntConstant: Int? = 6
// TODO: Unsigned values
// SKIP @bridgeToKotlin
public let swiftOptionalStringConstant: String? = "s"

// MARK: Global vars

// SKIP @bridgeToKotlin
public var swiftBoolVar = true
//- SKIP @bridgeToKotlin
//- TODO: public var swiftCharacterVar: Character = "a"
// SKIP @bridgeToKotlin
public var swiftDoubleVar = 1.0
// SKIP @bridgeToKotlin
public var swiftFloatVar: Float = 2.0
// SKIP @bridgeToKotlin
public var swiftInt8Var: Int8 = 3
// SKIP @bridgeToKotlin
public var swiftInt16Var: Int16 = 4
// SKIP @bridgeToKotlin
public var swiftInt32Var: Int32 = 5
// SKIP @bridgeToKotlin
public var swiftInt64Var: Int64 = 6
// SKIP @bridgeToKotlin
public var swiftIntVar = 7
// TODO: Unsigned values
// SKIP @bridgeToKotlin
public var swiftStringVar = "s"
// SKIP @bridgeToKotlin
public var swiftClassVar = SwiftHelperClass()
// SKIP @bridgeToKotlin
public var swiftKotlinClassVar = KotlinHelperClass()

// MARK: Global optional vars

// SKIP @bridgeToKotlin
public var swiftOptionalBoolVar: Bool? = true
//- SKIP @bridgeToKotlin
//- TODO: public var swiftOptionalCharacterVar: Character? = "a"
// SKIP @bridgeToKotlin
public var swiftOptionalDoubleVar: Double? = 1.0
// SKIP @bridgeToKotlin
public var swiftOptionalFloatVar: Float? = 2.0
// SKIP @bridgeToKotlin
public var swiftOptionalInt8Var: Int8? = nil
// SKIP @bridgeToKotlin
public var swiftOptionalInt16Var: Int16? = 3
// SKIP @bridgeToKotlin
public var swiftOptionalInt32Var: Int32? = 4
// SKIP @bridgeToKotlin
public var swiftOptionalInt64Var: Int64? = 5
// SKIP @bridgeToKotlin
public var swiftOptionalIntVar: Int? = 6
// TODO: Unsigned values
// SKIP @bridgeToKotlin
public var swiftOptionalStringVar: String? = "s"

// MARK: Global computed vars

// SKIP @bridgeToKotlin
public var swiftIntComputedVar: Int {
    get {
        return swiftIntVar
    }
    set {
        swiftIntVar = newValue
    }
}

// SKIP @bridgeToKotlin
public var swiftClassComputedVar: SwiftHelperClass {
    get {
        return swiftClassVar
    }
    set {
        swiftClassVar = newValue
    }
}

// SKIP @bridgeToKotlin
public var swiftKotlinClassComputedVar: KotlinHelperClass {
    get {
        return swiftKotlinClassVar
    }
    set {
        swiftKotlinClassVar = newValue
    }
}

// MARK: Classes

// SKIP @bridgeToKotlin
public class SwiftClass {
    public let intConstant = 1
    public let swiftClassConstant = SwiftHelperClass()

    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public var swiftClassVar = SwiftHelperClass()
    // TODO: needs to be optional 
//    public var swiftKotlinClassVar = KotlinHelperClass()

    public init() {
    }
}

// SKIP @bridgeToKotlin
public class SwiftHelperClass {
    public var stringVar = "s"

    public init() {
    }
}

// MARK: Unicode

// SKIP @bridgeToKotlin
public let swiftUTF8StringVar1 = "😀" + ""
// SKIP @bridgeToKotlin
public let swiftUTF8StringVar2 = "🚀" + "123"
// SKIP @bridgeToKotlin
public let swiftUTF8StringVar3 = "😀" + "🚀"

// MARK: Sanity check
// This code is not supported by our transpiler and ensures that we're compiling to native Swift

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
