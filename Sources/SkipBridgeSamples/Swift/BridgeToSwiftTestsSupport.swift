// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridge

// Current limitations on Roboelectric testing require us to go through a compiled wrapper in order to perform our
// tests of bridging Kotlin to Swift.

// SKIP @BridgeToKotlin
public func testSupport_isJNIMode() -> Bool {
    return JNI.isJNIMode
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinBoolConstant() -> Bool {
    return kotlinBoolConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinDoubleConstant() -> Double {
    return kotlinDoubleConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinFloatConstant() -> Float {
    return kotlinFloatConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt8Constant() -> Int8 {
    return kotlinInt8Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt16Constant() -> Int16 {
    return kotlinInt16Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt32Constant() -> Int32 {
    return kotlinInt32Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt64Constant() -> Int64 {
    return kotlinInt64Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinIntConstant() -> Int {
    return kotlinIntConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinStringConstant() -> String {
    return kotlinStringConstant
}

// SKIP @BridgeToKotlin
public func testSupport_swiftKotlinClassConstant_stringVar() -> String {
    return swiftKotlinClassConstant.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinClassConstant_stringVar() -> String {
    return kotlinClassConstant.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinSwiftClassConstant_stringVar() -> String {
    return kotlinSwiftClassConstant.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalBoolConstant() -> Bool? {
    return kotlinOptionalBoolConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalDoubleConstant() -> Double? {
    return kotlinOptionalDoubleConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalFloatConstant() -> Float? {
    return kotlinOptionalFloatConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt8Constant() -> Int8? {
    return kotlinOptionalInt8Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt16Constant() -> Int16? {
    return kotlinOptionalInt16Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt32Constant() -> Int32? {
    return kotlinOptionalInt32Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt64Constant() -> Int64? {
    return kotlinOptionalInt64Constant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalIntConstant() -> Int? {
    return kotlinOptionalIntConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalStringConstant() -> String? {
    return kotlinOptionalStringConstant
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinBoolVar(value: Bool) -> Bool {
    kotlinBoolVar = value
    return kotlinBoolVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinDoubleVar(value: Double) -> Double {
    kotlinDoubleVar = value
    return kotlinDoubleVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinFloatVar(value: Float) -> Float {
    kotlinFloatVar = value
    return kotlinFloatVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt8Var(value: Int8) -> Int8 {
    kotlinInt8Var = value
    return kotlinInt8Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt16Var(value: Int16) -> Int16 {
    kotlinInt16Var = value
    return kotlinInt16Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt32Var(value: Int32) -> Int32 {
    kotlinInt32Var = value
    return kotlinInt32Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinInt64Var(value: Int64) -> Int64 {
    kotlinInt64Var = value
    return kotlinInt64Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinIntVar(value: Int) -> Int {
    kotlinIntVar = value
    return kotlinIntVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinStringVar(value: String) -> String {
    kotlinStringVar = value
    return kotlinStringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinClassVar_stringVar(value: String) -> String {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    kotlinClassVar = helper
    return kotlinClassVar.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinSwiftClassVar_stringVar(value: String) -> String {
    let helper = SwiftHelperClass()
    helper.stringVar = value
    kotlinSwiftClassVar = helper
    return kotlinSwiftClassVar.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalBoolVar(value: Bool?) -> Bool? {
    kotlinOptionalBoolVar = value
    return kotlinOptionalBoolVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalDoubleVar(value: Double?) -> Double? {
    kotlinOptionalDoubleVar = value
    return kotlinOptionalDoubleVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalFloatVar(value: Float?) -> Float? {
    kotlinOptionalFloatVar = value
    return kotlinOptionalFloatVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt8Var(value: Int8?) -> Int8? {
    kotlinOptionalInt8Var = value
    return kotlinOptionalInt8Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt16Var(value: Int16?) -> Int16? {
    kotlinOptionalInt16Var = value
    return kotlinOptionalInt16Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt32Var(value: Int32?) -> Int32? {
    kotlinOptionalInt32Var = value
    return kotlinOptionalInt32Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalInt64Var(value: Int64?) -> Int64? {
    kotlinOptionalInt64Var = value
    return kotlinOptionalInt64Var
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalIntVar(value: Int?) -> Int? {
    kotlinOptionalIntVar = value
    return kotlinOptionalIntVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalStringVar(value: String?) -> String? {
    kotlinOptionalStringVar = value
    return kotlinOptionalStringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalClassVar_stringVar(value: String?) -> String? {
    if let value {
        let helper = KotlinHelperClass()
        helper.stringVar = value
        kotlinOptionalClassVar = helper
    } else {
        kotlinOptionalClassVar = nil
    }
    return kotlinOptionalClassVar?.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinOptionalSwiftClassVar_stringVar(value: String?) -> String? {
    if let value {
        let helper = SwiftHelperClass()
        helper.stringVar = value
        kotlinOptionalSwiftClassVar = helper
    } else {
        kotlinOptionalSwiftClassVar = nil
    }
    return kotlinOptionalSwiftClassVar?.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinIntComputedVar(value: Int) -> Int {
    kotlinIntComputedVar = value
    return kotlinIntComputedVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinClassComputedVar_stringVar(value: String) -> String {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    kotlinClassComputedVar = helper
    return kotlinClassComputedVar.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinSwiftClassComputedVar_stringVar(value: String) -> String {
    let helper = SwiftHelperClass()
    helper.stringVar = value
    kotlinSwiftClassComputedVar = helper
    return kotlinSwiftClassComputedVar.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinClosure0Var() {
    kotlinClosure0Var()
    kotlinClosure0Var = { print("reassigned") }
    kotlinClosure0Var()
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinClosure1Var(value: Int) -> String {
    let s1 = kotlinClosure1Var(value)
    kotlinClosure1Var = { i in "value = \(i)" }
    let s2 = kotlinClosure1Var(value)
    return s1 == s2 ? s1 : s1 + "/" + s2
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinClosure1PrimitivesVar(value: Int64) -> Int {
    let i1 = kotlinClosure1PrimitivesVar(value)
    kotlinClosure1PrimitivesVar = { l in Int(l / 1000) }
    let i2 = kotlinClosure1PrimitivesVar(value)
    return i1 == i2 ? i1 : i1 * 10000 + i2
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinClosure1OptionalsVar(value: String?) -> Int? {
    let i1 = kotlinClosure1OptionalsVar(value)
    kotlinClosure1OptionalsVar = { s in s?.count }
    let i2 = kotlinClosure1OptionalsVar(value)
    return i1 == i2 ? i1 : (i1 ?? 0) * 10000 + (i2 ?? 0)
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinIntArrayVar(value: [Int]) -> [Int] {
    kotlinIntArrayVar = value
    return kotlinIntArrayVar
}

// SKIP @BridgeToKotlin
public func testSupport_kotlinIntStringDictionaryVar(value: [Int: String]) -> [Int: String] {
    kotlinIntStringDictionaryVar = value
    return kotlinIntStringDictionaryVar
}

//// SKIP @BridgeToKotlin
//public func testSupport_callKotlinThrowingFunction() throws {
//    try kotlinThrowingFunction()
//}

// SKIP @BridgeToKotlin
public func testSupport_callKotlinAsync0Function() async {
    await kotlinAsync0Function()
}

// SKIP @BridgeToKotlin
public func testSupport_callKotlinAsync1Function(with value: Int) async -> Int {
    return await kotlinAsync1Function(i: value)
}

// MARK: Used by BridgeToKotlinTests

// SKIP @BridgeToKotlin
public func testSupport_swiftKotlinClassVar_stringVar(value: String) -> String {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    swiftKotlinClassVar = helper
    return swiftKotlinClassVar.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_swiftOptionalKotlinClassVar_stringVar(value: String?) -> String? {
    if let value {
        let helper = KotlinHelperClass()
        helper.stringVar = value
        swiftOptionalKotlinClassVar = helper
    } else {
        swiftOptionalKotlinClassVar = nil
    }
    return swiftOptionalKotlinClassVar?.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_swiftKotlinClassComputedVar_stringVar(value: String) -> String {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    swiftKotlinClassComputedVar = helper
    return swiftKotlinClassComputedVar.stringVar
}

// SKIP @BridgeToKotlin
public func testSupport_swiftKotlinClassMemberVar_stringVar(value: String) -> String? {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    let subject = SwiftClass()
    subject.optionalKotlinClassVar = helper
    return subject.optionalKotlinClassVar?.stringVar
}
