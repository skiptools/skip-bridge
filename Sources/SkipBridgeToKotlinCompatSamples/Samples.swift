// Copyright 2024–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import Observation

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

public struct CompatCallbacks: @unchecked Sendable {
    // TODO: https://github.com/skiptools/skip/issues/534
    //public typealias AsyncCallback = () async -> ()
    public typealias AsyncCallback = () -> ()
    public typealias Callback = () -> ()
    public typealias URLCallback = (URL) -> ()

    // `- error: invalid conversion from 'async' function of type '() async -> ()' to synchronous function type '() throws -> ()'
    public let didLogin: AsyncCallback
    public let didCancel: AsyncCallback
    public let didSelectEmail: Callback
    public let didSelectSettings: Callback
    public let onURLSelected: URLCallback

    public init(
        didLogin: @escaping AsyncCallback = {},
        didCancel: @escaping AsyncCallback = {},
        didSelectEmail: @escaping Callback = {},
        didSelectSettings: @escaping Callback = {},
        onURLSelected: @escaping URLCallback = { _ in }
    ) {
        self.didLogin = didLogin
        self.didCancel = didCancel
        self.didSelectEmail = didSelectEmail
        self.didSelectSettings = didSelectSettings
        self.onURLSelected = onURLSelected
    }
}

@Observable
@MainActor
open class CompatMainActor: Identifiable {
    public nonisolated let id: String
    public let scene: Int

    public init(scene: Int, id: String? = nil) {
        self.id = id ?? ""
        self.scene = scene
        setup()
    }

    public func setup() {
    }
}

public struct CompatMutableStruct {
    public var str: String
    public init(_ str: String) {
        self.str = str
    }

    public mutating func mutableFunc(_ str: String) {
        self.str = str
    }
}

//public enum CompatMutableEnum {
//    case a
//    case b(String)
//
//    public mutating func mutableFunc(_ update: String) {
//        self = .b(update)
//    }
//}
