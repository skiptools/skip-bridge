// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridge
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

        let locale = compat.locale
        XCTAssertTrue(locale is java.util.Locale)
        compat.locale = java.util.Locale.CHINA
        XCTAssertEqual(compat.locale, java.util.Locale.CHINA)
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

    func testCompatResultPair() {
        #if SKIP
        let uuid = java.util.UUID.randomUUID()
        let compat = Compat(id: uuid)

        let successResult: Pair<String?, Error?> = Pair("success", nil)
        compat.result = successResult
        XCTAssertEqual("success", compat.result?.first)

        let failureResult: Pair<String?, Error?> = Pair(nil, ErrorException())
        compat.result = failureResult
        XCTAssertNil(compat.result?.first)
        XCTAssertNotNil(compat.result?.second)
        #endif
    }

    func testCompatErrorVar() {
        #if SKIP
        let uuid = java.util.UUID.randomUUID()
        let compat = Compat(id: uuid)

        XCTAssertTrue(compat.errorvar is CompatError)
        XCTAssertTrue(compat.errorvar is Exception)
        compat.errorvar = java.lang.RuntimeException("description")
        XCTAssertTrue(compat.errorvar is Exception)
        XCTAssertTrue(compat.errorvar is Error)
        compat.errorvar = CompatError()
        #endif
    }

    func testCompatAsyncStream() async {
        #if SKIP
        let uuid = java.util.UUID.randomUUID()
        let compat = Compat(id: uuid)

        let flow = compat.makeAsyncStream()
        var collected: [Int] = []
        flow.collect { collected.append($0) }
        XCTAssertEqual(collected, [100, 200])

        let flow2 = compat.makeAsyncStream()
        let collected2 = await compat.collect(stream: flow2)
        XCTAssertEqual(collected2, listOf(100, 200))
        #endif
    }
}
