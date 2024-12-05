// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridgeKt
import SkipBridgeToKotlinCompatSamples
import XCTest

final class BridgeToKotlinCompatTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skip-bridge", moduleName: "SkipBridgeToKotlinCompatSamples")
        #endif
    }

    func testCompatConversions() {
        #if SKIP
        let uuid = java.util.UUID.randomUUID()
        let compat = Compat(id: uuid)
        XCTAssertEqual(uuid, compat.id)
        XCTAssertFalse(uuid === compat.id)

        let list = compat.urls
        XCTAssertEqual(list.size, 0)
        let url = java.net.URI("https://skip.tools")
        compat.urls = listOf(url)
        let list2 = compat.urls
        XCTAssertEqual(list2.size, 1)
        XCTAssertEqual(list2[0], url)
        #endif
    }

    func testCompatTuplePair() {
        #if SKIP
        let uuid = java.util.UUID.randomUUID()
        let compat = Compat(id: uuid)
        XCTAssertEqual(uuid, compat.id)

        let url = java.net.URI("https://skip.tools")
        compat.attempts = Pair(2, url)
        XCTAssertEqual(2, compat.attempts?.first)
        XCTAssertEqual(url, compat.attempts?.second)
        #endif
    }
}
