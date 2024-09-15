// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if false

#endif

/*
 Transpiled Kotlin:

 class URLError : Error {
    private _swiftPeer: Int64

    constructor() {
        loadPeerLibrary("SkipBridgeSamples2")
        self._swiftPeer = URL_Bridge_URLError_init()
    }

    // TODO: Finalize? When is _swiftPeer released?
 }

 class SwiftURL {
     private _swiftPeer: Int64

     constructor(urlString: String) {
        loadPeerLibrary("SkipBridgeSamples2")
        self._swiftPeer = handleSwiftError {
            URL_Bridge_SwiftURL_init(urlString)
        }
     }

     fun isFileURL(): Bool {
         URL_Bridge_SwiftURL_isFileURL(_swiftPeer)
     }

    // TODO: IN PROGRESS ------
 
     public func toJavaFile() throws -> JavaFile {
         try JavaFile(filePath: url.path)
     }

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
 */
