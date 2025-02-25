// Copyright 2024–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation

public class Compat {
    public let id: UUID
    public var urls: [URL] = []
    public var attempts: (Int, URL)?
    public var result: Result<String, Error>?
    public var errorvar: Error = CompatError()
    public var locale = Locale.current

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
}

public struct CompatError: Error {
}
