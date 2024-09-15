// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org



// enum parameter/return types
// enum w/ associated parameter/return types
// generic parameter/return types

// class
// struct
// mutable struct
// enum
// enum w/ associated
// protocol
// generic type


// Global stored let
// =================

// SKIP @bridge
public let globalLet = 1
/*
 K:
val globalLet = 1

 S:
public var globalLet: Int {
    // Access globalLet via JNI. For primitive types, we could also just re-declare on the native side
}
 */


// Global stored var
// =================

// SKIP @bridge
public var globalVar = 1
/*
 K:
var globalVar = 1

 S:
public var globalVar: Int {
    get {
        // Access globalVar via JNI
    }
    set {
        // Set globalVar via JNI
    }
}
 */

// Global computed var
// =================

// SKIP @bridge
public var globalComputed: Int {
    get {
        return 1
    }
}
/*
 K:
val globalComputed: Int
    get() = 1

 S:
public var globalComputed: Int {
    // Access globalComputed via JNI
}
 */

// Global function
// =================

// SKIP @bridge
public func globalFunc() -> Int {
    return 1
}
/*
 K:
fun globalFunc(): Int {
    return 1
}

 S:
public func globalFunc() -> Int {
    // Call globalFunc via JNI
}
 */

// Transpiled class parameter/return type
// =================

// SKIP @bridge
public func transpiledClassesFunc(p: TranspiledClass) -> TranspiledClass {
    return p
}
/*
 K:
fun transpiledClassesFunc(p: TranspiledClass): TranspiledClass {
    return p
}

 S:
public func transpiledClassesFunc(p: TranspiledClass) -> TranspiledClass {
    let p_javaPeer = p._javaPeer // Get Java ptr from native wrapper
    let ret_javaPeer: JavaObject = // Call transpiledClassesFunc(p: p_javaPeer) via JNI
    return TranspiledClass(_javaPeer: ret_javaPeer) // Wrap Java ptr in native wrapper
}
 */

// Transpiled struct parameter/return type
// =================

// ERROR: Cannot properly support MUTABLE transpiled structs. If we wrap it in a native wrapper,
// copies of that wrapper will still point to the same _javaPeer. I don't believe there is any
// way to copy the JVM instance whenever the native struct is copied.

// SKIP @bridge
public func transpiledStructsFunc(p: TranspiledStruct) -> TranspiledStruct {
    return p
}
/*
 K:
fun transpiledStructsFunc(p: TranspiledStruct): TranspiledStruct {
    return p.sref()
}

 S:
public func transpiledStructsFunc(p: TranspiledStruct) -> TranspiledStruct {
    let p_javaPeer = p._javaPeer // Get Java ptr from native wrapper
    let ret_javaPeer: JavaObject = // Call transpiledStructsFunc(p: p_javaPeer) via JNI. Will sref() return value
    return TranspiledStruct(_javaPeer: ret_javaPeer) // Wrap Java ptr in native wrapper
}
 */

// Compiled class parameter/return type
// =================

// SKIP @bridge
public func compiledClassesFunc(p: CompiledClass) -> CompiledClass {
    return p
}
/*
 K:
fun compiledClassesFunc(p: CompiledClass): CompiledClass {
    return p
}

 S:
public func compiledClassesFunc(p: CompiledClass) -> CompiledClass {
    let p_swiftPeer = registerSwift(object: p) // Get handle for native object
    let p_jvm = // Use JNI to construct CompiledClass's JVM wrapper with p_swiftPeer
    let ret_jvm: JavaObject = // Call compiledClassesFunc(p: p_jvm) via JNI
    // Note: Do we need to somehow make sure ret_jvm isn't GC'd before we get its swiftPeer
    let ret_swiftPeer = // Use JNI to get _swiftPeer from ret_jvm
    guard let ret = registeredSwiftObject(forPeer: ret_swiftPeer) else { // Lookup native object for handle
        throw JNIError(...)
    }
    return ret
}
 */

// Compiled struct parameter/return type
// =================

// WARNING: For MUTABLE compiled structs, this only works if we copy the struct and give a new
// _swiftPeer to every sref() copy of the JVM wrapper. And of course value semantics break down
// if we use the object with non-Swift-transpiled code that does not make sref() copies. But that
// is also the case with passing our transpiled structs to Java/Kotlin code today.

// SKIP @bridge
public func compiledStructsFunc(p: CompiledStruct) -> CompiledStruct {
    return p
}
/*
 K:
fun compiledStructsFunc(p: CompiledStruct): CompiledStruct {
    return p.sref()
}

 S:
public func compiledStructsFunc(p: CompiledStruct) -> CompiledStruct {
    let p_swiftPeer = registerSwift(object: p) // Get handle for native object
    let p_jvm = // Use JNI to construct CompiledClass's JVM wrapper with p_swiftPeer
    let ret_jvm: JavaObject = // Call compiledStructsFunc(p: p_jvm) via JNI
    // Note: Do we need to somehow make sure ret_jvm isn't GC'd before we get its swiftPeere
    let ret_swiftPeer = // Use JNI to get _swiftPeer from ret_jvm
    guard let ret = registeredSwiftObject(forPeer: ret_swiftPeer) else { // Lookup native object for handle
        throw JNIError(...)
    }
    return ret
}
 */

// Protocol parameter/return type
// =================

// SKIP @bridge
public func protocolsFunc(p: BridgedProtocol) -> BridgedProtocol {
    return p
}
/*
 K:
fun protocolsFunc(p: BridgedProtocol): BridgedProtocol {
    return p.sref()
}

 S:
public func protocolsFunc(p: BridgedProtocol) -> BridgedProtocol {
    let ret_jvm: JavaObject
    if p is _TranspiledType {
        let p_javaPeer = p._javaPeer // Get Java ptr from native wrapper
        ret_jvm = // Call protocolsFunc(p: p_javaPeer) via JNI.
    } else {
        let p_swiftPeer = registerSwift(object: p) // Get handle for native object
        let p_jvm = // Use JNI to construct type(of: p)'s JVM wrapper with p_swiftPeer
        ret_jvm = // Call protocolsFunc(p: p_jvm) via JNI
    }
    let ret_jvmType = // Use JNI to get class of ret_jvm
    switch ret_jvmType {
        // Switch on all of our known implementors of protocol and wrap them
        // in native wrapper
        default:
            // Wrap in general protocl wrapper that we generate that implements protocol and
            // passes through protocol API via JNI
    }
 }
 */

// Array parameter/return type
// =================

// SKIP @bridge
public func arraysFunc(p: [TranspiledClass]) -> [Int] {
    return p.map(\.i)
}
/*
 K:
fun public func arraysFunc(p: Array<TranspiledClass>): Array<Int> {
    return p.map { it.i }
}

 S:
public func arraysFunc(p: [TranspiledClass]) -> [Int] {
    let p_jvm = jvmArray(for: p) { $0._javaPeer } // Creates a skip.lib.Array
    let ret_jvm = // Use JNI to call arraysFunc(p: p_jvm)
    return swiftArray(for: ret_jvm) { $0 } // Creates a Swift.Array
}
 */

// Tuple parameter/return type
// =================

// SKIP @bridge
public func tuplesFunc(p: (Int, TranspiledClass)) -> (Int, TranspiledClass) {
    return p
}
/*
 K:
fun public func tuplesFunc(p: Tuple2<Int, TranspiledClass>): Tuple2<Int, TranspiledClass> {
    return p
}

 S:
public func tuplesFunc(p: (Int, TranspiledClass)) -> (Int, TranspiledClass) {
    let p_jvm = jvmTuple(for: (p.0, p.1._javaPeer)) // Creates skip.lib.Tuple2
    let ret_jvm = // Use JNI to call tuplesFunc(p: p_jvm)
    let ret_0 = // Use JNI to get ret_jvm.element0
    let ret_1_javaPeer = // Use JNI to get ret_jvm.element1
    return (ret_0, TranspiledClass(_javaPeer: ret_1_javaPeer))
}
 */

// Closure parameter/return type
// =================

// SKIP @bridge
public func closuresFunc(p: @escaping (Int, TranspiledClass) -> TranspiledClass) -> (Int, TranspiledClass) -> TranspiledClass {
    return p
}
/*
 K:
fun closuresFunc(p: (Int, TranspiledClass) -> TranspiledClass): (Int, TranspiledClass) -> TranspiledClass {
    return p
}

 S:
public func closuresFunc(p: (Int, TranspiledClass) -> TranspiledClass) -> (Int, TranspiledClass) -> TranspiledClass {
    // TODO: I don't understand how to use JavaCallback
}
 */

// Throwing function
// =================

// SKIP @bridge
public func throwingFunc() throws -> Int {
    return 1
}
/*
 K:
fun throwingFunc(): Int {
    return 1
}

 S:
public func throwingFunc() throws -> Int {
    do {
        // Call globalFunc via JNI
    } catch JNIError {
        fatalError("throwingFunc")
    }
    // Assumes that our JNI calling funcs will throw other errors as some other error type
}
 */

// Suspend function
// =================

// SKIP @bridge
public func suspendFunc() async -> Int {
    return 1
}
/*
 K:
suspend fun suspendFunc(): Int {
    return 1
}

fun _bridge_suspendFunc(_isMain: Bool, completion: (Result<Int, String>) -> Void) {
    GlobalScope.launch(if (_isMain) Dispatchers.Main else Dispatchers.Default) {
        try {
            ret = suspendFunc()
            completion(Result.success(ret))
        } catch (t: Throwable) {
            completion(Result.error(t.toString()))
        }
    }
}

 S:
 public func suspendFunc() async -> Int {
    await withCheckedContinuation { continuation in
        let isMain = ...
        let completion: (Result<Int, String) -> Void = { result in
            // ...
            continuation.resume(returning: ...)
        }
        // Call _bridge_suspendFunc(isMain, completion) via JNI.
        // Reduces to Closure case.
    }
 }
 */

// SKIP @bridge(.all)
public class TranspiledClass {
    var i = 1
}

// SKIP @bridge(.all)
public struct TranspiledStruct {

}

// SKIP @bridge(.all)
public class CompiledClass {

}

// SKIP @bridge(.all)
public class CompiledStruct {

}

// SKIP @bridge(.all)
public protocol BridgedProtocol {
    func f() -> Int
}
