// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipBridge

/// An example of a bridge that manages a `java.io.File` on the Java side and bridges functions to Swift.
public class JavaFileBridge : SkipBridge {
    #if SKIP
    private var file: java.io.File!
    #endif

    // SKIP DECLARE: constructor(filePath: String): this()
    public convenience init(filePath: String) throws {
        // SKIP REPLACE: // this gets turned into a this() call, which breaks the constructor overload
        try self.init()
        try setFilePath(filePath)
    }

    public func setFilePath(_ filePath: String) throws {
        try invokeJavaVoid(filePath) {
            #if SKIP
            self.file = java.io.File(filePath)
            #endif
        }
    }

    public func exists() throws -> Bool {
        try invokeJava() {
            #if SKIP
            self.file.exists()
            #endif
        }
    }

    public func delete() throws -> Bool {
        try invokeJava() {
            #if SKIP
            self.file.delete()
            #endif
        }
    }

    public func createNewFile() throws -> Bool {
        try invokeJava() {
            #if SKIP
            self.file.createNewFile()
            #endif
        }
    }

    public func toSwiftURLBridge() throws -> SwiftURLBridge {
        try invokeJava() {
            #if SKIP
            SwiftURLBridge(urlString: self.file.toURI().toURL().toExternalForm())
            #endif
        }
    }

    public static func separatorString() throws -> String {
        try invokeJavaStatic() {
            #if SKIP
            java.io.File.separator
            #endif
        }
    }

    #if SKIP
    public typealias Char = kotlin.Char
    #else
    public typealias Char = UInt16
    #endif

    public static func separatorChar() throws -> Char {
        try invokeJavaStatic() {
            #if SKIP
            java.io.File.separatorChar
            #endif
        }
    }
}
