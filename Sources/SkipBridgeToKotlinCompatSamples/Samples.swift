// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

public class Compat {
    public let id: UUID
    public var urls: [URL] = []

    public init(id: UUID) {
        self.id = id
    }
}