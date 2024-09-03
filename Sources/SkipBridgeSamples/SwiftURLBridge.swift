// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipBridge

/// An example of a bridge that manages a `Foundation.URL` on the Swift side and bridges functions to Java.
public class SwiftURLBridge : SkipBridge {
    #if !SKIP
    internal var url: Foundation.URL!
    #endif

    // SKIP DECLARE: constructor(urlString: String): this()
    public convenience init(urlString: String) throws {
        // SKIP REPLACE: // this gets turned into a this() call, which breaks the constructor overload
        try self.init()
        try setURLString(urlString)
    }

    internal func setURLString(_ urlString: String) throws {
        // SKIP REPLACE: return invokeSwift_setURLString(_swiftPeer, urlString)
        invokeSwiftVoid(urlString) {
            #if !SKIP
            self.url = Foundation.URL(string: urlString)
            #endif
        }
    }

    public func isFileURL() -> Bool {
        // SKIP REPLACE: return invokeSwift_isFileURL(_swiftPeer)
        invokeSwift() {
            #if !SKIP
            self.url.isFileURL
            #endif
        }
    }

    public func toJavaFileBridge() throws -> JavaFileBridge {
        // SKIP REPLACE: return invokeSwift_toJavaFileBridge(_swiftPeer)
        try invokeSwift() {
            #if !SKIP
            try JavaFileBridge(filePath: url.path)
            #endif
        }
    }

    public static func host(forURL: String) -> String? {
        // SKIP REPLACE: return invokeSwift_host(forURL)
        invokeSwift() {
            #if !SKIP
            URL(string: forURL)?.host()
            #endif
        }
    }

    /// Example of a static function; note that `_swiftPeer` is not passed to the extern function and we don't use `withSwiftBridge`
    public static func fromJavaFileBridge(_ fileBridge: JavaFileBridge) throws -> SwiftURLBridge {
        // SKIP REPLACE: return { checkSwiftError { invokeSwift_fromJavaFileBridge(fileBridge) } }()
        try invokeSwift(fileBridge) {
            #if !SKIP
            try fileBridge.toSwiftURLBridge()
            #endif
        }
    }

    public func readContents() async throws -> String? {
        #if SKIP
        nil // TODO
//        try await withCheckedThrowingContinuation { c in
//            invokeSwift_readContents(_swiftPeer, JavaCallback(callback: { value in
//                c.resume(returning: value as! String)
//            }))
//        }
        #else
        try await invokeSwift() {
            #if !SKIP
            String(data: try await URLSession.shared.data(from: self.url).0, encoding: .utf8)
            #endif
        }
        #endif
    }
}
