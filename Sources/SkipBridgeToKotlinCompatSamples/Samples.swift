// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation

public class Compat {
    public let id: UUID
    public var urls: [URL] = []
    public var attempts: (Int, URL)?
    public var result: Result<String, Error>?
    public var errorvar: Error = CompatError()
    public var locale = Locale.current
    public var nestedURLCallback0: (URL?, @escaping () -> URL) -> Void = { _, _ in }
    public var nestedURLCallback: (URL?, @escaping (URL) -> Void) -> Void = { _, _ in }
    public var nestedURLCallback2: (URL?, @escaping (Int, URL) -> URL) -> Void = { _, _ in }
    public var nestedURLCallback3: (URL?, @escaping (Int, Int, URL) -> URL) -> Void = { _, _ in }
    public var nestedURLCallback4: (URL?, @escaping (Int, Int, Int, URL) -> URL) -> Void = { _, _ in }
    public var nestedURLCallback5: (URL?, @escaping (Int, Int, Int, Int, URL) -> URL) -> Void = { _, _ in }
    public var nestedURLCallback0Value: URL?
    public var nestedURLCallbackValue: URL?
    public var nestedURLCallback2Value: URL?
    public var nestedURLCallback3Value: URL?
    public var nestedURLCallback4Value: URL?
    public var nestedURLCallback5Value: URL?

    public init(id: UUID) {
        self.id = id
    }

    public func makeAsyncStream() -> AsyncStream<Int> {
        let (stream, continuation) = AsyncStream.makeStream(of: Int.self)
        continuation.yield(100)
        continuation.yield(200)
        continuation.finish()
        return stream
    }

    public func collect(stream: AsyncStream<Int>) async -> [Int] {
        var collected: [Int] = []
        for await value in stream {
            collected.append(value)
        }
        return collected
    }

    public func invokeNestedURLCallback(with url: URL?) {
        nestedURLCallback(url) { [weak self] updatedURL in
            self?.nestedURLCallbackValue = updatedURL
        }
    }

    public func invokeNestedURLCallback0(with url: URL?) {
        nestedURLCallback0(url) { [weak self] in
            let result = URL(string: "https://skip.dev/callback0")!
            self?.nestedURLCallback0Value = result
            return result
        }
    }

    public func invokeNestedURLCallback2(with url: URL?) {
        nestedURLCallback2(url) { [weak self] i0, updatedURL in
            let result = URL(string: "https://skip.dev/callback\(i0)")!
            self?.nestedURLCallback2Value = updatedURL
            return result
        }
    }

    public func invokeNestedURLCallback3(with url: URL?) {
        nestedURLCallback3(url) { [weak self] i0, i1, updatedURL in
            let result = URL(string: "https://skip.dev/callback\(i0 + i1)")!
            self?.nestedURLCallback3Value = updatedURL
            return result
        }
    }

    public func invokeNestedURLCallback4(with url: URL?) {
        nestedURLCallback4(url) { [weak self] i0, i1, i2, updatedURL in
            let result = URL(string: "https://skip.dev/callback\(i0 + i1 + i2)")!
            self?.nestedURLCallback4Value = updatedURL
            return result
        }
    }

    public func invokeNestedURLCallback5(with url: URL?) {
        nestedURLCallback5(url) { [weak self] i0, i1, i2, i3, updatedURL in
            let result = URL(string: "https://skip.dev/callback\(i0 + i1 + i2 + i3)")!
            self?.nestedURLCallback5Value = updatedURL
            return result
        }
    }
}

public struct CompatError: Error {
}
