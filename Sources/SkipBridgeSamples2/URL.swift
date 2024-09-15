// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

// SKIP @bridge(.all)
public struct URLError : Error {
}

/// An example of a bridge that manages a `Foundation.URL`.
// SKIP @bridge(.all)
public class SwiftURL {
    private let url: URL

    public init(urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw URLError()
        }
        self.url = url
    }

    public func isFileURL() -> Bool {
        self.url.isFileURL
    }

    #if os(Android)
    public func toJavaFile() throws -> JavaFile {
        try JavaFile(filePath: url.path)
    }
    #endif

    public func toDualPlatformFile() throws -> DualPlatformFile {
        try DualPlatformFile(filePath: url.path)
    }

    public static func host(forURL: String) -> String? {
        URL(string: forURL)?.host()
    }

    #if os(Android)
    public static func fromJavaFile(_ file: JavaFile) throws -> SwiftURL {
        try file.toSwiftURL()
    }
    #endif

    public func readContents() async throws -> String? {
        String(data: try await URLSession.shared.data(from: self.url).0, encoding: .utf8)
    }
}
