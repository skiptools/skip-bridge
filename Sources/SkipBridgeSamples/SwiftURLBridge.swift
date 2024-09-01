import SkipBridge

/// An example of a bridge that manages a `Foundation.URL` on the Swift side and bridges functions to Java.
public class SwiftURLBridge : SkipBridge {
    #if !SKIP
    internal var url: Foundation.URL!
    #endif

    internal override init() {
        super.init()
    }

    public convenience init(urlString: String) throws {
        self.init()
        try setURLString(urlString)
    }

    internal func setURLString(_ urlString: String) throws {
        // SKIP REPLACE: return withSwiftBridge { invokeSwift_setURLString(_swiftPeer, urlString) }
        invokeSwiftVoid(urlString) {
            #if !SKIP
            self.url = Foundation.URL(string: urlString)
            #endif
        }
    }

    public func isFileURL() -> Bool {
        // SKIP REPLACE: return withSwiftBridge { invokeSwift_isFileURL(_swiftPeer) }
        invokeSwift() {
            #if !SKIP
            self.url.isFileURL
            #endif
        }
    }

    public func readContents() async throws -> String? {
        try await invokeSwift() {
            #if !SKIP
            String(data: try await URLSession.shared.data(from: self.url).0, encoding: .utf8)
            #endif
        }
    }

    public func toJavaFileBridge() throws -> JavaFileBridge {
        // SKIP REPLACE: return withSwiftBridge { invokeSwift_toJavaFileBridge(_swiftPeer) }
        try invokeSwift() {
            #if !SKIP
            try JavaFileBridge(filePath: url.path)
            #endif
        }
    }

    /// Example of a static function; note that `_swiftPeer` is not passed to the extern function and we don't use `withSwiftBridge`
    public static func fromJavaFileBridge(_ fileBridge: JavaFileBridge) throws -> SwiftURLBridge {
        // SKIP REPLACE: return { checkSwiftError { invokeSwift_fromJavaFileBridge(fileBridge.withSwiftBridge { fileBridge } ) } }()
        try invokeSwift(fileBridge) {
            #if !SKIP
            try fileBridge.toSwiftURLBridge()
            #endif
        }
    }

}
