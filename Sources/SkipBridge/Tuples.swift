// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// Tuple conversions.
public final class SwiftTuple {
    public static func javaObject<T0, T1>(for tuple: (T0, T1)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let tuple else {
            return nil
        }
        let t0_java = (tuple.0 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t1_java = (tuple.1 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        if options.contains(.kotlincompat) {
            return try! Java_Pair.create(ctor: Java_Pair_constructor_methodID, options: options, args: [t0_java, t1_java])
        } else {
            return try! Java_Tuple2.create(ctor: Java_Tuple2_constructor_methodID, options: options, args: [t0_java, t1_java])
        }
    }

    public static func tuple<T0, T1>(forJavaObject tuple: JavaObjectPointer?, options: JConvertibleOptions) -> (T0, T1)? {
        guard let tuple else {
            return nil
        }
        let t0MethodID: JavaMethodID
        let t1MethodID: JavaMethodID
        if options.contains(.kotlincompat) {
            t0MethodID = Java_Pair_first_methodID
            t1MethodID = Java_Pair_second_methodID
        } else {
            t0MethodID = Java_Tuple2_e0_methodID
            t1MethodID = Java_Tuple2_e1_methodID
        }
        let t0_java = try! JavaObjectPointer?.call(t0MethodID, on: tuple, options: options, args: [])
        let t0_swift: T0 = fromJavaObject(t0_java, options: options)
        let t1_java = try! JavaObjectPointer?.call(t1MethodID, on: tuple, options: options, args: [])
        let t1_swift: T1 = fromJavaObject(t1_java, options: options)
        return (t0_swift, t1_swift)
    }

    public static func javaObject<T0, T1, T2>(for tuple: (T0, T1, T2)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let tuple else {
            return nil
        }
        let t0_java = (tuple.0 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t1_java = (tuple.1 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t2_java = (tuple.2 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        if options.contains(.kotlincompat) {
            return try! Java_Triple.create(ctor: Java_Triple_constructor_methodID, options: options, args: [t0_java, t1_java, t2_java])
        } else {
            return try! Java_Tuple3.create(ctor: Java_Tuple3_constructor_methodID, options: options, args: [t0_java, t1_java, t2_java])
        }
    }

    public static func tuple<T0, T1, T2>(forJavaObject tuple: JavaObjectPointer?, options: JConvertibleOptions) -> (T0, T1, T2)? {
        guard let tuple else {
            return nil
        }
        let t0MethodID: JavaMethodID
        let t1MethodID: JavaMethodID
        let t2MethodID: JavaMethodID
        if options.contains(.kotlincompat) {
            t0MethodID = Java_Triple_first_methodID
            t1MethodID = Java_Triple_second_methodID
            t2MethodID = Java_Triple_third_methodID
        } else {
            t0MethodID = Java_Tuple3_e0_methodID
            t1MethodID = Java_Tuple3_e1_methodID
            t2MethodID = Java_Tuple3_e2_methodID
        }
        let t0_java = try! JavaObjectPointer?.call(t0MethodID, on: tuple, options: options, args: [])
        let t0_swift: T0 = fromJavaObject(t0_java, options: options)
        let t1_java = try! JavaObjectPointer?.call(t1MethodID, on: tuple, options: options, args: [])
        let t1_swift: T1 = fromJavaObject(t1_java, options: options)
        let t2_java = try! JavaObjectPointer?.call(t2MethodID, on: tuple, options: options, args: [])
        let t2_swift: T2 = fromJavaObject(t2_java, options: options)
        return (t0_swift, t1_swift, t2_swift)
    }

    public static func javaObject<T0, T1, T2, T3>(for tuple: (T0, T1, T2, T3)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let tuple else {
            return nil
        }
        let t0_java = (tuple.0 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t1_java = (tuple.1 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t2_java = (tuple.2 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t3_java = (tuple.3 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        return try! Java_Tuple4.create(ctor: Java_Tuple4_constructor_methodID, options: options, args: [t0_java, t1_java, t2_java, t3_java])
    }

    public static func tuple<T0, T1, T2, T3>(forJavaObject tuple: JavaObjectPointer?, options: JConvertibleOptions) -> (T0, T1, T2, T3)? {
        guard let tuple else {
            return nil
        }
        let t0_java = try! JavaObjectPointer?.call(Java_Tuple4_e0_methodID, on: tuple, options: options, args: [])
        let t0_swift: T0 = fromJavaObject(t0_java, options: options)
        let t1_java = try! JavaObjectPointer?.call(Java_Tuple4_e1_methodID, on: tuple, options: options, args: [])
        let t1_swift: T1 = fromJavaObject(t1_java, options: options)
        let t2_java = try! JavaObjectPointer?.call(Java_Tuple4_e2_methodID, on: tuple, options: options, args: [])
        let t2_swift: T2 = fromJavaObject(t2_java, options: options)
        let t3_java = try! JavaObjectPointer?.call(Java_Tuple4_e3_methodID, on: tuple, options: options, args: [])
        let t3_swift: T3 = fromJavaObject(t3_java, options: options)
        return (t0_swift, t1_swift, t2_swift, t3_swift)
    }

    public static func javaObject<T0, T1, T2, T3, T4>(for tuple: (T0, T1, T2, T3, T4)?, options: JConvertibleOptions) -> JavaObjectPointer? {
        guard let tuple else {
            return nil
        }
        let t0_java = (tuple.0 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t1_java = (tuple.1 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t2_java = (tuple.2 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t3_java = (tuple.3 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        let t4_java = (tuple.4 as! JConvertible).toJavaObject(options: options).toJavaParameter(options: options)
        return try! Java_Tuple4.create(ctor: Java_Tuple5_constructor_methodID, options: options, args: [t0_java, t1_java, t2_java, t3_java, t4_java])
    }

    public static func tuple<T0, T1, T2, T3, T4>(forJavaObject tuple: JavaObjectPointer?, options: JConvertibleOptions) -> (T0, T1, T2, T3, T4)? {
        guard let tuple else {
            return nil
        }
        let t0_java = try! JavaObjectPointer?.call(Java_Tuple5_e0_methodID, on: tuple, options: options, args: [])
        let t0_swift: T0 = fromJavaObject(t0_java, options: options)
        let t1_java = try! JavaObjectPointer?.call(Java_Tuple5_e1_methodID, on: tuple, options: options, args: [])
        let t1_swift: T1 = fromJavaObject(t1_java, options: options)
        let t2_java = try! JavaObjectPointer?.call(Java_Tuple5_e2_methodID, on: tuple, options: options, args: [])
        let t2_swift: T2 = fromJavaObject(t2_java, options: options)
        let t3_java = try! JavaObjectPointer?.call(Java_Tuple5_e3_methodID, on: tuple, options: options, args: [])
        let t3_swift: T3 = fromJavaObject(t3_java, options: options)
        let t4_java = try! JavaObjectPointer?.call(Java_Tuple5_e4_methodID, on: tuple, options: options, args: [])
        let t4_swift: T4 = fromJavaObject(t4_java, options: options)
        return (t0_swift, t1_swift, t2_swift, t3_swift, t4_swift)
    }

    private static func fromJavaObject<T>(_ ptr: JavaObjectPointer?, options: JConvertibleOptions) -> T {
        if let convertible = T.self as? JConvertible.Type, !(T.self is AnyObject.Type) {
            return convertible.fromJavaObject(ptr, options: options) as! T
        } else {
            return AnyBridging.fromJavaObject(ptr, options: options) as! T
        }
    }
}

private let Java_Tuple2 = try! JClass(name: "skip/lib/Tuple2")
private let Java_Tuple2_constructor_methodID = Java_Tuple2.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;Ljava/lang/Object;)V")!
private let Java_Tuple2_e0_methodID = Java_Tuple2.getMethodID(name: "get_e0", sig: "()Ljava/lang/Object;")!
private let Java_Tuple2_e1_methodID = Java_Tuple2.getMethodID(name: "get_e1", sig: "()Ljava/lang/Object;")!

private let Java_Pair = try! JClass(name: "kotlin/Pair")
private let Java_Pair_constructor_methodID = Java_Pair.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;Ljava/lang/Object;)V")!
private let Java_Pair_first_methodID = Java_Pair.getMethodID(name: "getFirst", sig: "()Ljava/lang/Object;")!
private let Java_Pair_second_methodID = Java_Pair.getMethodID(name: "getSecond", sig: "()Ljava/lang/Object;")!

private let Java_Tuple3 = try! JClass(name: "skip/lib/Tuple3")
private let Java_Tuple3_constructor_methodID = Java_Tuple3.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)V")!
private let Java_Tuple3_e0_methodID = Java_Tuple3.getMethodID(name: "get_e0", sig: "()Ljava/lang/Object;")!
private let Java_Tuple3_e1_methodID = Java_Tuple3.getMethodID(name: "get_e1", sig: "()Ljava/lang/Object;")!
private let Java_Tuple3_e2_methodID = Java_Tuple3.getMethodID(name: "get_e2", sig: "()Ljava/lang/Object;")!

private let Java_Triple = try! JClass(name: "kotlin/Triple")
private let Java_Triple_constructor_methodID = Java_Triple.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)V")!
private let Java_Triple_first_methodID = Java_Triple.getMethodID(name: "getFirst", sig: "()Ljava/lang/Object;")!
private let Java_Triple_second_methodID = Java_Triple.getMethodID(name: "getSecond", sig: "()Ljava/lang/Object;")!
private let Java_Triple_third_methodID = Java_Triple.getMethodID(name: "getThird", sig: "()Ljava/lang/Object;")!

private let Java_Tuple4 = try! JClass(name: "skip/lib/Tuple4")
private let Java_Tuple4_constructor_methodID = Java_Tuple4.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)V")!
private let Java_Tuple4_e0_methodID = Java_Tuple4.getMethodID(name: "get_e0", sig: "()Ljava/lang/Object;")!
private let Java_Tuple4_e1_methodID = Java_Tuple4.getMethodID(name: "get_e1", sig: "()Ljava/lang/Object;")!
private let Java_Tuple4_e2_methodID = Java_Tuple4.getMethodID(name: "get_e2", sig: "()Ljava/lang/Object;")!
private let Java_Tuple4_e3_methodID = Java_Tuple4.getMethodID(name: "get_e3", sig: "()Ljava/lang/Object;")!

private let Java_Tuple5 = try! JClass(name: "skip/lib/Tuple5")
private let Java_Tuple5_constructor_methodID = Java_Tuple5.getMethodID(name: "<init>", sig: "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)V")!
private let Java_Tuple5_e0_methodID = Java_Tuple5.getMethodID(name: "get_e0", sig: "()Ljava/lang/Object;")!
private let Java_Tuple5_e1_methodID = Java_Tuple5.getMethodID(name: "get_e1", sig: "()Ljava/lang/Object;")!
private let Java_Tuple5_e2_methodID = Java_Tuple5.getMethodID(name: "get_e2", sig: "()Ljava/lang/Object;")!
private let Java_Tuple5_e3_methodID = Java_Tuple5.getMethodID(name: "get_e3", sig: "()Ljava/lang/Object;")!
private let Java_Tuple5_e4_methodID = Java_Tuple5.getMethodID(name: "get_e4", sig: "()Ljava/lang/Object;")!
