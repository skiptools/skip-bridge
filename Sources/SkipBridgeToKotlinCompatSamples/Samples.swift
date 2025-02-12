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
//    public var errorvar: Error = CompatError()

    public init(id: UUID) {
        self.id = id
    }
}

public struct CompatError: Error {
}
