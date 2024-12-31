// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridgeKt
import SkipBridgeToKotlinSamples
import SkipBridgeToKotlinSamplesHelpers
import XCTest

final class BridgeToKotlinTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skip-bridge", moduleName: "SkipBridgeToKotlinSamples")
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

    func testSwiftInnerClassVar() {
        let inner = SwiftHelperClass.Inner()
        inner.intVar = 2
        swiftInnerClassVar = inner
        XCTAssertEqual(swiftInnerClassVar.intVar, 2)
    }

    func testKotlinClassVar() {
        XCTAssertEqual(testSupport_swiftKotlinClassVar_stringVar(value: "ss"), "ss")
    }

    func testAnyVar() {
        swiftAnyVar = 1
        XCTAssertEqual(swiftAnyVar as? Int, 1)

        swiftAnyVar = "a"
        XCTAssertEqual(swiftAnyVar as? String, "a")

        let helper = SwiftHelperClass()
        swiftAnyVar = helper
        XCTAssertTrue(swiftAnyVar is SwiftHelperClass)
        XCTAssertEqual(swiftAnyVar as? SwiftHelperClass, helper)
    }

    func testAnyHashableVar() {
        swiftAnyHashableVar = 1
        XCTAssertEqual(swiftAnyHashableVar as? Int, 1)

        let helper = SwiftHelperClass()
        swiftAnyHashableVar = helper
        XCTAssertTrue(swiftAnyHashableVar is SwiftHelperClass)
        XCTAssertEqual(swiftAnyHashableVar as? SwiftHelperClass, helper)
    }

    func testAnyVarContainerValues() {
        swiftAnyVar = ["a", 2, 3.0]
        guard let anyArray = swiftAnyVar as? [Any] else {
            return XCTFail()
        }
        XCTAssertEqual(anyArray[0] as? String, "a")
        XCTAssertEqual(anyArray[1] as? Int, 2)
        XCTAssertEqual(anyArray[2] as? Double, 3.0)

        swiftAnyVar = ["a": 1, "b": 2]
        guard let anyDictionary = swiftAnyVar as? [AnyHashable: Any] else {
            return XCTFail()
        }
        XCTAssertEqual(anyDictionary["a"] as? Int, 1)
        XCTAssertEqual(anyDictionary["b"] as? Int, 2)
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

    public func testSwiftSubclass() {
        let sub = SwiftSubclass(string: "sub")
        sub.intVar = 100
        XCTAssertEqual(sub.stringVar, "sub")
        XCTAssertEqual(sub.intVar, 100)

        swiftBaseClassVar = sub
        swiftBaseClassVar.intVar = 101

        let sub2 = swiftBaseClassVar as? SwiftSubclass
        XCTAssertNotNil(sub2)
        XCTAssertEqual(sub2?.stringVar, "sub")
        XCTAssertEqual(sub2?.intVar, 101)
    }

    public func testSwiftProtocolMember() {
        let obj = SwiftClass()
        obj.optionalSwiftProtocolVar = nil
        XCTAssertNil(obj.optionalSwiftProtocolVar)

        let helper = SwiftHelperClass()
        helper.stringVar = "foo"
        obj.optionalSwiftProtocolVar = helper
        XCTAssertEqual(obj.optionalSwiftProtocolVar?.stringValue(), "foo")
        XCTAssertTrue(obj.optionalSwiftProtocolVar is SwiftHelperClass)
        XCTAssertEqual(obj.optionalSwiftProtocolVar?.hashValue, helper.hashValue)
    }

    public func testKotlinProtocolMember() {
        let obj = SwiftClass()
        obj.optionalKotlinProtocolVar = nil
        XCTAssertNil(obj.optionalKotlinProtocolVar)

        let helper = KotlinHelperClass()
        helper.stringVar = "foo"
        obj.optionalKotlinProtocolVar = helper
        XCTAssertEqual(obj.optionalKotlinProtocolVar?.stringValue(), "foo")
        XCTAssertTrue(obj.optionalKotlinProtocolVar is KotlinHelperClass)
        XCTAssertEqual(obj.optionalKotlinProtocolVar?.hashValue, helper.hashValue)
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

    public func testEnum() {
        let e1: SwiftEnum = .age
        XCTAssertFalse(e1.isName())
        XCTAssertEqual(e1.rawValue, "years")
        XCTAssertEqual(e1.intValue, 1)

        let e2 = SwiftEnum(intValue: 0)
        XCTAssertTrue(e2 == .name)
        XCTAssertTrue(e2.isName())

        XCTAssertEqual(SwiftEnum.allCases.count, 2)
    }

    public func testAssociatedValuesEnum() {
        XCTAssertEqual(SwiftAssociatedValuesEnum.caseNames, "a,b")
        let a: SwiftAssociatedValuesEnum = .a(i: 99, "s")
        XCTAssertEqual(a.intValue, 99)
        XCTAssertEqual(a.stringValue(), "s")

        let b: SwiftAssociatedValuesEnum = .b
        XCTAssertNil(b.intValue)
        XCTAssertEqual(b.stringValue(), ".b")

        switch a {
        case .a(let i, let s):
            XCTAssertEqual(i, 99)
            XCTAssertEqual(s, "s")
        case .b:
            XCTFail()
        }
    }

    public func testActor() async {
        let a = SwiftActor(99)
        let value1 = await a.intVar
        XCTAssertEqual(value1, 99)

        await a.setIntVar(100)
        let value2 = await a.intVar
        XCTAssertEqual(value2, 100)
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

    func testSets() {
        XCTAssertEqual(swiftStringSetVar, Set(["a", "b", "c"]))
        XCTAssertEqual(swiftStringSetVar.count, 3)
        XCTAssertTrue(swiftStringSetVar.contains("b"))
        XCTAssertFalse(swiftStringSetVar.contains("d"))
        swiftStringSetVar = ["d", "e", "f", "g"]
        XCTAssertEqual(swiftStringSetVar, ["d", "e", "f", "g"])
        swiftStringSetVar = []
        XCTAssertEqual(swiftStringSetVar, Set<String>())
        swiftStringSetVar.insert("x")
        XCTAssertEqual(swiftStringSetVar, Set(["x"]))
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

    func testTuples() {
        XCTAssertEqual(swiftIntStringTuple.0, 1)
        XCTAssertEqual(swiftIntStringTuple.1, "s")
        swiftIntStringTuple = (2, "a")
        XCTAssertEqual(swiftIntStringTuple.0, 2)
        XCTAssertEqual(swiftIntStringTuple.1, "a")
    }

    func testThrowingFunctions() throws {
        do {
            try swiftThrowingVoidFunction(shouldThrow: true)
            XCTFail("Should have thrown")
        } catch {
        }
        XCTAssertEqual(try swiftThrowingFunction(shouldThrow: false), 1)
    }

    public func testThrowingBridgedErrorFunction() {
        do {
            try swiftThrowingBridgedErrorFunction(shouldThrow: false)
        } catch {
            XCTFail("Should have thrown")
        }
        do {
            try swiftThrowingBridgedErrorFunction(shouldThrow: true)
            XCTFail()
        } catch is SwiftError {
            // Expected
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    public func testThrowingBridgedEnumErrorFunction() {
        do {
            try swiftThrowingBridgedEnumErrorFunction(throw: nil)
        } catch {
            XCTFail("Should have thrown")
        }
        do {
            try swiftThrowingBridgedEnumErrorFunction(throw: 99)
            XCTFail()
        } catch SwiftEnumError.intError(let i) {
            XCTAssertEqual(i, 99)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    func testAsyncThrowsVar() async throws {
        let value = try await swiftAsyncThrowsVar
        XCTAssertEqual(value, 1)
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

    #if SKIP
    func testDynamicJavaObjectProperties() throws {
        XCTAssertTrue(try testSupport_dynamicJavaObjectProperties())
    }

    func testDynamicJavaObjectFunctions() throws {
        XCTAssertTrue(try testSupport_dynamicJavaObjectFunctions())
    }

    func testDynamicJavaObjectTraversal() throws {
        XCTAssertTrue(try testSupport_dynamicJavaObjectTraversal())
    }

    func testDynamicKotlinObjects() throws {
        XCTAssertTrue(try testSupport_dynamicKotlinObjects())
    }

    func testDynamicConverting() throws {
        XCTAssertTrue(try testSupport_dynamicConverting())
    }

    func testDynamicStatics() throws {
        XCTAssertTrue(try testSupport_dynamicStatics())
    }

    func testDynamicCodeGen() throws {
        XCTAssertNotEqual(try testSupport_dynamicCodeGenJavaDateTime(), Int64(0))
        XCTAssertNotEqual(try testSupport_dynamicCodeGenSkipDateTime(), 0.0)
    }
    #endif
}
