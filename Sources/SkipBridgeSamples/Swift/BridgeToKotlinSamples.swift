// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridge
import SkipBridgeMacros

// MARK: Global constants

@BridgeToKotlin public let swiftBoolConstant = true
//- TODO: @BridgeToKotlin public let swiftCharacterConstant: Character = "a"
@BridgeToKotlin public let swiftDoubleConstant = 1.0
@BridgeToKotlin public let swiftFloatConstant: Float = 2.0
@BridgeToKotlin public let swiftInt8Constant: Int8 = 3
@BridgeToKotlin public let swiftInt16Constant: Int16 = 4
@BridgeToKotlin public let swiftInt32Constant: Int32 = 5
@BridgeToKotlin public let swiftInt64Constant: Int64 = 6
@BridgeToKotlin public let swiftIntConstant = 7
// TODO: Unsigned values
@BridgeToKotlin public let swiftStringConstant = "s"
@BridgeToKotlin public let swiftClassConstant = SwiftHelperClass()
@BridgeToKotlin public let swiftKotlinClassConstant = KotlinHelperClass()

// MARK: Global optional constants

@BridgeToKotlin public let swiftOptionalBoolConstant: Bool? = true
//- TODO: @BridgeToKotlin public let swiftOptionalCharacterConstant: Character? = "a"
@BridgeToKotlin public let swiftOptionalDoubleConstant: Double? = 1.0
@BridgeToKotlin public let swiftOptionalFloatConstant: Float? = 2.0
@BridgeToKotlin public let swiftOptionalInt8Constant: Int8? = nil
@BridgeToKotlin public let swiftOptionalInt16Constant: Int16? = 3
@BridgeToKotlin public let swiftOptionalInt32Constant: Int32? = 4
@BridgeToKotlin public let swiftOptionalInt64Constant: Int64? = 5
@BridgeToKotlin public let swiftOptionalIntConstant: Int? = 6
// TODO: Unsigned values
@BridgeToKotlin public let swiftOptionalStringConstant: String? = "s"
@BridgeToKotlin public let swiftOptionalClassConstant: SwiftHelperClass? = SwiftHelperClass()
@BridgeToKotlin public let swiftOptionalKotlinClassConstant: KotlinHelperClass? = KotlinHelperClass()

// MARK: Global vars

@BridgeToKotlin public var swiftBoolVar = true
//- TODO: @BridgeToKotlin public var swiftCharacterVar: Character = "a"
@BridgeToKotlin public var swiftDoubleVar = 1.0
@BridgeToKotlin public var swiftFloatVar: Float = 2.0
@BridgeToKotlin public var swiftInt8Var: Int8 = 3
@BridgeToKotlin public var swiftInt16Var: Int16 = 4
@BridgeToKotlin public var swiftInt32Var: Int32 = 5
@BridgeToKotlin public var swiftInt64Var: Int64 = 6
@BridgeToKotlin public var swiftIntVar = 7
// TODO: Unsigned values
@BridgeToKotlin public var swiftStringVar = "s"
@BridgeToKotlin public var swiftClassVar = SwiftHelperClass()
@BridgeToKotlin public var swiftKotlinClassVar = KotlinHelperClass()

// MARK: Global optional vars

@BridgeToKotlin public var swiftOptionalBoolVar: Bool? = true
//- TODO: @BridgeToKotlin public var swiftOptionalCharacterVar: Character? = "a"
@BridgeToKotlin public var swiftOptionalDoubleVar: Double? = 1.0
@BridgeToKotlin public var swiftOptionalFloatVar: Float? = 2.0
@BridgeToKotlin public var swiftOptionalInt8Var: Int8? = nil
@BridgeToKotlin public var swiftOptionalInt16Var: Int16? = 3
@BridgeToKotlin public var swiftOptionalInt32Var: Int32? = 4
@BridgeToKotlin public var swiftOptionalInt64Var: Int64? = 5
@BridgeToKotlin public var swiftOptionalIntVar: Int? = 6
// TODO: Unsigned values
@BridgeToKotlin public var swiftOptionalStringVar: String? = "s"
@BridgeToKotlin public var swiftOptionalClassVar: SwiftHelperClass? = SwiftHelperClass()
@BridgeToKotlin public var swiftOptionalKotlinClassVar: KotlinHelperClass? = KotlinHelperClass()

// MARK: Global computed vars

@BridgeToKotlin
public var swiftIntComputedVar: Int {
    get {
        return swiftIntVar
    }
    set {
        swiftIntVar = newValue
    }
}

@BridgeToKotlin
public var swiftClassComputedVar: SwiftHelperClass {
    get {
        return swiftClassVar
    }
    set {
        swiftClassVar = newValue
    }
}

@BridgeToKotlin
public var swiftKotlinClassComputedVar: KotlinHelperClass {
    get {
        return swiftKotlinClassVar
    }
    set {
        swiftKotlinClassVar = newValue
    }
}

// MARK: Classes

@BridgeToKotlin
public class SwiftClass {
    public let intConstant = 1
    public let swiftClassConstant = SwiftHelperClass()

    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public var swiftClassVar = SwiftHelperClass()
    public var optionalKotlinClassVar: KotlinHelperClass?

    public init() {
    }
}

@BridgeToKotlin
public class SwiftHelperClass {
    public var stringVar = "s"

    public init() {
    }
}

// MARK: Closures

@BridgeToKotlin public var swiftClosure0Var: () -> Void = { print("original") }
@BridgeToKotlin public var swiftClosure1Var: (Int) -> String = { i in "value = \(i)" }
@BridgeToKotlin public var swiftClosure1PrimitivesVar: (Int64) -> Int = { l in Int(l / 1000) }
@BridgeToKotlin public var swiftClosure1OptionalsVar: (String?) -> Int? = { s in s?.count }

// MARK: Containers

@BridgeToKotlin public var swiftIntArrayVar = [1, 2, 3]
@BridgeToKotlin public var swiftIntStringDictionaryVar = [1: "a", 2: "b", 3: "c"]

// MARK: Async

@BridgeToKotlin
public func swiftAsync0Function() async {
    try? await Task.sleep(nanoseconds: 10_000_000)
}

@BridgeToKotlin
public func swiftAsync1Function(i: Int) async -> Int {
    try? await Task.sleep(nanoseconds: 10_000_000)
    return i + 1
}

// MARK: Unicode

@BridgeToKotlin public let swiftUTF8StringVar1 = "😀" + ""
@BridgeToKotlin public let swiftUTF8StringVar2 = "🚀" + "123" + "456"
@BridgeToKotlin public let swiftUTF8StringVar3 = "😀" + "🚀"

// MARK: Observation

@BridgeToKotlin
public func swiftExerciseObservable() {
    if #available(macOS 14, *) {
        let obj = ObservedClass()
        obj.i += 1
    }
}

// MARK: Sanity check
// This code is not supported by our transpiler and ensures that we're compiling to native Swift

@BridgeToKotlin
public func multiplyInt32s(i1: Int32, i2: Int32) -> Int32 {
    // FIXME: no-name parameters don't bridge: multiplyInt32s(_ i1: Int32, _ i2: Int32):
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
