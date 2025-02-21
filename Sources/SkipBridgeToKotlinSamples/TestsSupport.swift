// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridge
import SkipBridgeToKotlinSamplesHelpers

public func testSupport_swiftKotlinClassVar_stringVar(value: String) -> String {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    swiftKotlinClassVar = helper
    return swiftKotlinClassVar.stringVar
}

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

public func testSupport_swiftKotlinClassComputedVar_stringVar(value: String) -> String {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    swiftKotlinClassComputedVar = helper
    return swiftKotlinClassComputedVar.stringVar
}

public func testSupport_swiftKotlinClassMemberVar_stringVar(value: String) -> String? {
    let helper = KotlinHelperClass()
    helper.stringVar = value
    let subject = SwiftClass()
    subject.optionalKotlinClassVar = helper
    return subject.optionalKotlinClassVar?.stringVar
}

public func testSupport_swiftKotlinClassConstant_stringVar() -> String {
    return swiftKotlinClassConstant.stringVar
}

public func testSupport_dynamicJavaObjectProperties() throws -> Bool {
    let date = try AnyDynamicObject(className: "java.util.Date", 999)
    guard date.time == 999 else {
        return false
    }

    date.time = 100
    guard date.time == 100 else {
        return false
    }
    return true
}

public func testSupport_dynamicJavaObjectTraversal() throws -> Bool {
    let date = try AnyDynamicObject(className: "java.util.Date")
    let string: String = try date.toInstant()!.toString()!
    return !string.isEmpty
}

public func testSupport_dynamicJavaObjectFunctions() throws -> Bool {
    let date = try AnyDynamicObject(className: "java.util.Date", 999)
    guard try date.getTime() == 999 else {
        return false
    }

    try date.setTime(100) as Void
    guard try date.getTime() == 100 else {
        return false
    }
    return true
}

public func testSupport_dynamicKotlinObjects() throws -> Bool {
    let dict = try AnyDynamicObject(className: "skip.lib.Dictionary")
    try dict.put(key: "a", value: 1) as Void
    try dict.put(key: "b", value: 2) as Void
    try dict.put(key: "c", value: 3) as Void
    let count: Int = dict.keys!.count!
    guard count == 3 else {
        return false
    }
    let aValue: Int? = try dict.get("a")
    guard aValue == 1 else {
        return false
    }
    let dValue: Int? = try dict.get("d")
    guard dValue == nil else {
        return false
    }
    return true
}

public func testSupport_dynamicConverting() throws -> Bool {
    // Test that we can retrieve our bridged types from their Kotlin equivalents
    let arr = try AnyDynamicObject(className: "skip.lib.Array")
    try arr.append(1) as Void
    try arr.append(2) as Void
    try arr.append(3) as Void
    let size: Int = arr.count!
    guard size == 3 else {
        return false
    }

    let converted: [Int] = try arr.kotlin(nocopy: true)! // .kotlin() returns List, which converts
    guard converted == [1, 2, 3] else {
        return false
    }

    let url = try AnyDynamicObject(className: "java.net.URL", "https://skip.tools")
    let uri: URL = try url.toURI()! // java.net.URI converts
    guard uri.absoluteString == "https://skip.tools" else {
        return false
    }

    return true
}

public func testSupport_dynamicStatics() throws -> Bool {
    let math = try AnyDynamicObject(forStaticsOfClassName: "java.lang.Math")
    let abs: Double = try math.abs(-1.0)!
    guard abs == 1.0 else {
        return false
    }

    let pi: Double = math.PI!
    guard Int(pi * 100.0) == 314 else {
        return false
    }
    return true
}

#if os(Android) || ROBOLECTRIC
public func testSupport_dynamicCodeGenJavaDateTime() throws -> Int64 {
    return try K.java.util.Date().time!
}

public func testSupport_dynamicCodeGenSkipDateTime() -> Double {
    return K.skip.foundation.Date.Companion().now!.timeIntervalSince1970!
}
#endif
