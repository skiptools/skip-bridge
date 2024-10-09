// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import SkipBridgeSamples
import XCTest

// XXXSKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class BridgeToSwiftTests: XCTestCase {
    override func setUp() {
        loadPeerLibrary("SkipBridgeSamples")
    }

    func testSimpleConstants() {
        XCTAssertEqual(testSupport_kotlinBoolConstant(), true)
        XCTAssertEqual(testSupport_kotlinDoubleConstant(), 1.0)
        XCTAssertEqual(testSupport_kotlinFloatConstant(), Float(2.0))
        XCTAssertEqual(testSupport_kotlinInt8Constant(), Int8(3))
        XCTAssertEqual(testSupport_kotlinInt16Constant(), Int16(4))
        XCTAssertEqual(testSupport_kotlinInt32Constant(), Int32(5))
        XCTAssertEqual(testSupport_kotlinInt64Constant(), Int64(6))
        XCTAssertEqual(testSupport_kotlinIntConstant(), 7)
        XCTAssertEqual(testSupport_kotlinStringConstant(), "s")
    }

    func testKotlinClassConstant() {
        XCTAssertEqual(testSupport_kotlinClassConstant_stringVar(), "s")
    }

    func testSwiftClassConstant() {
        XCTAssertEqual(testSupport_kotlinSwiftClassConstant_stringVar(), "s")
    }

    func testOptionalConstants() {
        XCTAssertEqual(testSupport_kotlinOptionalBoolConstant(), true)
        XCTAssertEqual(testSupport_kotlinOptionalDoubleConstant(), 1.0)
        XCTAssertEqual(testSupport_kotlinOptionalFloatConstant(), Float(2.0))
        XCTAssertNil(testSupport_kotlinOptionalInt8Constant())
        XCTAssertEqual(testSupport_kotlinOptionalInt16Constant(), Int16(3))
        XCTAssertEqual(testSupport_kotlinOptionalInt32Constant(), Int32(4))
        XCTAssertEqual(testSupport_kotlinOptionalInt64Constant(), Int64(5))
        XCTAssertEqual(testSupport_kotlinOptionalIntConstant(), 6)
        XCTAssertEqual(testSupport_kotlinOptionalStringConstant(), "s")
    }

    func testSimpleVars() {
        XCTAssertEqual(testSupport_kotlinBoolVar(value: false), false)
        XCTAssertEqual(testSupport_kotlinDoubleVar(value: 101.0), 101.0)
        XCTAssertEqual(testSupport_kotlinFloatVar(value: Float(102.0)), Float(102.0))
        XCTAssertEqual(testSupport_kotlinInt8Var(value: Int8(103)), Int8(103))
        XCTAssertEqual(testSupport_kotlinInt16Var(value: Int16(104)), Int16(104))
        XCTAssertEqual(testSupport_kotlinInt32Var(value: Int32(105)), Int32(105))
        XCTAssertEqual(testSupport_kotlinInt64Var(value: Int64(106)), Int64(106))
        XCTAssertEqual(testSupport_kotlinIntVar(value: 107), 107)
        XCTAssertEqual(testSupport_kotlinStringVar(value: "ss"), "ss")
    }

    func testKotlinClassVar() {
        XCTAssertEqual(testSupport_kotlinClassVar_stringVar(value: "ss"), "ss")
    }

    func testSwiftClassVar() {
        XCTAssertEqual(testSupport_kotlinSwiftClassVar_stringVar(value: "ss"), "ss")
    }

    func testOptionalVars() {
        XCTAssertEqual(testSupport_kotlinOptionalBoolVar(value: false), false)
        XCTAssertNil(testSupport_kotlinOptionalBoolVar(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalDoubleVar(value: 101.0), 101.0)
        XCTAssertNil(testSupport_kotlinOptionalDoubleVar(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalFloatVar(value: Float(102.0)), Float(102.0))
        XCTAssertNil(testSupport_kotlinOptionalFloatVar(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalInt8Var(value: Int8(103)), Int8(103))
        XCTAssertNil(testSupport_kotlinOptionalInt8Var(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalInt16Var(value: Int16(104)), Int16(104))
        XCTAssertNil(testSupport_kotlinOptionalInt16Var(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalInt32Var(value: Int32(105)), Int32(105))
        XCTAssertNil(testSupport_kotlinOptionalInt32Var(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalInt64Var(value: Int64(106)), Int64(106))
        XCTAssertNil(testSupport_kotlinOptionalInt64Var(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalIntVar(value: 107), 107)
        XCTAssertNil(testSupport_kotlinOptionalIntVar(value: nil))
        XCTAssertEqual(testSupport_kotlinOptionalStringVar(value: "ss"), "ss")
        XCTAssertNil(testSupport_kotlinOptionalStringVar(value: nil))
    }

    func testComputedIntVar() {
        XCTAssertEqual(testSupport_kotlinIntComputedVar(value: 99), 99)
    }

    func testComputedSwiftClassVar() {
        XCTAssertEqual(testSupport_kotlinSwiftClassComputedVar_stringVar(value: "computed"), "computed")
    }

    func testComputedKotlinClassVar() {
        XCTAssertEqual(testSupport_kotlinClassComputedVar_stringVar(value: "computed"), "computed")
    }

    /*
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

    // TODO:
//    #if SKIP
//    func testSwiftClassMemberKotlinClassVar() {
//        XCTAssertEqual(testSupport_swiftKotlinClassMemberVar_stringVar("member"), "member")
//    }
//    #endif
     */
}

#endif
