// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridgeToKotlinSamplesHelpers

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

// SKIP @BridgeToKotlin
public func testSupport_swiftKotlinClassConstant_stringVar() -> String {
    return swiftKotlinClassConstant.stringVar
}
