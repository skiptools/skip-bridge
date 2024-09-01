//// Copyright 2024 Skip
////
//// This is free software: you can redistribute and/or modify it
//// under the terms of the GNU Lesser General Public License 3.0
//// as published by the Free Software Foundation https://fsf.org
//#if !SKIP
//import SkipJNI
//
//// skipstone-generated Swift
//
//extension JavaCallback : SkipReferenceBridgable {
//    public static var javaClass: JClass { try! JClass(name: "skip.bridge.JavaCallback") }
//
//    public convenience init() throws {
//        #if !SKIP
//        self.init(javaPeer: Self.javaClass.ptr) // temporary sentinel
//        self._javaPeer = try createJavaPeer()
//        #else
//        loadPeerLibrary("SkipBridgeSamples")
//        super.init(swiftPeer: createJavaCallback())
//        #endif
//    }
//
//    public func toJavaObject() -> JavaObjectPointer? {
//        try? javaPeer
//    }
//
//    /// Call from Swift into Java using JNI
//    public func invokeJavaVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws {
//        fatalError("SwiftURLBridge does not have any bridged Java functions")
//    }
//
//    /// Call from Swift into Java using JNI
//    public func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
//        fatalError("SwiftURLBridge does not have any bridged Java functions")
//    }
//}
//#endif
//
//// MARK: skipstone-generated JNI bridging
//
//#if SKIP
//public extension JavaCallback {
//    /* SKIP EXTERN */ func createJavaCallback() -> Int64 { }
//}
//#else
//@_cdecl("Java_skip_bridge_JavaCallback_createJavaCallback")
//internal func Java_skip_bridge_JavaCallback_createJavaCallback(_ env: JNIEnvPointer, _ obj: JavaObjectPointer) -> Int64 {
//    registerSwiftBridge(JavaCallback(javaPeer: obj), retain: true)
//}
//#endif
//
