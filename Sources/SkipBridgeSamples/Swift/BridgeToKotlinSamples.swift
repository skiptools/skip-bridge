// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridge

// MARK: Global constants

// SKIP @BridgeToKotlin
public let swiftBoolConstant = true
// TODO: Char
// SKIP @BridgeToKotlin
public let swiftDoubleConstant = 1.0
// SKIP @BridgeToKotlin
public let swiftFloatConstant: Float = 2.0
// SKIP @BridgeToKotlin
public let swiftInt8Constant: Int8 = 3
// SKIP @BridgeToKotlin
public let swiftInt16Constant: Int16 = 4
// SKIP @BridgeToKotlin
public let swiftInt32Constant: Int32 = 5
// SKIP @BridgeToKotlin
public let swiftInt64Constant: Int64 = 6
// SKIP @BridgeToKotlin
public let swiftIntConstant = 7
// TODO: Unsigned values
// SKIP @BridgeToKotlin
public let swiftStringConstant = "s"
// SKIP @BridgeToKotlin
public let swiftClassConstant = SwiftHelperClass()
// SKIP @BridgeToKotlin
public let swiftKotlinClassConstant = KotlinHelperClass()

// MARK: Global optional constants

// SKIP @BridgeToKotlin
public let swiftOptionalBoolConstant: Bool? = true
// TODO: Optional char
// SKIP @BridgeToKotlin
public let swiftOptionalDoubleConstant: Double? = 1.0
// SKIP @BridgeToKotlin
public let swiftOptionalFloatConstant: Float? = 2.0
// SKIP @BridgeToKotlin
public let swiftOptionalInt8Constant: Int8? = nil
// SKIP @BridgeToKotlin
public let swiftOptionalInt16Constant: Int16? = 3
// SKIP @BridgeToKotlin
public let swiftOptionalInt32Constant: Int32? = 4
// SKIP @BridgeToKotlin
public let swiftOptionalInt64Constant: Int64? = 5
// SKIP @BridgeToKotlin
public let swiftOptionalIntConstant: Int? = 6
// TODO: Unsigned values
// SKIP @BridgeToKotlin
public let swiftOptionalStringConstant: String? = "s"
// SKIP @BridgeToKotlin
public let swiftOptionalClassConstant: SwiftHelperClass? = SwiftHelperClass()
// SKIP @BridgeToKotlin
public let swiftOptionalKotlinClassConstant: KotlinHelperClass? = KotlinHelperClass()

// MARK: Global vars

// SKIP @BridgeToKotlin
public var swiftBoolVar = true
// TODO: Char
// SKIP @BridgeToKotlin
public var swiftDoubleVar = 1.0
// SKIP @BridgeToKotlin
public var swiftFloatVar: Float = 2.0
// SKIP @BridgeToKotlin
public var swiftInt8Var: Int8 = 3
// SKIP @BridgeToKotlin
public var swiftInt16Var: Int16 = 4
// SKIP @BridgeToKotlin
public var swiftInt32Var: Int32 = 5
// SKIP @BridgeToKotlin
public var swiftInt64Var: Int64 = 6
// SKIP @BridgeToKotlin
public var swiftIntVar = 7
// TODO: Unsigned values
// SKIP @BridgeToKotlin
public var swiftStringVar = "s"
// SKIP @BridgeToKotlin
public var swiftClassVar = SwiftHelperClass()
// SKIP @BridgeToKotlin
public var swiftKotlinClassVar = KotlinHelperClass()

// MARK: Global optional vars

// SKIP @BridgeToKotlin
public var swiftOptionalBoolVar: Bool? = true
// TODO: Optional char
// SKIP @BridgeToKotlin
public var swiftOptionalDoubleVar: Double? = 1.0
// SKIP @BridgeToKotlin
public var swiftOptionalFloatVar: Float? = 2.0
// SKIP @BridgeToKotlin
public var swiftOptionalInt8Var: Int8? = nil
// SKIP @BridgeToKotlin
public var swiftOptionalInt16Var: Int16? = 3
// SKIP @BridgeToKotlin
public var swiftOptionalInt32Var: Int32? = 4
// SKIP @BridgeToKotlin
public var swiftOptionalInt64Var: Int64? = 5
// SKIP @BridgeToKotlin
public var swiftOptionalIntVar: Int? = 6
// TODO: Unsigned values
// SKIP @BridgeToKotlin
public var swiftOptionalStringVar: String? = "s"
// SKIP @BridgeToKotlin
public var swiftOptionalClassVar: SwiftHelperClass? = SwiftHelperClass()
// SKIP @BridgeToKotlin
public var swiftOptionalKotlinClassVar: KotlinHelperClass? = KotlinHelperClass()

// MARK: Global computed vars

// SKIP @BridgeToKotlin
public var swiftIntComputedVar: Int {
    get {
        return swiftIntVar
    }
    set {
        swiftIntVar = newValue
    }
}

// SKIP @BridgeToKotlin
public var swiftClassComputedVar: SwiftHelperClass {
    get {
        return swiftClassVar
    }
    set {
        swiftClassVar = newValue
    }
}

// SKIP @BridgeToKotlin
public var swiftKotlinClassComputedVar: KotlinHelperClass {
    get {
        return swiftKotlinClassVar
    }
    set {
        swiftKotlinClassVar = newValue
    }
}

// MARK: Classes

// SKIP @BridgeToKotlin
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

// SKIP @BridgeToKotlin
public class SwiftHelperClass {
    public var stringVar = "s"

    public init() {
    }
}

// MARK: Closures

// SKIP @BridgeToKotlin
public var swiftClosure0Var: () -> Void = { print("original") }
// SKIP @BridgeToKotlin
public var swiftClosure1Var: (Int) -> String = { i in "value = \(i)" }
// SKIP @BridgeToKotlin
public var swiftClosure1PrimitivesVar: (Int64) -> Int = { l in Int(l / 1000) }
// SKIP @BridgeToKotlin
public var swiftClosure1OptionalsVar: (String?) -> Int? = { s in s?.count }

// MARK: Containers

// SKIP @BridgeToKotlin
public var swiftIntArrayVar = [1, 2, 3]
// SKIP @BridgeToKotlin
public var swiftIntStringDictionaryVar = [1: "a", 2: "b", 3: "c"]

// MARK: Functions

// SKIP @BridgeToKotlin
public func swiftThrowingFunction(shouldThrow: Bool) throws -> Int {
    if shouldThrow {
        throw SwiftSampleError()
    } else {
        return 1
    }
}

// SKIP @BridgeToKotlin
public func swiftThrowingVoidFunction(shouldThrow: Bool) throws {
    if shouldThrow {
        throw SwiftSampleError()
    }
}

// MARK: Async

// SKIP @BridgeToKotlin
public func swiftAsync0Function() async {
    try? await Task.sleep(nanoseconds: 10_000_000)
}

// SKIP @BridgeToKotlin
public func swiftAsync1Function(i: Int) async -> Int {
    try? await Task.sleep(nanoseconds: 10_000_000)
    return i + 1
}

// SKIP @BridgeToKotlin
public func swiftAsyncThrowingFunction(shouldThrow: Bool) async throws -> Int {
    if shouldThrow {
        throw SwiftSampleError()
    } else {
        return 1
    }
}

// SKIP @BridgeToKotlin
public func swiftAsyncThrowingVoidFunction(shouldThrow: Bool) async throws {
    if shouldThrow {
        throw SwiftSampleError()
    }
}

// MARK: Unicode

// SKIP @BridgeToKotlin
public let swiftUTF8StringVar1 = "😀" + ""
// SKIP @BridgeToKotlin
public let swiftUTF8StringVar2 = "🚀" + "123" + "456"
// SKIP @BridgeToKotlin
public let swiftUTF8StringVar3 = "😀" + "🚀"

// MARK: Observation

#if compiler(>=6.0)
// SKIP @BridgeToKotlin
public func swiftExerciseObservable() {
    if #available(macOS 14, iOS 17, *) {
        let obj = ObservedClass()
        obj.i += 1
    }
}
#endif

struct SwiftSampleError: Error {
}

// MARK: Sanity check
// This code is not supported by our transpiler and ensures that we're compiling to native Swift

// SKIP @BridgeToKotlin
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
