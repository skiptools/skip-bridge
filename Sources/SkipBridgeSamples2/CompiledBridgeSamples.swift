// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Global stored let
// =================

//- SKIP @bridge
public let globalLet2 = 1
/*
 K:
val globalLet: Int
    get() = _bridge_globalLet() // For primitive types, we could also just re-declare on the swift side

extern fun _bridge_globalLet(): Int

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1globalLet")
 func Java_skip_bridge_samples_CompiledBridgeSamples__bridge_globalLet(_ env: JNIEnvPointer, _ target: JavaObjectPointer) -> Int {
    return globalLet
 }
 */


// Global stored var
// =================

//- SKIP @bridge
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
 func Java_skip_bridge_samples_CompiledBridgeSamples__bridge_globalVar(_ env: JNIEnvPointer, _ target: JavaObjectPointer) -> Int {
    return globalVar
 }
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples__1bridge_1set_1globalVar")
 func Java_skip_bridge_samples_CompiledBridgeSamples__bridge_set_globalVar(_ env: JNIEnvPointer, _ target: JavaObjectPointer, _ value: Int) {
    globalVar = value
 }
 */

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

// Global function
// =================

//- SKIP @bridge
public func globalFunc2() -> Int {
    return 1
}
/*
 K:
extern fun globalFunc(): Int

 S:
 @_cdecl("Java_skip_bridge_samples_CompiledBridgeSamples_globalFunc")
 func Java_skip_bridge_samples_CompiledBridgeSamples_globalFunc(_ env: JNIEnvPointer, _ target: JavaObjectPointer) -> Int {
    return globalFunc()
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
