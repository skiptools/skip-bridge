// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import Foundation

extension Data: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> Data {
        let kotlinByteArray = try! JavaObjectPointer.call(Java_Data_kotlin_methodID, on: obj!, args: [true.toJavaParameter()])
        let (bytes, length) = jni.getByteArrayElements(kotlinByteArray)
        defer { jni.releaseByteArrayElements(kotlinByteArray, elements: bytes, size: length) }
        guard let bytes else {
            return Data()
        }
        return Data(bytes: bytes, count: Int(length))
    }

    public func toJavaObject() -> JavaObjectPointer? {
        self.withUnsafeBytes { buffer in
            let kotlinByteArray = jni.newByteArray(buffer.baseAddress, size: Int32(count))!
            return try! Java_Data.create(ctor: Java_Data_constructor_methodID, args: [kotlinByteArray.toJavaParameter()])
        }
    }
}

private let Java_Data = try! JClass(name: "skip/foundation/Data")
private let Java_Data_constructor_methodID = Java_Data.getMethodID(name: "<init>", sig: "([B)V")!
private let Java_Data_kotlin_methodID = Java_Data.getMethodID(name: "kotlin", sig: "(Z)[B")!

extension Date: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> Date {
        let timeInterval = try! Double.call(Java_Date_timeIntervalSince1970_methodID, on: obj!, args: [])
        return Date(timeIntervalSince1970: timeInterval)
    }

    public func toJavaObject() -> JavaObjectPointer? {
        let millis = Int64(timeIntervalSince1970 * 1000.0)
        let utilDate = try! Java_UtilDate.create(ctor: Java_UtilDate_constructor_methodID, args: [millis.toJavaParameter()])
        return try! Java_Date.create(ctor: Java_Date_constructor_methodID, args: [utilDate.toJavaParameter()])
    }
}

private let Java_Date = try! JClass(name: "skip/foundation/Date")
private let Java_Date_constructor_methodID = Java_Date.getMethodID(name: "<init>", sig: "(Ljava/util/Date;)V")!
private let Java_Date_timeIntervalSince1970_methodID = Java_Date.getMethodID(name: "getTimeIntervalSince1970", sig: "()D")!
private let Java_UtilDate = try! JClass(name: "java/util/Date")
private let Java_UtilDate_constructor_methodID = Java_UtilDate.getMethodID(name: "<init>", sig: "(J)V")!

extension UUID: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> UUID {
        let uuidString = try! String.call(Java_UUID_uuidString_methodID, on: obj!, args: [])
        return UUID(uuidString: uuidString)!
    }

    public func toJavaObject() -> JavaObjectPointer? {
        let uuidString = self.uuidString
        return try! Java_UUID.create(ctor: Java_UUID_constructor_methodID, args: [uuidString.toJavaParameter()])
    }
}

private let Java_UUID = try! JClass(name: "skip/foundation/UUID")
private let Java_UUID_constructor_methodID = Java_UUID.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
private let Java_UUID_uuidString_methodID = Java_UUID.getMethodID(name: "getUuidString", sig: "()Ljava/lang/String;")!

extension URL: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> URL {
        let absoluteString = try! String.call(Java_URL_absoluteString_methodID, on: obj!, args: [])
        return URL(string: absoluteString)!
    }

    public func toJavaObject() -> JavaObjectPointer? {
        let absoluteString = self.absoluteString
        return try! Java_URL.create(ctor: Java_URL_constructor_methodID, args: [absoluteString.toJavaParameter(), (nil as JavaObjectPointer?).toJavaParameter()])
    }
}

private let Java_URL = try! JClass(name: "skip/foundation/URL")
private let Java_URL_constructor_methodID = Java_URL.getMethodID(name: "<init>", sig: "(Ljava/lang/String;Lskip/foundation/URL;)V")!
private let Java_URL_absoluteString_methodID = Java_URL.getMethodID(name: "getAbsoluteString", sig: "()Ljava/lang/String;")!

#endif
