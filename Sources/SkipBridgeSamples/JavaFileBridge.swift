import SkipBridge

/// An example of a bridge that manages a `java.io.File` on the Java side and bridges functions to Swift.
public class JavaFileBridge : SkipBridge {
    #if SKIP
    private var file: java.io.File!
    #endif

    internal override init() {
        super.init()
    }

    public convenience init(filePath: String) throws {
        self.init()
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
}
