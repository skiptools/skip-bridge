// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridgeSamples
import SkipBridge
import XCTest

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
        XCTAssertEqual(swiftOptionalBoolConstant, true)
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

    func testSwiftClassMemberStaticConstant() {
        XCTAssertEqual(SwiftClass.staticIntConstant, 1)
    }

    func testSwiftClassMemberStaticVar() {
        SwiftClass.staticIntVar = 99
        XCTAssertEqual(SwiftClass.staticIntVar, 99)
    }

    func testSwiftClassMemberStaticFunc() {
        XCTAssertEqual(SwiftClass.staticFunc(string: "Hello"), "swiftHello")
    }

    public func testSwiftClassEquatable() {
        let lhs = SwiftHelperClass()
        lhs.stringVar = "Hello"
        let rhs = SwiftHelperClass()
        rhs.stringVar = "Hello"
        XCTAssertEqual(lhs, rhs)

        rhs.stringVar = "Goodbye"
        XCTAssertNotEqual(lhs, rhs)
    }

    public func testSwiftClassHashable() {
        let lhs = SwiftHelperClass()
        lhs.stringVar = "Hello"
        let rhs = SwiftHelperClass()
        rhs.stringVar = "Hello"
        XCTAssertEqual(lhs.hashValue, rhs.hashValue)

        rhs.stringVar = "Goodbye"
        XCTAssertNotEqual(lhs.hashValue, rhs.hashValue)
    }

    public func testSwiftClassComparable() {
        let lhs = SwiftHelperClass()
        lhs.stringVar = "aaa"
        let rhs = SwiftHelperClass()
        rhs.stringVar = "bbb"
        XCTAssertTrue(lhs < rhs)

        lhs.stringVar = "bbb"
        rhs.stringVar = "aaa"
        XCTAssertFalse(lhs < rhs)
    }

    public func testSwiftProtocolMember() {
        let obj = SwiftClass()
        obj.optionalSwiftProtocolVar = nil
        XCTAssertNil(obj.optionalSwiftProtocolVar)

        let helper = SwiftHelperClass()
        helper.stringVar = "foo"
        obj.optionalSwiftProtocolVar = helper
        XCTAssertEqual(obj.optionalSwiftProtocolVar?.stringValue(), "foo")

        let obj2 = SwiftClass()
        obj2.optionalSwiftProtocolVar = helper
        XCTAssertEqual(obj.optionalSwiftProtocolVar?.hashValue, obj2.optionalSwiftProtocolVar?.hashValue)
    }

    public func testKotlinProtocolMember() {
        let obj = SwiftClass()
        obj.optionalKotlinProtocolVar = nil
        XCTAssertNil(obj.optionalKotlinProtocolVar)

        let helper = KotlinHelperClass()
        helper.stringVar = "foo"
        obj.optionalKotlinProtocolVar = helper
        XCTAssertEqual(obj.optionalKotlinProtocolVar?.stringValue(), "foo")

        let obj2 = SwiftClass()
        obj2.optionalKotlinProtocolVar = helper
        XCTAssertEqual(obj.optionalSwiftProtocolVar?.hashValue, obj2.optionalSwiftProtocolVar?.hashValue)
    }

    public func testStruct() {
        let s1 = SwiftStruct(string: "2")
        XCTAssertEqual(s1.intVar, 2)

        var s2 = s1
        XCTAssertEqual(s1.intVar, 2)
        s2.intVar = 3
        XCTAssertEqual(s1.intVar, 2)
        XCTAssertEqual(s2.intVar, 3)

        s2.setIntFunc(4)
        XCTAssertEqual(s1.intVar, 2)
        XCTAssertEqual(s2.intVar, 4)
    }

    public func testSwiftStructMember() {
        let obj = SwiftClass()
        var s1 = SwiftStruct(string: "2")
        obj.swiftStructVar = s1

        s1.intVar = 3
        XCTAssertEqual(s1.intVar, 3)
        XCTAssertEqual(obj.swiftStructVar.intVar, 2)

        obj.swiftStructVar.intVar = 99
        var s2 = obj.swiftStructVar
        s2.intVar = 100
        XCTAssertEqual(s1.intVar, 3)
        XCTAssertEqual(s2.intVar, 100)
        XCTAssertEqual(obj.swiftStructVar.intVar, 99)
    }

    public func testKotlinStructMember() {
        let obj = SwiftClass()
        var s1 = KotlinStruct(string: "2")
        obj.kotlinStructVar = s1

        s1.intVar = 3
        XCTAssertEqual(s1.intVar, 3)
        XCTAssertEqual(obj.kotlinStructVar.intVar, 2)

        obj.kotlinStructVar.intVar = 99
        var s2 = obj.kotlinStructVar
        s2.intVar = 100
        XCTAssertEqual(s1.intVar, 3)
        XCTAssertEqual(s2.intVar, 100)
        XCTAssertEqual(obj.kotlinStructVar.intVar, 99)
    }

    public func testClosure0Var() {
        swiftClosure0Var()
        swiftClosure0Var = { print("reassigned") }
        swiftClosure0Var()
    }

    public func testClosure1Var() {
        let orig = swiftClosure1Var
        XCTAssertEqual(swiftClosure1Var(99), "value = 99")
        swiftClosure1Var = { i in "kotlin = \(i)" }
        XCTAssertEqual(swiftClosure1Var(99), "kotlin = 99")
        swiftClosure1Var = orig
        XCTAssertEqual(swiftClosure1Var(99), "value = 99")
    }

    public func testClosure1PrimitivesVar() {
        XCTAssertEqual(swiftClosure1PrimitivesVar(Int64(3000)), 3)
        swiftClosure1PrimitivesVar = { l in Int(l / 500) }
        XCTAssertEqual(swiftClosure1PrimitivesVar(Int64(3000)), 6)
    }

    public func testClosure1OptionalsVar() {
        XCTAssertEqual(swiftClosure1OptionalsVar("abc"), 3)
        XCTAssertNil(swiftClosure1OptionalsVar(nil))
        swiftClosure1OptionalsVar = { s in
            if let s {
                return s.count * 2
            } else {
                return nil
            }
        }
        XCTAssertEqual(swiftClosure1OptionalsVar("abc"), 6)
        XCTAssertNil(swiftClosure1OptionalsVar(nil))
    }

    func testArrays() {
        XCTAssertEqual(swiftIntArrayVar, [1, 2, 3])
        XCTAssertEqual(swiftIntArrayVar[1], 2)
        swiftIntArrayVar = [4, 5, 6, 7]
        XCTAssertEqual(swiftIntArrayVar, [4, 5, 6, 7])
        XCTAssertEqual(swiftIntArrayVar[1], 5)
        swiftIntArrayVar = []
        XCTAssertEqual(swiftIntArrayVar, Array<Int>())
        swiftIntArrayVar.append(99)
        XCTAssertEqual(swiftIntArrayVar, [99])
    }

    func testDictionaries() {
        XCTAssertEqual(swiftIntStringDictionaryVar, [1: "a", 2: "b", 3: "c"])
        XCTAssertEqual(swiftIntStringDictionaryVar[2], "b")
        swiftIntStringDictionaryVar = [4: "d", 5: "e", 6: "f"]
        XCTAssertEqual(swiftIntStringDictionaryVar, [4: "d", 5: "e", 6: "f"])
        XCTAssertEqual(swiftIntStringDictionaryVar[5], "e")
        swiftIntStringDictionaryVar = [:]
        XCTAssertEqual(swiftIntStringDictionaryVar, Dictionary<Int, String>())
    }

    func testThrowsFunctions() throws {
        do {
            try swiftThrowingVoidFunction(shouldThrow: true)
            XCTFail("Should have thrown")
        } catch {
        }
        XCTAssertEqual(try swiftThrowingFunction(shouldThrow: false), 1)
    }

    func testAsyncFunction() async {
        await swiftAsync0Function()
        
        let result = await swiftAsync1Function(i: 99)
        XCTAssertEqual(result, 100)
    }

    func testAsyncThrowsFunctions() async throws {
        do {
            try await swiftAsyncThrowingVoidFunction(shouldThrow: true)
            XCTFail("Should have thrown")
        } catch {
        }
        let result = try await swiftAsyncThrowingFunction(shouldThrow: false)
        XCTAssertEqual(result, 1)
    }

    func testURL() {
        let url = URL(string: "https://skip.tools")!
        XCTAssertEqual(url.absoluteString, swiftMakeURL(matching: url)?.absoluteString)
    }

    func testUUID() {
        let uuid = UUID()
        XCTAssertEqual(uuid.uuidString, swiftMakeUUID(matching: uuid)?.uuidString)
    }

    func testData() {
        let data = "testdata".data(using: .utf8)!
        let roundtripped = swiftMakeData(matching: data)
        XCTAssertEqual(String(data: data, encoding: .utf8), String(data: roundtripped, encoding: .utf8))
    }

    func testDate() {
        let date = Date()
        XCTAssertEqual(date, swiftMakeDate(matching: date))
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

    #if compiler(>=6.0)
    func testExerciseObservable() {
        swiftExerciseObservable()
    }
    #endif

    func testGlobalFunction() {
        XCTAssertEqual(8, multiplyInt32s(i1: 2, i2: 4))
    }
}
