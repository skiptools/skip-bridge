// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import SkipJNI
#endif

// NOTES: Who calls SkipBridge2.loadLibrary? It would be too expensive to auto-call on every bridging invocation

// Global stored let
// =================

#if !SKIP
//- SKIP @bridge
public let compiledGlobalLet = 1

@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_Swift_1compiledGlobalLet")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_Swift_compiledGlobalLet(_ env: JNIEnvPointer, _ target: JavaObjectPointer) -> Int32 {
    let ret_java = Int32(compiledGlobalLet)
    return ret_java
}

#else

// NOTES:
// - We use a constant rather than a computed property because there are cases where the Kotlin compiler requires a constant
// - For constant primitives we could also just mirror the value on the Kotlin side
/* SKIP INSERT:
val compiledGlobalLet = Swift_compiledGlobalLet()
external private fun Swift_compiledGlobalLet(): Int
*/
#endif

// Global stored var
// =================

#if !SKIP
//- SKIP @bridge
public var compiledGlobalVar = 1

@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_Swift_1compiledGlobalVar")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_Swift_compiledGlobalVar(_ env: JNIEnvPointer, _ target: JavaObjectPointer) -> Int32 {
    let ret_java = Int32(compiledGlobalVar)
    return ret_java
}
@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_Swift_1set_1compiledGlobalVar__I")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_Swift_set_compiledGlobalVar(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ value: Int32) {
    let value_swift = Int(value)
    compiledGlobalVar = value_swift
}

#else

/* SKIP INSERT:
var compiledGlobalVar: Int
    get() = Swift_compiledGlobalVar()
    set(newValue) {
        Swift_set_compiledGlobalVar(newValue)
    }
external private fun Swift_compiledGlobalVar(): Int
external private fun Swift_set_compiledGlobalVar(value: Int)
*/
#endif

// Global function
// =================

#if !SKIP
//- SKIP @bridge
public func compiledGlobalFunc(i: Int) -> Int {
    return i
}

//- SKIP @bridge
public func compiledGlobalVoidFunc(i: Int) {
}

@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_compiledGlobalFunc__I")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_compiledGlobalFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, i: Int32) -> Int32 {
    let i_swift = Int(i)
    let ret_swift = compiledGlobalFunc(i: i_swift)
    let ret_java = Int32(ret_swift)
    return ret_java
}

@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_compiledGlobalVoidFunc__I")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_compiledGlobalVoidFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, i: Int32) {
    let i_swift = Int(i)
    compiledGlobalVoidFunc(i: i_swift)
}

#else

/* SKIP INSERT:
external fun compiledGlobalFunc(i: Int): Int
external fun compiledGlobalVoidFunc(i: Int)
*/
#endif

// =================
// =================
// =================

// Global computed var
// =================

//- SKIP @bridge
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
 func Java_skip_bridge_samples_CompiledBridgeSamples__bridge_globalComputedVar(_ env: JNIEnvPointer, _ target: JavaObjectPointer) -> Int {
    return globalComputedVar
 }
 */

// Transpiled class parameter/return type
// =================

//- SKIP @bridge
public func transpiledClassesFunc2(p: TranspiledClass) -> TranspiledClass {
    return p
}
/*
 K:
extern fun transpiledClassesFunc(p: TranspiledClass): TranspiledClass

 S:
@_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_transpiledClassesFunc")
func Java_skip_bridge_samples_CompiledBridgeSamples_transpiledClassesFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = TranspiledClass(_javaPeer: p)
    let ret_swift = transpiledClassesFunc(p: p_swift)
    return ret_swift._javaPeer
 }
 */

// Transpiled struct parameter/return type
// =================

//- SKIP @bridge
public func transpiledStructsFunc2(p: TranspiledStruct) -> TranspiledStruct {
    return p
}
/*
 K:
extern fun transpiledStructsFunc(p: TranspiledStruct): TranspiledStruct

 S:
@_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_transpiledStructsFunc")
func Java_skip_bridge_samples_CompiledBridgeSamples_transpiledStructsFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = TranspiledStruct(_javaPeer: p)
    let ret_swift = transpiledStructsFunc(p: p_swift)
    return ret_swift._javaPeer
 }
 */

// Compiled class parameter/return type
// =================

//- SKIP @bridge
public func compiledClassesFunc2(p: CompiledClass) -> CompiledClass {
    return p
}
/*
 K:
extern fun compiledClassesFunc(p: CompiledClass): CompiledClass

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_compiledClassesFunc")
 func Java_skip_bridge_samples_CompiledBridgeSamples_bridge_compiledClassesFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = // Access p_swiftPeer via JNI
    let p_swiftObject = registeredSwiftObject(forPeer: p)
    let ret_swiftObject = compiledClassesFunc(p: p_swiftObject)
    let ret_swift = registerSwift(object: ret_swiftObject)
    let ret = // Invoke CompiledClass(_swiftPeer: ret_swift) via JNI
    return ret
  }
 */

// Compiled struct parameter/return type
// =================

//- SKIP @bridge
public func compiledStructsFunc2(p: CompiledStruct) -> CompiledStruct {
    return p
}
/*
 K:
extern fun compiledStructsFunc(p: CompiledStruct): CompiledStruct

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_compiledStructsFunc")
 func Java_skip_bridge_samples_CompiledBridgeSamples_bridge_compiledStructsFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = // Access p._swiftPeer via JNI
    let p_swiftObject = registeredSwiftObject(forPeer: p)
    let ret_swiftObject = compiledStructsFunc(p: p_swiftObject)
    let ret_swift = registerSwift(object: ret_swiftObject)
    let ret = // Invoke CompiledStruct(_swiftPeer: ret_swift) via JNI
    return ret
  }
 */

// Generic parameter/return type
// =================

//- SKIP @bridge
public func genericsFunc2<T>(p: T) -> T {
    return p
}
/*
 K:
extern fun genericsFunc(p: T): T

 S:
@_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_genericsFunc")
func Java_skip_bridge_samples_CompiledBridgeSamples_genericsFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = // Attempt to access p._swiftPeer via JNI - we need a "or nil" variant
    if let p_swift {
        // See compiled sample
    } else {
        let p_javaType = // Use JNI to get class of p
        // TODO: What to do here? Technically we know all bridged types from CodebaseInfo.
        // Maybe each module generates a function that takes an object and its Java type and
        // returns the proper swift version, or nil?
    }
    let ret_swiftObject = genericsFunc(p: p_swiftObject)
    if ret_swiftObject is _JavaType {
        return ret_swiftObject._javaPeer // Get Java ptr from swift wrapper
    } else {
        let ret_swift = registerSwift(object: ret_swiftObject) // Get handle for swift object
        // Use JNI to construct corresponding Java type from with _swiftPeer = ret_swift
    }
 }
 */

// Protocol parameter/return type
// =================

//- SKIP @bridge
public func protocolsFunc2(p: BridgedProtocol) -> BridgedProtocol {
    return p
}
/*
 K:
extern fun protocolsFunc(p: BridgedProtocol): BridgedProtocol

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_protocolsFunc")
 func Java_skip_bridge_samples_CompiledBridgeSamples_protocolsFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ p: JavaObjectPointer) -> JavaObjectPointer {
    let p_swift = // Attempt to access p._swiftPeer via JNI - we need a "or nil" variant
    if let p_swift {
        // See compiled sample
    } else {
        let p_javaType = // Use JNI to get class of p
        // TODO: What to do here? Technically we know all bridged types from CodebaseInfo.
        // Maybe each module generates a function that takes an object and its Java type and
        // returns the proper swift version, or nil?
    }
    let ret_swiftObject = protocolsFunc(p: p_swiftObject)
    // TODO: Same situation as with genericsFunc above. But now we can offer an additional fallback:
    // The returned object does NOT actually have to be a bridged type. For protocols we could generate
    // A generic implementor (in this case i.e. AnyBridgedProtocol) that wraps any Swift object that we
    // know also implements the protocol and passes through calls via @cdecl funcs for protocol members.
    // So if we can't find a concrete bridged type for the returned Swift type, we could use our generic implementor.
 }
 */

// Array parameter/return type
// =================

//- SKIP @bridge
public func arraysFunc2(p: [TranspiledClass]) -> [Int] {
    return p.map(\.i)
}
/*
 K:
fun arraysFunc(p: Array<TranspiledClass>): Array<Int> {
    let ret = // Copy to Java array and call _bridge version
    // Copy Java array ret to skip.lib.Array
}

extern fun _bridge_arraysFunc(p: Java array [TranspiledClass]): Java array [Int]

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1arraysFunc")
 func Java_skip_bridge_samples_CompiledBridgeSamples__bridge_arraysFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ p: array type) -> array type {
    // Copy p to Swift array
    // Call arraysFunc
    // Return JNI-compat array
 }
 */

//- SKIP @bridge(.all)
public class CompiledClass {
    var i = 0
}
/*
 K:
class CompiledClass {
    val _swiftPeer: ULong

    init() {
        _swiftPeer = // Invoke @cdecl factory function
    }

    init(_swiftPeer: _SwiftPeer) { // Use unique type to avoid signature conflicts with constructors
        _swiftPeer = _swiftPeer.value
    }

    fun finalize() {
        // Invoke @cdecl to release our reference to _swiftPeer
    }

    var i: Int
        get() {
            // Invoke _cdecl func pass _swiftPeer
        }
        set(newValue) {
            // Invoke _cdecl func pass _swiftPeer
        }
}

 S:
 // @cdecls for members and inits and release ref
*/

//- SKIP @bridge(.all)
public class CompiledStruct {

}
