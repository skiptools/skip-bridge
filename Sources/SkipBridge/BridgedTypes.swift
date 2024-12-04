// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

//
// NOTE:
// The Kotlin version of custom converting types should conform to `SwiftCustomBridged`.
// If it also conforms to `KotlinConverting`, it should convert to and from its underlying
// Kotlin type when the `kotlincompat` option is given.
//

// MARK: Array

extension Array: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Array<Element> {
        // let list = arr.kotlin(nocopy: true)
        let list_java: JavaObjectPointer
        if options.contains(.kotlincompat) {
            list_java = obj!
        } else {
            list_java = try! JavaObjectPointer.call(Java_SkipArray_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        let count = try! Int32.call(Java_List_size_methodID, on: list_java, options: options, args: [])
        var arr = Array<Element>()
        for i in 0..<count {
            // arr.append(list.get(i))
            let element_java = try! JavaObjectPointer?.call(Java_List_get_methodID, on: list_java, options: options, args: [i.toJavaParameter(options: options)])
            let element = (Element.self as! JConvertible.Type).fromJavaObject(element_java, options: options)
            if let element_java {
                jni.deleteLocalRef(element_java)
            }
            arr.append(element as! Element)
        }
        return arr
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        // let list = ArrayList(count)
        let list_java = try! Java_ArrayList.create(ctor: Java_ArrayList_constructor_methodID, args: [Int32(self.count).toJavaParameter(options: options)])
        for element in self {
            // list.add(element)
            let element_java = (element as! JConvertible).toJavaObject(options: options)
            let _ = try! Bool.call(Java_ArrayList_add_methodID, on: list_java, options: options, args: [element_java.toJavaParameter(options: options)])
            if let element_java {
                jni.deleteLocalRef(element_java)
            }
        }
        if options.contains(.kotlincompat) {
            return list_java
        } else {
            // return Array(list, nocopy: true, shared: false)
            let arr_java = try! Java_SkipArray.create(ctor: Java_SkipArray_constructor_methodID, args: [list_java.toJavaParameter(options: options), true.toJavaParameter(options: options), false.toJavaParameter(options: options)])
            return arr_java
        }
    }
}

private let Java_SkipArray = try! JClass(name: "skip/lib/Array")
private let Java_SkipArray_constructor_methodID = Java_SkipArray.getMethodID(name: "<init>", sig: "(Ljava/lang/Iterable;ZZ)V")!
private let Java_SkipArray_kotlin_methodID = Java_SkipArray.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/List;")!
private let Java_ArrayList = try! JClass(name: "java/util/ArrayList")
private let Java_ArrayList_constructor_methodID = Java_ArrayList.getMethodID(name: "<init>", sig: "(I)V")!
private let Java_ArrayList_add_methodID = Java_ArrayList.getMethodID(name: "add", sig: "(Ljava/lang/Object;)Z")!
private let Java_List = try! JClass(name: "java/util/List")
private let Java_List_size_methodID = Java_List.getMethodID(name: "size", sig: "()I")!
private let Java_List_get_methodID = Java_List.getMethodID(name: "get", sig: "(I)Ljava/lang/Object;")!

// MARK: Data

extension Data: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Data {
        let kotlinByteArray: JavaObjectPointer
        if options.contains(.kotlincompat) {
            kotlinByteArray = obj!
        } else {
            kotlinByteArray = try! JavaObjectPointer.call(Java_SkipData_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        let (bytes, length) = jni.getByteArrayElements(kotlinByteArray)
        defer { jni.releaseByteArrayElements(kotlinByteArray, elements: bytes, mode: .unpin) }
        guard let bytes else {
            return Data()
        }
        return Data(bytes: bytes, count: Int(length))
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        self.withUnsafeBytes { buffer in
            let kotlinByteArray = jni.newByteArray(buffer.baseAddress, size: Int32(count))!
            if options.contains(.kotlincompat) {
                return kotlinByteArray
            } else {
                return try! Java_SkipData.create(ctor: Java_SkipData_constructor_methodID, args: [kotlinByteArray.toJavaParameter(options: options)])
            }
        }
    }
}

// MARK: Date

private let Java_SkipData = try! JClass(name: "skip/foundation/Data")
private let Java_SkipData_constructor_methodID = Java_SkipData.getMethodID(name: "<init>", sig: "([B)V")!
private let Java_SkipData_kotlin_methodID = Java_SkipData.getMethodID(name: "kotlin", sig: "(Z)[B")!

extension Date: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Date {
        let timeInterval: Double
        if options.contains(.kotlincompat) {
            let millis = try! Int64.call(Java_Date_getTime_methodID, on: obj!, options: options, args: [])
            timeInterval = Double(millis) / 1000.0
        } else {
            timeInterval = try! Double.call(Java_SkipDate_timeIntervalSince1970_methodID, on: obj!, options: options, args: [])
        }
        return Date(timeIntervalSince1970: timeInterval)
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let millis = Int64(timeIntervalSince1970 * 1000.0)
        let utilDate = try! Java_Date.create(ctor: Java_Date_constructor_methodID, args: [millis.toJavaParameter(options: options)])
        if options.contains(.kotlincompat) {
            return utilDate
        } else {
            return try! Java_SkipDate.create(ctor: Java_SkipDate_constructor_methodID, args: [utilDate.toJavaParameter(options: options)])
        }
    }
}

private let Java_SkipDate = try! JClass(name: "skip/foundation/Date")
private let Java_SkipDate_constructor_methodID = Java_SkipDate.getMethodID(name: "<init>", sig: "(Ljava/util/Date;)V")!
private let Java_SkipDate_timeIntervalSince1970_methodID = Java_SkipDate.getMethodID(name: "getTimeIntervalSince1970", sig: "()D")!
private let Java_Date = try! JClass(name: "java/util/Date")
private let Java_Date_constructor_methodID = Java_Date.getMethodID(name: "<init>", sig: "(J)V")!
private let Java_Date_getTime_methodID = Java_Date.getMethodID(name: "getTime", sig: "()J")!

// MARK: Dictionary

extension Dictionary: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Dictionary<Key, Value> {
        // let map = dict.kotlin(nocopy: true)
        let map_java: JavaObjectPointer
        if options.contains(.kotlincompat) {
            map_java = obj!
        } else {
            map_java = try! JavaObjectPointer.call(Java_SkipDictionary_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        // let keySet = map.keySet()
        let keySet_java = try! JavaObjectPointer.call(Java_Map_keySet_methodID, on: map_java, options: options, args: [])
        let iterator_java = try! JavaObjectPointer.call(Java_Set_iterator_methodID, on: keySet_java, options: options, args: [])
        let size = try! Int32.call(Java_Set_size_methodID, on: keySet_java, options: options, args: [])
        var dict = Dictionary<Key, Value>()
        for _ in 0..<size {
            // let key = itr.next(); let value = map.get(key)
            let key_java = try! JavaObjectPointer?.call(Java_Iterator_next_methodID, on: iterator_java, options: options, args: [])
            let value_java = try! JavaObjectPointer?.call(Java_Map_get_methodID, on: map_java, options: options, args: [key_java.toJavaParameter(options: options)])
            let key = (Key.self as! JConvertible.Type).fromJavaObject(key_java, options: options)
            let value = (Value.self as! JConvertible.Type).fromJavaObject(value_java, options: options)
            if let key_java {
                jni.deleteLocalRef(key_java)
            }
            if let value_java {
                jni.deleteLocalRef(value_java)
            }
            dict[key as! Key] = value as? Value
        }
        return dict
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        // let map = LinkedHashMap(count)
        let map_java = try! Java_LinkedHashMap.create(ctor: Java_LinkedHashMap_constructor_methodID, args: [Int32(self.count).toJavaParameter(options: options)])
        for (key, value) in self {
            // map.put(key, value)
            let key_java = (key as! JConvertible).toJavaObject(options: options)
            let value_java = (value as! JConvertible).toJavaObject(options: options)
            let _ = try! JavaObjectPointer?.call(Java_LinkedHashMap_put_methodID, on: map_java, options: options, args: [key_java.toJavaParameter(options: options), value_java.toJavaParameter(options: options)])
            if let key_java {
                jni.deleteLocalRef(key_java)
            }
            if let value_java {
                jni.deleteLocalRef(value_java)
            }
        }
        if options.contains(.kotlincompat) {
            return map_java
        } else {
            // return Dictionary(map, nocopy: true, shared: false)
            let dict_java = try! Java_SkipDictionary.create(ctor: Java_SkipDictionary_constructor_methodID, args: [map_java.toJavaParameter(options: options), true.toJavaParameter(options: options), false.toJavaParameter(options: options)])
            return dict_java
        }
    }
}

private let Java_SkipDictionary = try! JClass(name: "skip/lib/Dictionary")
private let Java_SkipDictionary_constructor_methodID = Java_SkipDictionary.getMethodID(name: "<init>", sig: "(Ljava/util/Map;ZZ)V")!
private let Java_SkipDictionary_kotlin_methodID = Java_SkipDictionary.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/Map;")!
private let Java_LinkedHashMap = try! JClass(name: "java/util/LinkedHashMap")
private let Java_LinkedHashMap_constructor_methodID = Java_LinkedHashMap.getMethodID(name: "<init>", sig: "(I)V")!
private let Java_LinkedHashMap_put_methodID = Java_LinkedHashMap.getMethodID(name: "put", sig: "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Map = try! JClass(name: "java/util/Map")
private let Java_Map_get_methodID = Java_Map.getMethodID(name: "get", sig: "(Ljava/lang/Object;)Ljava/lang/Object;")!
private let Java_Map_keySet_methodID = Java_Map.getMethodID(name: "keySet", sig: "()Ljava/util/Set;")!
private let Java_Set = try! JClass(name: "java/util/Set")
private let Java_Set_size_methodID = Java_Set.getMethodID(name: "size", sig: "()I")!
private let Java_Set_iterator_methodID = Java_Set.getMethodID(name: "iterator", sig: "()Ljava/util/Iterator;")!
private let Java_Iterator = try! JClass(name: "java/util/Iterator")
private let Java_Iterator_next_methodID = Java_Iterator.getMethodID(name: "next", sig: "()Ljava/lang/Object;")!

// MARK: Set

extension Set: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Set<Element> {
        // let set = set.kotlin(nocopy: true)
        let set_java: JavaObjectPointer
        if options.contains(.kotlincompat) {
            set_java = obj!
        } else {
            set_java = try! JavaObjectPointer.call(Java_SkipSet_kotlin_methodID, on: obj!, options: options, args: [true.toJavaParameter(options: options)])
        }
        let iterator_java = try! JavaObjectPointer.call(Java_Set_iterator_methodID, on: set_java, options: options, args: [])
        let size = try! Int32.call(Java_Set_size_methodID, on: set_java, options: options, args: [])
        var set = Set<Element>()
        for _ in 0..<size {
            // set.insert(itr.next())
            let element_java = try! JavaObjectPointer?.call(Java_Iterator_next_methodID, on: iterator_java, options: options, args: [])
            let element = (Element.self as! JConvertible.Type).fromJavaObject(element_java, options: options)
            if let element_java {
                jni.deleteLocalRef(element_java)
            }
            set.insert(element as! Element)
        }
        return set
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        // let set = LinkedHashSet()
        let hashset_java = try! Java_LinkedHashSet.create(ctor: Java_LinkedHashSet_constructor_methodID, args: [])
        for element in self {
            // set.add(element)
            let element_java = (element as! JConvertible).toJavaObject(options: options)
            let _ = try! Bool.call(Java_LinkedHashSet_add_methodID, on: hashset_java, options: options, args: [element_java.toJavaParameter(options: options)])
            if let element_java {
                jni.deleteLocalRef(element_java)
            }
        }
        if options.contains(.kotlincompat) {
            return hashset_java
        } else {
            // return Set(set, nocopy: true, shared: false)
            let set_java = try! Java_SkipSet.create(ctor: Java_SkipSet_constructor_methodID, args: [hashset_java.toJavaParameter(options: options), true.toJavaParameter(options: options), false.toJavaParameter(options: options)])
            return set_java
        }
    }
}

private let Java_SkipSet = try! JClass(name: "skip/lib/Set")
private let Java_SkipSet_constructor_methodID = Java_SkipSet.getMethodID(name: "<init>", sig: "(Ljava/lang/Iterable;ZZ)V")!
private let Java_SkipSet_kotlin_methodID = Java_SkipSet.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/Set;")!
private let Java_LinkedHashSet = try! JClass(name: "java/util/LinkedHashSet")
private let Java_LinkedHashSet_constructor_methodID = Java_LinkedHashSet.getMethodID(name: "<init>", sig: "()V")!
private let Java_LinkedHashSet_add_methodID = Java_LinkedHashSet.getMethodID(name: "add", sig: "(Ljava/lang/Object;)Z")!

// MARK: UUID

extension UUID: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> UUID {
        let uuidString: String
        if options.contains(.kotlincompat) {
            uuidString = try! String.call(Java_UUID_toString_methodID, on: obj!, options: options, args: [])
        } else {
            uuidString = try! String.call(Java_SkipUUID_uuidString_methodID, on: obj!, options: options, args: [])
        }
        return UUID(uuidString: uuidString)!
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let uuidString = self.uuidString
        if options.contains(.kotlincompat) {
            return try! Java_UUID.callStatic(method: Java_UUID_fromString_methodID, options: options, args: [uuidString.toJavaParameter(options: options)])
        } else {
            return try! Java_SkipUUID.create(ctor: Java_SkipUUID_constructor_methodID, args: [uuidString.toJavaParameter(options: options)])
        }
    }
}

private let Java_SkipUUID = try! JClass(name: "skip/foundation/UUID")
private let Java_SkipUUID_constructor_methodID = Java_SkipUUID.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
private let Java_SkipUUID_uuidString_methodID = Java_SkipUUID.getMethodID(name: "getUuidString", sig: "()Ljava/lang/String;")!
private let Java_UUID = try! JClass(name: "java/util/UUID")
private let Java_UUID_fromString_methodID = Java_UUID.getStaticMethodID(name: "fromString", sig: "(Ljava/lang/String;)Ljava/util/UUID;")!
private let Java_UUID_toString_methodID = Java_UUID.getMethodID(name: "toString", sig: "()Ljava/lang/String;")!

// MARK: URL

extension URL: JObjectProtocol, JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> URL {
        let absoluteString: String
        if options.contains(.kotlincompat) {
            absoluteString = try! String.call(Java_URI_toString_methodID, on: obj!, options: options, args: [])
        } else {
            absoluteString = try! String.call(Java_SkipURL_absoluteString_methodID, on: obj!, options: options, args: [])
        }
        return URL(string: absoluteString)!
    }

    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let absoluteString = self.absoluteString
        if options.contains(.kotlincompat) {
            return try! Java_URI.create(ctor: Java_URI_constructor_methodID, args: [absoluteString.toJavaParameter(options: options)])
        } else {
            return try! Java_SkipURL.create(ctor: Java_SkipURL_constructor_methodID, args: [absoluteString.toJavaParameter(options: options), (nil as JavaObjectPointer?).toJavaParameter(options: options)])
        }
    }
}

private let Java_SkipURL = try! JClass(name: "skip/foundation/URL")
private let Java_SkipURL_constructor_methodID = Java_SkipURL.getMethodID(name: "<init>", sig: "(Ljava/lang/String;Lskip/foundation/URL;)V")!
private let Java_SkipURL_absoluteString_methodID = Java_SkipURL.getMethodID(name: "getAbsoluteString", sig: "()Ljava/lang/String;")!
private let Java_URI = try! JClass(name: "java/net/URI")
private let Java_URI_constructor_methodID = Java_URI.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
private let Java_URI_toString_methodID = Java_URI.getMethodID(name: "toString", sig: "()Ljava/lang/String;")!
