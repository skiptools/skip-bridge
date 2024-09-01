//// Copyright 2024 Skip
////
//// This is free software: you can redistribute and/or modify it
//// under the terms of the GNU Lesser General Public License 3.0
//// as published by the Free Software Foundation https://fsf.org
//public class JavaCallback : SkipBridge {
//    #if SKIP
//    internal var callback: ((java.lang.Object) throws -> ())!
//    #endif
//
//    #if SKIP
//    public convenience init(callback: (java.lang.Object) throws -> ()) throws {
//        self.init()
//        withSwiftBridge {
//            self.callback = callback
//        }
//    }
//
//    public func invokeCallback(_ value: java.lang.Object) throws {
//        try callback(value)
//    }
//    #else
//    /// Invoke the Java callback from the Swift side
//    public func callback(_ value: SkipBridgable) throws {
//        return try callJavaV(functionName: "invokeCallback", signature: "(Ljava/lang/Object;)V", arguments: [value])
//    }
//    #endif
//}
