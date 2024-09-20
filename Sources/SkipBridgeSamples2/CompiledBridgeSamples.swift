// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridge2
#if !SKIP
import SkipJNI
#endif

// Global stored let
// =================

#if !SKIP
//- SKIP @bridge
public let compiledGlobalLet = 1

@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_Swift_1compiledGlobalLet")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_Swift_compiledGlobalLet(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer) -> Int32 {
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
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_Swift_compiledGlobalVar(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer) -> Int32 {
    let ret_java = Int32(compiledGlobalVar)
    return ret_java
}
@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_Swift_1set_1compiledGlobalVar__I")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_Swift_set_compiledGlobalVar(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ value: Int32) {
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

// NOTE: Also encode parameter types into name if overloaded
@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_compiledGlobalFunc")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_compiledGlobalFunc(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, i: Int32) -> Int32 {
    let i_swift = Int(i)
    let ret_swift = compiledGlobalFunc(i: i_swift)
    let ret_java = Int32(ret_swift)
    return ret_java
}

@_cdecl("Java_skip_bridge_samples2_CompiledBridgeSamplesKt_compiledGlobalVoidFunc")
func Java_skip_bridge_samples_CompiledBridgeSamplesKt_compiledGlobalVoidFunc(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, i: Int32) {
    let i_swift = Int(i)
    compiledGlobalVoidFunc(i: i_swift)
}

#else

/* SKIP INSERT:
external fun compiledGlobalFunc(i: Int): Int
external fun compiledGlobalVoidFunc(i: Int)
*/
#endif

// Compiled class
// =================

#if !SKIP
//- SKIP @bridge(.all)
public class CompiledClass {
    public var i: Int
    public var s: String

    public init(i: Int, s: String) {
        self.i = i
        self.s = s
    }

    public func iplus(_ value: Int) -> Int {
        return i + value
    }
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1ptrref")
func Java_skip_bridge_samples_CompiledClass_Swift_ptrref(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, Swift_peer: SwiftObjectPtr) -> SwiftObjectPtr {
    return refSwift(Swift_peer, type: CompiledClass.self)
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1ptrderef")
func Java_skip_bridge_samples_CompiledClass_Swift_ptrderef(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, Swift_peer: SwiftObjectPtr) {
    derefSwift(Swift_peer, type: CompiledClass.self)
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1constructor")
func Java_skip_bridge_samples_CompiledClass_Swift_constructor(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, i: Int32, s: JavaString) -> SwiftObjectPtr {
    let i_swift = Int(i)
    let s_swift = try! String.fromJavaObject(s)
    let ret_swift = CompiledClass(i: i_swift, s: s_swift)
    return SwiftObjectPtr.forSwift(ret_swift, retain: true)
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1i")
func Java_skip_bridge_samples_CompiledClass_Swift_i(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, Swift_peer: SwiftObjectPtr) -> Int32 {
    let peer_swift: CompiledClass = Swift_peer.toSwift()
    let ret_swift = peer_swift.i
    return Int32(ret_swift)
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1set_1i")
func Java_skip_bridge_samples_CompiledClass_Swift_set_i(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, Swift_peer: SwiftObjectPtr, value: Int32) {
    let peer_swift: CompiledClass = Swift_peer.toSwift()
    let value_swift = Int(value)
    peer_swift.i = value_swift
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1s")
func Java_skip_bridge_samples_CompiledClass_Swift_s(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, Swift_peer: SwiftObjectPtr) -> JavaString {
    let peer_swift: CompiledClass = Swift_peer.toSwift()
    let ret_swift = peer_swift.s
    return ret_swift.toJavaObject()!
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1set_1s")
func Java_skip_bridge_samples_CompiledClass_Swift_set_s(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, Swift_peer: SwiftObjectPtr, value: JavaString) {
    let peer_swift: CompiledClass = Swift_peer.toSwift()
    let value_swift = try! String.fromJavaObject(value)
    peer_swift.s = value_swift
}

@_cdecl("Java_skip_bridge_samples2_CompiledClass_Swift_1iplus")
func Java_skip_bridge_samples_CompiledClass_Swift_iplus(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, Swift_peer: SwiftObjectPtr, value: Int32) -> Int32 {
    let peer_swift: CompiledClass = Swift_peer.toSwift()
    let value_swift = Int(value)
    let ret_swift = peer_swift.iplus(value_swift)
    return Int32(ret_swift)
}

#else

/* SKIP INSERT:
class CompiledClass {
    var Swift_peer: SwiftObjectPtr

    constructor(Swift_peer: SwiftObjectPtr) {
        this.Swift_peer = Swift_ptrref(Swift_peer)
    }
    private external fun Swift_ptrref(Swift_peer: SwiftObjectPtr): SwiftObjectPtr

    fun finalize() {
        Swift_ptrderef(Swift_peer)
        Swift_peer = SwiftObjectNil
    }
    private external fun Swift_ptrderef(Swift_peer: SwiftObjectPtr)

    constructor(i: Int, s: String) {
        val i_swift = i
        val s_swift = s
        Swift_peer = Swift_constructor(i_swift, s_swift)
    }
    // NOTE: Also encode parameter types into name if multiple constructors
    private external fun Swift_constructor(i: Int, s: String): SwiftObjectPtr

    var i: Int
        get() {
            val ret_swift = Swift_i(Swift_peer)
            return ret_swift
        }
        set(newValue) {
            val newValue_swift = newValue
            Swift_set_i(Swift_peer, newValue_swift)
        }
    private external fun Swift_i(Swift_peer: SwiftObjectPtr): Int
    private external fun Swift_set_i(Swift_peer: SwiftObjectPtr, value: Int)

    var s: String
        get() {
            val ret_swift = Swift_s(Swift_peer)
            return ret_swift
        }
        set(newValue) {
            val newValue_swift = newValue
            Swift_set_s(Swift_peer, newValue_swift)
        }
    private external fun Swift_s(Swift_peer: SwiftObjectPtr): String
    private external fun Swift_set_s(Swift_peer: SwiftObjectPtr, value: String)

    fun iplus(value: Int): Int {
        val value_swift = value
        val ret_swift = Swift_iplus(Swift_peer, value_swift)
        return ret_swift
    }
    // NOTE: Also encode parameter types into name if overloaded
    private external fun Swift_iplus(Swift_peer: SwiftObjectPtr, value: Int): Int
}
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
public class CompiledStruct {

}
