//// Copyright 2024 Skip
////
//// This is free software: you can redistribute and/or modify it
//// under the terms of the GNU Lesser General Public License 3.0
//// as published by the Free Software Foundation https://fsf.org
//
//#if !SKIP
//
//extension Array: JObjectProtocol, JConvertible where Element: JConvertible {
//    public static func fromJavaObject(_ obj: JavaObjectPointer?) -> Array<Element> {
//        // let list = arr.kotlin(nocopy: true)
//        let list_java = try! JavaObjectPointer.call(Java_Array_kotlin_methodID, on: obj!, args: [true.toJavaParameter()])
//        let count = try! Int32.call(Java_List_size_methodID, on: list_java, args: [])
//        var arr = Array<Element>()
//        for i in 0..<count {
//            // arr.append(list.get(i))
//            let element_java = try! JavaObjectPointer?.call(Java_List_get_methodID, on: list_java, args: [i.toJavaParameter()])
//            let element = Element.fromJavaObject(element_java)
//            if let element_java {
//                jni.deleteLocalRef(element_java)
//            }
//            arr.append(element)
//        }
//        return arr
//    }
//
//    public func toJavaObject() -> JavaObjectPointer? {
//        // let list = ArrayList(count)
//        let list_java = try! Java_ArrayList.create(ctor: Java_ArrayList_constructor_methodID, args: [Int32(self.count).toJavaParameter()])
//        for element in self {
//            // list.add(element)
//            let element_java = element.toJavaObject()
//            let _ = try! Bool.call(Java_ArrayList_add_methodID, on: list_java, args: [element_java.toJavaParameter()])
//            if let element_java {
//                jni.deleteLocalRef(element_java)
//            }
//        }
//
//        // return Array(list, nocopy: true, shared: false)
//        let arr_java = try! Java_Array.create(ctor: Java_Array_constructor_methodID, args: [list_java.toJavaParameter(), true.toJavaParameter(), false.toJavaParameter()])
//        return arr_java
//    }
//}
//
//private let Java_Array = try! JClass(name: "skip/lib/Array")
//private let Java_Array_constructor_methodID = Java_Array.getMethodID(name: "<init>", sig: "(Ljava/lang/Iterable;ZZ)V")!
//private let Java_Array_kotlin_methodID = Java_Array.getMethodID(name: "kotlin", sig: "(Z)Ljava/util/List;")!
//private let Java_ArrayList = try! JClass(name: "java/util/ArrayList")
//private let Java_ArrayList_constructor_methodID = Java_ArrayList.getMethodID(name: "<init>", sig: "(I)V")!
//private let Java_ArrayList_add_methodID = Java_ArrayList.getMethodID(name: "add", sig: "(Ljava/lang/Object;)Z")!
//private let Java_List = try! JClass(name: "java/util/List")
//private let Java_List_size_methodID = Java_List.getMethodID(name: "size", sig: "()I")!
//private let Java_List_get_methodID = Java_List.getMethodID(name: "get", sig: "(I)Ljava/lang/Object;")!
//
//#endif
