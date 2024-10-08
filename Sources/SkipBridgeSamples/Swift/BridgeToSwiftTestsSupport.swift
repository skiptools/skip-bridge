// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Current limitations on Roboelectric testing require us to go through a compiled wrapper in order to perform our
// tests of bridging Kotlin to Swift.

// SKIP @bridgeToKotlin
public func testSupport_swiftKotlinClassConstant_stringVar() -> String {
    return swiftKotlinClassConstant.stringVar
}

// SKIP @bridgeToKotlin
public func testSupport_swiftKotlinClassVar_replaced_stringVar(string: String) -> String {
    let value = KotlinHelperClass()
    value.stringVar = string
    swiftKotlinClassVar = value
    return swiftKotlinClassVar.stringVar
}

// SKIP @bridgeToKotlin
public func testSupport_swiftKotlinClassComputedVar_replaced_stringVar(string: String) -> String {
    let value = KotlinHelperClass()
    value.stringVar = string
    swiftKotlinClassComputedVar = value
    return swiftKotlinClassComputedVar.stringVar
}

//- SKIP @bridgeToKotlin
//public func testSupport_swiftKotlinClassMemberVar_replaced_stringVar(string: String) -> String {
//    let helper = KotlinHelperClass()
//    helper.stringVar = string
//    let value = SwiftClass()
//    value.swiftKotlinClassVar = helper
//    return value.swiftKotlinClassVar.stringVar
//}
