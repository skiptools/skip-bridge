// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridgeKt
import SkipBridgeToSwiftSamplesTestsSupport
import XCTest

final class BridgeToSwiftTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skip-bridge", moduleName: "SkipBridgeToSwiftSamplesTestsSupport")
        #endif
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

    func testOptionalSimpleVars() {
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

    func testOptionalKotlinClassVar() {
        XCTAssertEqual(testSupport_kotlinOptionalClassVar_stringVar(value: "ss"), "ss")
        XCTAssertNil(testSupport_kotlinOptionalClassVar_stringVar(value: nil))
    }

    func testOptionalSwiftClassVar() {
        XCTAssertEqual(testSupport_kotlinOptionalSwiftClassVar_stringVar(value: "ss"), "ss")
        XCTAssertNil(testSupport_kotlinOptionalSwiftClassVar_stringVar(value: nil))
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

    func testKotlinClassMemberConstant() {
        XCTAssertEqual(testSupport_kotlinClassMemberConstant(), 1)
    }

    func testKotlinClassMemberVar() {
        XCTAssertEqual(testSupport_kotlinClassMemberVar(value: 99), 99)
    }

    func testKotlinClassMemberOptionalVar() {
        XCTAssertEqual(testSupport_kotlinClassMemberOptionalVar(value: 99), 99)
        XCTAssertNil(testSupport_kotlinClassMemberOptionalVar(value: nil))
    }

    func testKotlinClassMemberKotlinClassConstant() {
        XCTAssertEqual(testSupport_kotlinClassMemberKotlinClassConstant_stringVar(), "s")
    }

    func testKotlinClassMemberKotlinClassVar() {
        XCTAssertEqual(testSupport_kotlinClassMemberKotlinClassVar_stringVar(value: "member"), "member")
    }

    func testKotlinClassMemberStaticConstant() {
        XCTAssertEqual(testSupport_kotlinClassMemberStaticConstant(), 1)
    }

    func testKotlinClassMemberStaticVar() {
        XCTAssertEqual(testSupport_kotlinClassMemberStaticVar(value: 99), 99)
    }

    func testKotlinClassMemberStaticFunc() {
        XCTAssertEqual(testSupport_kotlinClassMemberStaticFunc(value: "Hello"), "kotlinHello")
    }

    func testKotlinClassEquatable() {
        XCTAssertTrue(testSupport_kotlinClassEquatable(lhs: "Hello", rhs: "Hello"))
        XCTAssertFalse(testSupport_kotlinClassEquatable(lhs: "Hello", rhs: "Goodbye"))
    }

    func testKotlinClassHashable() {
        XCTAssertTrue(testSupport_kotlinClassHashable(lhs: "Hello", rhs: "Hello"))
        XCTAssertFalse(testSupport_kotlinClassHashable(lhs: "Hello", rhs: "Goodbye"))
    }

    func testKotlinClassComparable() {
        XCTAssertTrue(testSupport_kotlinClassComparable(lhs: "aaa", rhs: "bbb"))
        XCTAssertFalse(testSupport_kotlinClassComparable(lhs: "bbb", rhs: "aaa"))
    }

    func testKotlinProtocolMember() {
        XCTAssertNil(testSupport_kotlinProtocolMember())
    }

    func testSwiftProtocolMember() {
        XCTAssertNil(testSupport_swiftProtocolMember())
    }

    public func testStruct() {
        XCTAssertNil(testSupport_kotlinStruct())
    }

    public func testSwiftStructMember() {
        XCTAssertNil(testSupport_swiftStructMember())
    }

    public func testKotlinStructMember() {
        XCTAssertNil(testSupport_kotlinStructMember())
    }

    public func testEnum() {
        XCTAssertNil(testSupport_kotlinEnum())
    }

    func testClosure0Var() {
        testSupport_kotlinClosure0Var()
    }

    func testClosure1Var() {
        XCTAssertEqual(testSupport_kotlinClosure1Var(value: 100), "value = 100")
    }

    func testClosure1PrimitivesVar() {
        XCTAssertEqual(testSupport_kotlinClosure1PrimitivesVar(value: Int64(3000)), 3)
    }

    func testClosure1OptionalsVar() {
        XCTAssertEqual(testSupport_kotlinClosure1OptionalsVar(value: "abc"), 3)
        XCTAssertEqual(testSupport_kotlinClosure1OptionalsVar(value: nil), nil)
    }

    func testArrays() {
        let roundtripped = testSupport_kotlinIntArrayVar(value: [4, 5, 6])
        XCTAssertEqual(roundtripped, [4, 5, 6])
        XCTAssertEqual(roundtripped[1], 5)
    }

    func testSets() {
        let roundtripped = testSupport_kotlinStringSetVar(value: Set(["d", "e", "f"]))
        XCTAssertEqual(roundtripped, Set(["d", "e", "f"]))
        XCTAssertEqual(roundtripped.count, 3)
    }

    func testDictionaries() {
        let roundtripped = testSupport_kotlinIntStringDictionaryVar(value: [4: "d", 5: "e", 6: "f"])
        XCTAssertEqual(roundtripped, [4: "d", 5: "e", 6: "f"])
        XCTAssertEqual(roundtripped[5], "e")
    }

    func testTuples() {
        let roundtripped = testSupport_kotlinIntStringTupleVar(value: (2, "a"))
        XCTAssertEqual(roundtripped.0, 2)
        XCTAssertEqual(roundtripped.1, "a")
    }

    func testThrowingFunctions() throws {
        do {
            try testSupport_callKotlinThrowingVoidFunction(shouldThrow: true)
            XCTFail("Should have thrown")
        } catch {
        }
        XCTAssertEqual(try testSupport_callKotlinThrowingFunction(shouldThrow: false), 1)
    }

    func testAsyncFunctions() async {
        await testSupport_callKotlinAsync0Function()

        let result = await testSupport_callKotlinAsync1Function(with: 99)
        XCTAssertEqual(result, 100)
    }

    func testAsyncThrowsFunctions() async throws {
        do {
            try await testSupport_callKotlinAsyncThrowingVoidFunction(shouldThrow: true)
            XCTFail("Should have thrown")
        } catch {
        }
        let result = try await testSupport_callKotlinAsyncThrowingFunction(shouldThrow: false)
        XCTAssertEqual(result, 1)
    }

    func testURL() {
        let string = "https://skip.tools"
        XCTAssertEqual(string, testSupport_kotlinMakeURL(string: string))
    }

    func testUUID() {
        let string = UUID().uuidString
        XCTAssertEqual(string, testSupport_kotlinMakeUUID(string: string))
    }

    func testData() {
        let string = "datastring"
        XCTAssertEqual(string, testSupport_kotlinMakeData(string: string))
    }

    func testDate() {
        let date = Date()
        XCTAssertEqual(date.timeIntervalSinceReferenceDate, testSupport_kotlinMakeDate(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate))
    }
}
