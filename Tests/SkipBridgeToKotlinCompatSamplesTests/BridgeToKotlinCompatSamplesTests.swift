// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
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
        let url = java.net.URI("https://skip.dev")
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

        let url = java.net.URI("https://skip.dev")
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

    func testCompatNestedClosureCallback() {
        #if SKIP
        let compat = Compat(id: java.util.UUID.randomUUID())
        let originalURL = java.net.URI("https://skip.dev/original")
        let updatedURL = java.net.URI("https://skip.dev/updated")
        var receivedURL: java.net.URI?

        compat.nestedURLCallback = { currentURL, completion in
            receivedURL = currentURL
            completion(updatedURL)
        }

        compat.invokeNestedURLCallback(with: originalURL)

        XCTAssertEqual(receivedURL, originalURL)
        XCTAssertEqual(compat.nestedURLCallbackValue, updatedURL)
        #endif
    }

    func testCompatNestedClosureCallbackArities() {
        #if SKIP
        let compat = Compat(id: java.util.UUID.randomUUID())
        let originalURL = java.net.URI("https://skip.dev/original")
        let updatedURL = java.net.URI("https://skip.dev/updated")
        var receivedURL0: java.net.URI?
        var receivedURL2: java.net.URI?
        var receivedURL3: java.net.URI?
        var receivedURL4: java.net.URI?
        var receivedURL5: java.net.URI?
        var returnedURL0: java.net.URI?
        var returnedURL2: java.net.URI?
        var returnedURL3: java.net.URI?
        var returnedURL4: java.net.URI?
        var returnedURL5: java.net.URI?

        compat.nestedURLCallback0 = { currentURL, completion in
            receivedURL0 = currentURL
            returnedURL0 = completion()
        }
        compat.nestedURLCallback2 = { currentURL, completion in
            receivedURL2 = currentURL
            returnedURL2 = completion(2, updatedURL)
        }
        compat.nestedURLCallback3 = { currentURL, completion in
            receivedURL3 = currentURL
            returnedURL3 = completion(2, 3, updatedURL)
        }
        compat.nestedURLCallback4 = { currentURL, completion in
            receivedURL4 = currentURL
            returnedURL4 = completion(2, 3, 4, updatedURL)
        }
        compat.nestedURLCallback5 = { currentURL, completion in
            receivedURL5 = currentURL
            returnedURL5 = completion(2, 3, 4, 5, updatedURL)
        }

        compat.invokeNestedURLCallback0(with: originalURL)
        compat.invokeNestedURLCallback2(with: originalURL)
        compat.invokeNestedURLCallback3(with: originalURL)
        compat.invokeNestedURLCallback4(with: originalURL)
        compat.invokeNestedURLCallback5(with: originalURL)

        XCTAssertEqual(receivedURL0, originalURL)
        XCTAssertEqual(receivedURL2, originalURL)
        XCTAssertEqual(receivedURL3, originalURL)
        XCTAssertEqual(receivedURL4, originalURL)
        XCTAssertEqual(receivedURL5, originalURL)
        XCTAssertEqual(compat.nestedURLCallback0Value, java.net.URI("https://skip.dev/callback0"))
        XCTAssertEqual(compat.nestedURLCallback2Value, updatedURL)
        XCTAssertEqual(compat.nestedURLCallback3Value, updatedURL)
        XCTAssertEqual(compat.nestedURLCallback4Value, updatedURL)
        XCTAssertEqual(compat.nestedURLCallback5Value, updatedURL)
        XCTAssertEqual(returnedURL0, java.net.URI("https://skip.dev/callback0"))
        XCTAssertEqual(returnedURL2, java.net.URI("https://skip.dev/callback2"))
        XCTAssertEqual(returnedURL3, java.net.URI("https://skip.dev/callback5"))
        XCTAssertEqual(returnedURL4, java.net.URI("https://skip.dev/callback9"))
        XCTAssertEqual(returnedURL5, java.net.URI("https://skip.dev/callback14"))
        #endif
    }
}
