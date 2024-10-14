// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

extension Dictionary: JObjectProtocol, JConvertible where Key: JConvertible, Value: JConvertible {
    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> Dictionary<Key, Value> {
        // let map = dict.kotlin(nocopy: true)
        let map_java = try! JavaObjectPointer.call(Java_Dictionary_kotlin_methodID, on: obj!, args: [true.toJavaParameter()])
        // let keySet = map.keySet()
        let keySet_java = try! JavaObjectPointer.call(Java_Map_keySet_methodID, on: map_java, args: [])
        let iterator_java = try! JavaObjectPointer.call(Java_Set_iterator_methodID, on: keySet_java, args: [])
        let size = try! Int32.call(Java_Set_size_methodID, on: keySet_java, args: [])
        var dict = Dictionary<Key, Value>()
        for _ in 0..<size {
            // let key = itr.next(); let value = map.get(key)
            let key_java = try! JavaObjectPointer?.call(Java_Iterator_next_methodID, on: iterator_java, args: [])
            let value_java = try! JavaObjectPointer?.call(Java_Map_get_methodID, on: map_java, args: [key_java.toJavaParameter()])
            let key = Key.fromJavaObject(key_java)
            let value = Value.fromJavaObject(value_java)
            if let key_java {
                jni.deleteLocalRef(key_java)
            }
            if let value_java {
                jni.deleteLocalRef(value_java)
            }
            dict[key] = value
        }
        return dict
    }

    public func toJavaObject() -> JavaObjectPointer? {
        // let map = LinkedHashMap(count)
        let map_java = try! Java_LinkedHashMap.create(ctor: Java_LinkedHashMap_constructor_methodID, args: [Int32(self.count).toJavaParameter()])
        for (key, value) in self {
            // map.put(key, value)
            let key_java = key.toJavaObject()
            let value_java = value.toJavaObject()
            let _ = try! JavaObjectPointer?.call(Java_LinkedHashMap_put_methodID, on: map_java, args: [key_java.toJavaParameter(), value_java.toJavaParameter()])
            if let key_java {
                jni.deleteLocalRef(key_java)
            }
            if let value_java {
                jni.deleteLocalRef(value_java)
            }
        }
        // return Dictionary(map, nocopy: true, shared: false)
        let dict_java = try! Java_Dictionary.create(ctor: Java_Dictionary_constructor_methodID, args: [map_java.toJavaParameter(), true.toJavaParameter(), false.toJavaParameter()])
        return dict_java
    }
}
private let Java_Dictionary = try! JClass(name: "skip/lib/Dictionary")
private let Java_Dictionary_constructor_methodID = Java_Dictionary.getMethodID(name: "<init>", sig: "(Ljava/util/Map;ZZ)V")!
private let Java_Dictionary_kotlin_methodID = Java_Dictionary.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/Map;")!
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

#endif
