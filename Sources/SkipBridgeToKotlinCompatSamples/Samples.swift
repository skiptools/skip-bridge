// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
