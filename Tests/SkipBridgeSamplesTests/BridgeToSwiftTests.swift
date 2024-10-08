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

    func testTmp() {
        XCTAssertEqual(1, 1)
    }

    /*
    func testTranspiledVar() throws {
        let i = compiledFuncToTranspiledVar(value: 99)
        XCTAssertEqual(i, 99)
    }

    func testTranspiledOptionalVar() throws {
        let i = compiledFuncToTranspiledOptionalVar(value: 99)
        XCTAssertEqual(i, 99)
        let i2 = compiledFuncToTranspiledOptionalVar(value: nil)
        XCTAssertNil(i2)
    }

    func testTranspiledComputedVar() throws {
        let i = compiledFuncToTranspiledComputedVar()
        XCTAssertEqual(i, 100)
    }

    func testTranspiledCompiledVar() throws {
        let s = compiledFuncToTranspiledCompiledVar()
        XCTAssertEqual(s, "publicVar")
    }

    func testTranspiledClass() throws {
        let str = compiledFuncToTranspiledClassPublicVar(value: "xxx")
        XCTAssertEqual(str, "xxx")
    }

    func testTranspiledTypeCompiledVar() throws {
        let c = TranspiledClass()
        c.publicVar = "fromcompiled"
        compiledVarOfTranspiledType = c

        let c2 = compiledVarOfTranspiledType
        XCTAssertEqual(c2.publicVar, "fromcompiled")
    }

    func testTranspiledTypeCompiledComputedVar() throws {
        let c = compiledComputedVarOfTranspiledType
        XCTAssertEqual(c.publicVar, "publicVar")
    }

    func testTranspiledTypeTranspiledVar() throws {
        let i = compiledFuncToTranspiledVarOfTranspiledType(value: 101)
        XCTAssertEqual(i, 101)
    }

    func testTranspiledTypeCompiledMemberVar() throws {
        let s = compiledFuncToTranspiledVarOfCompiledType(value: "compiledvar")
        XCTAssertEqual(s, "compiledvar")
    }
     */
}

#endif
