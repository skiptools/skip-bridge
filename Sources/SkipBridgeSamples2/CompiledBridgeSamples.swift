// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Global stored let
// =================

// SKIP @bridge
public let globalLet2 = 1
/*
 K:
val globalLet: Int
    get() = _bridge_globalLet() // For primitive types, we could also just re-declare on the native side

extern fun _bridge_globalLet(): Int

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1globalLet")
 func Java_skip_bridge_samples_CompiledBridgeSamples_bridge_globalLet(_ env: JNIEnvPointer) -> Int {
    return globalLet
 }
 */


// Global stored var
// =================

// SKIP @bridge
public var globalVar2 = 1
/*
 K:
val globalVar: Int
    get() = _bridge_globalVar()
    set(newValue) {
        _bridge_set_globalVar(newValue)
    }

extern fun _bridge_globalVar(): Int
extern fun _bridge_set_globalVar(value: Int)

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1globalVar")
 func Java_skip_bridge_samples_CompiledBridgeSamples_bridge_globalVar(_ env: JNIEnvPointer) -> Int {
    return globalVar
 }
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1set_1globalVar")
 func Java_skip_bridge_samples_CompiledBridgeSamples_bridge_set_globalVar(_ env: JNIEnvPointer, _ value: Int) {
    globalVar = value
 }
 */

// Global computed var
// =================

// SKIP @bridge
public var globalComputedVar2: Int {
    return 1
}
/*
 K:
val globalComputedVar: Int
    get() = _bridge_globalComputedVar()

extern fun _bridge_globalComputedVar(): Int

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1globalComputedVar")
 func Java_skip_bridge_samples_CompiledBridgeSamples_bridge_globalComputedVar(_ env: JNIEnvPointer) -> Int {
    return globalComputedVar
 }
 */

// Global function
// =================

// SKIP @bridge
public func globalFunc2() -> Int {
    return 1
}
/*
 K:
extern fun globalFunc(): Int

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_globalFunc")
 func Java_skip_bridge_samples_CompiledBridgeSamples_globalFunc(_ env: JNIEnvPointer) -> Int {
    return globalFunc()
 }
 */

// Transpiled class parameter/return type
// =================

// SKIP @bridge
public func transpiledClassesFunc2(p: TranspiledClass) -> TranspiledClass {
    return p
}
/*
 K:
extern fun transpiledClassesFunc(p: TranspiledClass): TranspiledClass

 S:
@_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_transpiledClassesFunc")
func Java_skip_bridge_samples_CompiledBridgeSamples_transpiledClassesFunc(_ env: JNIEnvPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = TranspiledClass(_javaPeer: p)
    let ret_swift = transpiledClassesFunc(p: p_swift)
    return ret_swift._javaPeer
 }
 */

// Transpiled struct parameter/return type
// =================

// SKIP @bridge
public func transpiledStructsFunc2(p: TranspiledStruct) -> TranspiledStruct {
    return p
}
/*
 K:
extern fun transpiledStructsFunc(p: TranspiledStruct): TranspiledStruct

 S:
@_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_transpiledStructsFunc")
func Java_skip_bridge_samples_CompiledBridgeSamples_transpiledStructsFunc(_ env: JNIEnvPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = TranspiledStruct(_javaPeer: p)
    let ret_swift = transpiledStructsFunc(p: p_swift)
    return ret_swift._javaPeer
 }
 */

// Compiled class parameter/return type
// =================

// SKIP @bridge
public func compiledClassesFunc2(p: CompiledClass) -> CompiledClass {
    return p
}
/*
 K:
fun compiledClassesFunc(p: CompiledClass): CompiledClass {
    val p_swift = p._swiftPeer
    val ret_swift = _bridge_compiledClassesFunc(p_swift)
    return CompiledClass(_swiftPeer = ret_swift)
}

extern fun _bridge_compiledClassesFunc(p: ULong) -> ULong

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1compiledClassesFunc")
 func Java_skip_bridge_samples_CompiledBridgeSamples_bridge_compiledClassesFunc(_ env: JNIEnvPointer, _ p: UInt64) -> UInt64 {
     let p_swift = registeredSwiftObject(forPeer: p)
     let ret_swift = compiledClassesFunc(p: p_swift)
     return registerSwift(object: ret_swift)
  }
 */

// SKIP @bridge(.all)
public class CompiledClass {

}

// SKIP @bridge(.all)
public class CompiledStruct {

}
