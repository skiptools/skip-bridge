// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridgeSamples
import SkipBridge
import XCTest

final class BridgeToKotlinTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skip-bridge", moduleName: "SkipBridgeSamples")
        #endif
    }

//    func testSimpleConstants() {
//        XCTAssertEqual(swiftBoolConstant, true)
//        XCTAssertEqual(swiftDoubleConstant, 1.0)
//        XCTAssertEqual(swiftFloatConstant, Float(2.0))
//        XCTAssertEqual(swiftInt8Constant, Int8(3))
//        XCTAssertEqual(swiftInt16Constant, Int16(4))
//        XCTAssertEqual(swiftInt32Constant, Int32(5))
//        XCTAssertEqual(swiftInt64Constant, Int64(6))
//        XCTAssertEqual(swiftIntConstant, 7)
//        XCTAssertEqual(swiftStringConstant, "s")
//    }

}
