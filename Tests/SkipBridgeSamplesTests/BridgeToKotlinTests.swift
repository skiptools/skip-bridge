// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridgeSamples
import XCTest

// XXXSKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class BridgeToKotlinTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skip-bridge", moduleName: "SkipBridgeSamples")
        #endif
    }

    func testSimpleConstants() {
        XCTAssertEqual(swiftBoolConstant, true)
        XCTAssertEqual(swiftDoubleConstant, 1.0)
        XCTAssertEqual(swiftFloatConstant, Float(2.0))
        XCTAssertEqual(swiftInt8Constant, Int8(3))
        XCTAssertEqual(swiftInt16Constant, Int16(4))
        XCTAssertEqual(swiftInt32Constant, Int32(5))
        XCTAssertEqual(swiftInt64Constant, Int64(6))
        XCTAssertEqual(swiftIntConstant, 7)
        XCTAssertEqual(swiftStringConstant, "s")
    }

    func testSwiftClassConstant() {
        XCTAssertEqual(swiftClassConstant.stringVar, "s")
    }

    func testKotlinClassConstant() {
        XCTAssertEqual(testSupport_swiftKotlinClassConstant_stringVar(), "s")
    }

    func testOptionalConstants() {
        XCTAssertEqual(swiftOptionalBoolVar, true)
        XCTAssertEqual(swiftOptionalDoubleConstant, 1.0)
        XCTAssertEqual(swiftOptionalFloatConstant, Float(2.0))
        XCTAssertNil(swiftOptionalInt8Constant)
        XCTAssertEqual(swiftOptionalInt16Constant, Int16(3))
        XCTAssertEqual(swiftOptionalInt32Constant, Int32(4))
        XCTAssertEqual(swiftOptionalInt64Constant, Int64(5))
        XCTAssertEqual(swiftOptionalIntConstant, 6)
        XCTAssertEqual(swiftOptionalStringConstant, "s")
    }

    func testSimpleVars() {
        swiftBoolVar = false
        XCTAssertEqual(swiftBoolVar, false)
        swiftDoubleVar = 101.0
        XCTAssertEqual(swiftDoubleVar, 101.0)
        swiftFloatVar = Float(102.0)
        XCTAssertEqual(swiftFloatVar, Float(102.0))
        swiftInt8Var = Int8(103)
        XCTAssertEqual(swiftInt8Var, Int8(103))
        swiftInt16Var = Int16(104)
        XCTAssertEqual(swiftInt16Var, Int16(104))
        swiftInt32Var = Int32(105)
        XCTAssertEqual(swiftInt32Var, Int32(105))
        swiftInt64Var = Int64(106)
        XCTAssertEqual(swiftInt64Var, Int64(106))
        swiftIntVar = 107
        XCTAssertEqual(swiftIntVar, 107)
        swiftStringVar = "ss"
        XCTAssertEqual(swiftStringVar, "ss")
    }

    func testSwiftClassVar() {
        let value = SwiftHelperClass()
        value.stringVar = "ss"
        swiftClassVar = value
        XCTAssertEqual(swiftClassVar.stringVar, "ss")
    }

    func testKotlinClassVar() {
        XCTAssertEqual(testSupport_swiftKotlinClassVar_stringVar(value: "ss"), "ss")
    }

    func testOptionalSimpleVars() {
        swiftOptionalBoolVar = false
        XCTAssertEqual(swiftOptionalBoolVar, false)
        swiftOptionalBoolVar = nil
        XCTAssertNil(swiftOptionalBoolVar)
        swiftOptionalDoubleVar = 101.0
        XCTAssertEqual(swiftOptionalDoubleVar, 101.0)
        swiftOptionalDoubleVar = nil
        XCTAssertNil(swiftOptionalDoubleVar)
        swiftOptionalFloatVar = Float(102.0)
        XCTAssertEqual(swiftOptionalFloatVar, Float(102.0))
        swiftOptionalFloatVar = nil
        XCTAssertNil(swiftOptionalFloatVar)
        swiftOptionalInt8Var = Int8(103)
        XCTAssertEqual(swiftOptionalInt8Var, Int8(103))
        swiftOptionalInt8Var = nil
        XCTAssertNil(swiftOptionalInt8Var)
        swiftOptionalInt16Var = Int16(104)
        XCTAssertEqual(swiftOptionalInt16Var, Int16(104))
        swiftOptionalInt16Var = nil
        XCTAssertNil(swiftOptionalInt16Var)
        swiftOptionalInt32Var = Int32(105)
        XCTAssertEqual(swiftOptionalInt32Var, Int32(105))
        swiftOptionalInt32Var = nil
        XCTAssertNil(swiftOptionalInt32Var)
        swiftOptionalInt64Var = Int64(106)
        XCTAssertEqual(swiftOptionalInt64Var, Int64(106))
        swiftOptionalInt64Var = nil
        XCTAssertNil(swiftOptionalInt64Var)
        swiftOptionalIntVar = 107
        XCTAssertEqual(swiftOptionalIntVar, 107)
        swiftOptionalIntVar = nil
        XCTAssertNil(swiftOptionalIntVar)
        swiftOptionalStringVar = "ss"
        XCTAssertEqual(swiftOptionalStringVar, "ss")
        swiftOptionalStringVar = nil
        XCTAssertNil(swiftOptionalStringVar)
    }

    func testOptionalSwiftClassVar() {
        let value = SwiftHelperClass()
        value.stringVar = "ss"
        swiftOptionalClassVar = value
        XCTAssertEqual(swiftOptionalClassVar?.stringVar, "ss")
        swiftOptionalClassVar = nil
        XCTAssertNil(swiftOptionalClassVar)
    }

    func testOptionalKotlinClassVar() {
        XCTAssertEqual(testSupport_swiftOptionalKotlinClassVar_stringVar(value: "ss"), "ss")
        XCTAssertNil(testSupport_swiftOptionalKotlinClassVar_stringVar(value: nil))
    }

    func testComputedVar() {
        swiftIntComputedVar = 99
        XCTAssertEqual(swiftIntComputedVar, 99)
    }

    func testComputedSwiftClassVar() {
        let value = SwiftHelperClass()
        value.stringVar = "computed"
        swiftClassComputedVar = value
        XCTAssertEqual(swiftClassComputedVar.stringVar, "computed")
    }

    func testComputedKotlinClassVar() {
        XCTAssertEqual(testSupport_swiftKotlinClassComputedVar_stringVar(value: "computed"), "computed")
    }

    func testSwiftClassMemberConstant() {
        let value = SwiftClass()
        XCTAssertEqual(value.intConstant, 1)
    }

    func testSwiftClassMemberVar() {
        let value = SwiftClass()
        value.intVar = 99
        XCTAssertEqual(value.intVar, 99)
    }

    func testSwiftClassMemberOptionalVar() {
        let value = SwiftClass()
        value.optionalIntVar = 100
        XCTAssertEqual(value.optionalIntVar, 100)
        value.optionalIntVar = nil
        XCTAssertNil(value.optionalIntVar)
    }

    func testSwiftClassMemberSwiftClassConstant() {
        let value = SwiftClass()
        XCTAssertEqual(value.swiftClassConstant.stringVar, "s")
    }

    func testSwiftClassMemberSwiftClassVar() {
        let helper = SwiftHelperClass()
        helper.stringVar = "member"
        let value = SwiftClass()
        value.swiftClassVar = helper
        XCTAssertEqual(value.swiftClassVar.stringVar, "member")
    }

    func testSwiftClassMemberKotlinClassVar() {
        XCTAssertEqual(testSupport_swiftKotlinClassMemberVar_stringVar(value: "member"), "member")
    }

    func testUnicode() {
        XCTAssertEqual("😀", swiftUTF8StringVar1)
        XCTAssertEqual("🚀123456", swiftUTF8StringVar2)
        XCTAssertEqual("😀🚀", swiftUTF8StringVar3)

        #if !SKIP
        let codePoints: [UInt8] = Array(swiftUTF8StringVar3.utf8)
        #else
        let codePoints: [UInt8] = Array(swiftUTF8StringVar3.toByteArray(Charsets.UTF_8).toList().map({ UByte($0) }))
        #endif
        XCTAssertEqual([240, 159, 152, 128, 240, 159, 154, 128], codePoints.map({ Int($0) }))

        #if SKIP && false
        // when we just use NewStringUTF, this is how strings fail
        XCTAssertNotEqual("😀🚀", swiftUTF8StringVar3)
        XCTAssertEqual([240, 159], codePoints)
        #endif
    }

    func testGlobalFunction() {
        XCTAssertEqual(8, multiplyInt32s(i1: 2, i2: 4))
    }
}

/*


// MARK: Classes

// SKIP @bridgeToKotlin
public class SwiftClass {
    public let intConstant = 1
    public let swiftClassConstant = SwiftHelperClass()

    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public var swiftClassVar = SwiftHelperClass()
    public var swiftKotlinClassVar = KotlinHelperClass()
}

// SKIP @bridgeToKotlin
public class SwiftHelperClass {
    public var stringVar = "s"
}
*/
