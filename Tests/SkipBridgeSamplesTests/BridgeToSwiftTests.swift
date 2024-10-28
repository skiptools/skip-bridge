// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridgeSamples
import SkipBridge
import XCTest

final class BridgeToSwiftTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skip-bridge", moduleName: "SkipBridgeSamples")
        #endif
    }

    func testJNIMode() {
        #if SKIP
        // when we are running the bridged tests we expect that SkipBridge will have been built with the `SKIP_JNI_MODE` flag
        XCTAssertEqual(testSupport_isJNIMode(), true)
        #else
        XCTAssertEqual(testSupport_isJNIMode(), false)
        #endif
    }

//    func testSimpleConstants() {
//        XCTAssertEqual(testSupport_kotlinBoolConstant(), true)
//        XCTAssertEqual(testSupport_kotlinDoubleConstant(), 1.0)
//        XCTAssertEqual(testSupport_kotlinFloatConstant(), Float(2.0))
//        XCTAssertEqual(testSupport_kotlinInt8Constant(), Int8(3))
//        XCTAssertEqual(testSupport_kotlinInt16Constant(), Int16(4))
//        XCTAssertEqual(testSupport_kotlinInt32Constant(), Int32(5))
//        XCTAssertEqual(testSupport_kotlinInt64Constant(), Int64(6))
//        XCTAssertEqual(testSupport_kotlinIntConstant(), 7)
//        XCTAssertEqual(testSupport_kotlinStringConstant(), "s")
//    }
}
