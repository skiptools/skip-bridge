// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

#if SKIP
/// An example of a bridge that manages a `java.io.File`.
///
/// This type would only be available from compiled Swift modules under `#if os(Android)`.
// SKIP @bridge(.all)
public class JavaFile {
    private let file: java.io.File

    public init(filePath: String) throws {
        self.file = try java.io.File(filePath)
    }

    public var exists: Bool {
        self.file.exists()
    }

    public func delete() -> Bool {
        self.file.delete()
    }

    public func createNewFile() throws -> Bool {
        try self.file.createNewFile()
    }

    public func toURL() throws -> SwiftURL {
        SwiftURL(string: self.file.toURI().toURL().toExternalForm())
    }
}
#endif

/// An example of a bridge that provides an abstraction over both Swift and Java files.
///
/// This type would be available from all compiled Swift modules.
// SKIP @bridge(.all)
public class DualPlatformFile {
    #if SKIP
    private let file: java.io.File
    #else
    private let filePath: String
    #endif

    public init(filePath: String) throws {
        #if SKIP
        self.file = try java.io.File(filePath)
        #else
        self.filePath = filePath
        #endif
    }

    public var exists: Bool {
        #if SKIP
        self.file.exists()
        #else
        FileManager.default.fileExists(atPath: filePath)
        #endif
    }

    public func delete() -> Bool {
        #if SKIP
        self.file.delete()
        #else
        guard exists else {
            return false
        }
        do {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        } catch {
            return false
        }
        #endif
    }

    public func createNewFile() throws -> Bool {
        #if SKIP
        try self.file.createNewFile()
        #else
        FileManager.default.createFile(atPath: filePath, contents: nil)
        #endif
    }

    public func toURL() throws -> SwiftURL {
        #if SKIP
        let urlString = self.file.toURI().toURL().toExternalForm()
        #else
        let urlString = "file://" + filePath
        #endif
        return try SwiftURL(urlString: urlString)
    }
}
