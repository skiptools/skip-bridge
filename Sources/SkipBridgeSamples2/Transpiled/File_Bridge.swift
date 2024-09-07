// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if false
public class JavaFile {
    private static let javaClass = try! JClass(name: "skip.bridge.samples.JavaFile")
    private let _javaPeer: JavaObjectPointer

    public init(filePath: String) throws {
        do {
            _javaPeer = try createJavaPeer(for: Self.javaClass, signature: "(Ljava/lang/String;)V", arguments: filePath)
        } catch JNIError {
            fatalError("JavaFile.init(filePath:)")
        }
    }

    public var exists: Bool {
        return try! getJavaT(_javaPeer, propertyName: "exists", signature: "Z")
    }

    public func delete() -> Bool {
        return try! callJavaT(_javaPeer, functionName: "delete", signature: "()Z")
    }

    public func createNewFile() throws -> Bool {
        do {
            return try callJavaT(functionName: "createNewFile", signature: "()Z")
        } catch JNIError {
            fatalError("JavaFile.createNewFile()")
        }
    }

    public func toURL() throws -> SwiftURL {
        do {
            let ret: JavaObjectPointer = try callJavaT(functionName: "toURL", signature: "()Lskip/bridge/samples/SwiftURL;")
            return swiftPeer(for: ret) as! SwiftURL
        } catch JNIError {
            fatalError("JavaFile.createNewFile()")
        }
    }
}

public class DualPlatformFile {
    private static let javaClass = try! JClass(name: "skip.bridge.samples.DualPlatformFile")
    private let _javaPeer: JavaObjectPointer

    public init(filePath: String) throws {
        do {
            _javaPeer = try createJavaPeer(for: Self.javaClass, signature: "(Ljava/lang/String;)V", arguments: filePath)
        } catch JNIError {
            fatalError("JavaFile.init(filePath:)")
        }
    }

    public var exists: Bool {
        return try! getJavaT(_javaPeer, propertyName: "exists", signature: "Z")
    }

    public func delete() -> Bool {
        return try! callJavaT(_javaPeer, functionName: "delete", signature: "()Z")
    }

    public func createNewFile() throws -> Bool {
        do {
            return try callJavaT(functionName: "createNewFile", signature: "()Z")
        } catch JNIError {
            fatalError("JavaFile.createNewFile()")
        }
    }

    public func toURL() throws -> SwiftURL {
        do {
            let ret: JavaObjectPointer = try callJavaT(functionName: "toURL", signature: "()Lskip/bridge/samples/SwiftURL;")
            return swiftPeer(for: ret) as! SwiftURL
        } catch JNIError {
            fatalError("JavaFile.createNewFile()")
        }
    }
}
#endif

/*
 Transpiled Kotlin:

class JavaFile {
     private val file: java.io.File

     constructor(filePath: String) {
         this.file = java.io.File(filePath)
     }

     val exists: Bool
         get() = this.file.exists()

     fun delete(): Bool = this.file.delete()

     fun createNewFile(): Bool = this.file.createNewFile()

     fun toURL(): SwiftURL = SwiftURL(string: this.file.toURI().toURL().toExternalForm())
 }

class DualPlatformFile {
    private val file: java.io.File

    constructor(filePath: String) {
        this.file = java.io.File(filePath)
    }

    val exists: Bool
        get() = this.file.exists()

    fun delete(): Bool = this.file.delete()

    fun createNewFile(): Bool = this.file.createNewFile()

    fun toURL(): SwiftURL = SwiftURL(string: this.file.toURI().toURL().toExternalForm())

    fun toURL(): SwiftURL {
        val urlString = this.file.toURI().toURL().toExternalForm()
        return SwiftURL(urlString: urlString)
    }
}
 */
