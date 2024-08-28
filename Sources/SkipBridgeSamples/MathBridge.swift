import SkipBridge
#if !SKIP
import Darwin
import Foundation
#endif

public final class MathBridge : SkipBridge {
    /// The name of the Java class for this Swift peer
    public static let javaClassName = "skip.bridge.samples.MathBridge"

    #if SKIP // added by skipstone
    /// The pointer to the Swift side of MathBridge associated with this Java instance, used by `lookupSwiftPeerFromJavaObject`
    var _swiftPeer: Long = 0
    #endif

    public init() {
        #if SKIP // added by skipstone
        loadPeerLibrary() // ensure the shared library containing the native implementations is loaded
        // create the Swift peer for this Java instance
        _swiftPeer = createSwiftMathBridge()
        #endif
    }

    /// This is a normal transpiled function; it exists in both the Swift and Java worlds, and does NOT bridge through JNI.
    public func callPurePOW(_ value: Double, power: Double) -> Double {
        var result = 1.0
        for _ in 0..<Int64(power) {
            result = result * value
        }
        return result
    }

    /// This function is POW implemented in Java. It can be called from either Java or Swift.
    ///
    /// Calling it from Java will invoke it directly,
    /// and calling it from Swift will invoke it through a transpiler-generated JNI implementation of `invokeJava` (see below).
    ///
    /// The transpiled version of this function simply removes the `invokeJava` block and calls the implementation directly:
    ///
    /// ```
    /// public fun callJavaPOW(value: Double, power: Double): Double {
    ///     return java.lang.Math.pow(value, power)
    /// }
    /// ```
    //@available(iOS, unavailable)
    public func callJavaPOW(_ value: Double, power: Double) throws -> Double {
        return try invokeJava(value, power) {
            #if SKIP
            return java.lang.Math.pow(value, power)
            #endif
        }
    }

    /// Calling this function from Swift will simply invoke the block directly.
    /// When called through the transpiled Kotlin, this function will be invoked through a `@_cdecl` shim function via JNI.
    ///
    /// The transpiled version of this function simply externalizes it, where it will invoke `Java_skip_sample_MathBridge_callSwiftPOW` (see below):
    ///
    /// ```
    /// public native fun callSwiftPOW(value: Double, power: Double): Double
    /// ```
    public func callSwiftPOW(_ value: Double, power: Double) -> Double {
        // skipstone will replace `invokeSwift` call with `invokeSwift_callSwiftPOW(value, power)`, which it will also generate (see below)
        // SKIP REPLACE: return invokeSwift_callSwiftPOW(value, power)
        return invokeSwift(value, power) {
            #if !SKIP
            return Darwin.pow(value, power)
            #endif
        }
    }

    public func callJavaThrowing(message: String) throws {
        try invokeJavaVoid(message) {
            #if SKIP
            throw MathError(description: message)
            #endif
        }
    }

    public func callSwiftThrowing(message: String) throws {
        // SKIP REPLACE: { checkSwiftErrorVoid { -> invokeSwift_callSwiftThrowing(message) } }()
        try invokeSwiftVoid(message) {
            #if !SKIP
            throw MathError(description: message)
            #endif
        }
    }


    /// Cleanup JNI peer; we can't do this with the added Swift extension, since deinit must be defined in the class itself.
    /// Note that cleanup will only happen if this instance was constructed from the Swift side.
    /// It if was created from the Java side, then cleanup will happen when the instance is finalized in the owning Java peer, like:
    ///
    /// ```
    /// fun finalize() {
    ///     JNI_call_cleanupSkipBridge(this)
    /// }
    /// ```
    deinit {
        // the alternative would be to force a base class
        if /* createdFromSwift */ true {
            cleanupSkipBridge()
        }
    }
}

public struct MathError: Error, CustomStringConvertible {
    public var description: String

    public init(description: String) {
        self.description = description
    }
}

// skipstone: MathBridge+SkipExtensions.swift

#if SKIP
extension MathBridge {
    /* SKIP EXTERN */ public func createSwiftMathBridge() -> Int64 {
        // this will invoke @_cdecl("Java_skip_bridge_samples_MathBridge_createSwiftMathBridge")
    }

    /* SKIP EXTERN */ public func invokeSwift_callSwiftPOW(_ value: Double, _ power: Double) -> Double {
        // this will invoke @_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__DD")
    }

    /* SKIP EXTERN */ public func invokeSwift_callSwiftThrowing(_ value: String) {
        // this will invoke @_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing")
    }
}


/// In order to use JNI to access the Swift side of the bridge, we need to first manually load the library.
/// This only works on macOS; Android will need to load the .so from the embedded jni library path.
///
/// When searching for the library to load, there are four scenarios we need to handle,
/// each of which has different paths that need to be searched:
///
/// 1. Xcode-launched Swift tests where the embedded JVM needs to load the Xcode-created library ("SkipBridgeSamples.framework/SkipBridgeSamples")
/// 2. Xcode-launched Skip gradle tests, where gradle's JVM needs to load the Xcode created-library ("SkipBridgeSamples.framework/SkipBridgeSamples")
/// 3. SwiftPM-launched Swift tests where the embedded JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
/// 4. SwiftPM-launched Skip gradle tests, where gradle's JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
private func loadPeerLibrary(libName: String = "SkipBridgeSamples") {
    //print("### System.getenv(): \(System.getenv())")

    // Xcode output for dynamic library
    // user.dir: ~/Developer/Xcode/DerivedData/ProjectName/SourcePackages/plugins/skip-jni.output/SkipBridgeSamplesTests/skipstone/SkipBridgeSamples
    // framework dylib: ~/Library/Developer/Xcode/DerivedData/ProjectName/Build/Products/Debug/PackageFrameworks/SkipBridgeSamples.framework/Versions/A/SkipBridgeSamples

    // XCTestBundlePath=/Users/marc/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/Build/Products/Debug/SkipBridgeSamplesTests.xctest
    var libraryPath: String
    if let testBundlePath = System.getenv()["XCTestBundlePath"] { // running from within Xcode
        libraryPath = testBundlePath + "/../PackageFrameworks/\(libName).framework/Versions/A/\(libName)"
    } else {
        let cwd = System.getProperty("user.dir")
        // from gradle: /opt/src/github/skiptools/skip-jni/.build/plugins/outputs/skip-jni/SkipBridgeSamplesTests/skipstone
        // from swiftPM CLI: /opt/src/github/skiptools/skip-jni
        let dylib = "lib\(libName).dylib"
        let arch = System.getProperty("os.arch") == "aarch64" ? "arm64-apple-macosx" : "x86_64-apple-macosx"
        libraryPath = cwd + "/.build/\(arch)/debug/\(dylib)" // Swift-launched JVM
        if !java.io.File(libraryPath).isFile() {
            libraryPath = cwd + "/../../../../../../\(arch)/debug/\(dylib)" // gradle-launched JVM
        }
    }

    // load the native library that contains the function implementations
    if !java.io.File(libraryPath).isFile() {
        print("warning: missing library: \(libraryPath)")
    } else {
        print("note: loading library: \(libraryPath)")
        System.load(libraryPath)
        print("note: loaded library: \(libraryPath)")
    }
}

#else

import SkipJNI

// skipstone-generated JNI functions

@_cdecl("Java_skip_bridge_samples_MathBridge_createSwiftMathBridge")
public func Java_skip_bridge_samples_MathBridge_createSwiftMathBridge(_ env: JNIEnvPointer, _ obj: JavaObject?) -> Int64 {
    let bridge = MathBridge()
    let ptr = bridge.swiftPointerValue
    javaSwiftPeerMap[ptr] = bridge // need to retain the peer instance so it is not released until the owning Java instance finalizes
    return ptr
}

@_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__DD")
public func Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftPOW__DD(_ env: JNIEnvPointer, _ obj: JavaObject?, _ value: Double, _ power: Double) -> Double {
    let bridge: MathBridge = try! lookupSwiftPeerFromJavaObject(obj) // TODO: how to handle exception?
    return bridge.callSwiftPOW(value, power: power)
}

@_cdecl("Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing")
public func Java_skip_bridge_samples_MathBridge_invokeSwift_1callSwiftThrowing(_ env: JNIEnvPointer, _ obj: JavaObject?, _ message: JavaString?) {
    let bridge: MathBridge = try! lookupSwiftPeerFromJavaObject(obj) // TODO: how to handle exception?
    do {
        try bridge.callSwiftThrowing(message: String.fromJavaObject(message))
    } catch {
        // `@_cdecl` JNI functions cannot throw errors, so instead we add the current error to the thread's error stack, which we will check after invoking the function
        pushSwiftError(error)
    }
}

// skipstone-generated Swift

extension MathBridge {

    /// Call from Swift into Java using JNI
    public func invokeJavaVoid(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws {
        let javaObject: JavaObject = try self.javaPeer

        if functionName == "callJavaThrowing(message:)" {
            // 1. Get the Java peer of this Swift instance via the pointer value
            let jobj = JObject(javaObject)
            let jcls = jobj.cls

            // 2. Look up the callJavaPOW function using JNI with the specified arguments
            guard let mid = jcls.getMethodID(name: "callJavaThrowing", sig: "(Ljava/lang/String;)V") else {
                fatalError("could not lookup method id")
            }

            // 3. Invoke the JNI method with the given arguments
            let jargs = args.map({ $0.toJavaParameter() })
            return try jobj.call(method: mid, jargs)
        } else {
            fatalError("could not identify which function called invokeJavaVoid for: \(functionName)")
        }
    }

    /// Call from Swift into Java using JNI
    public func invokeJava<T>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T where T : SkipBridgable {
        let javaObject: JavaObject = try self.javaPeer

        if functionName == "callJavaPOW(_:power:)" { // alternative: if lineNumber == 12345 { … }, which would let us have multiple functions with the same name
            // 1. Get the Java peer of this Swift instance via the pointer value
            let jobj = JObject(javaObject)
            let jcls = jobj.cls

            // 2. Look up the callJavaPOW function using JNI with the specified arguments
            guard let mid = jcls.getMethodID(name: "callJavaPOW", sig: "(DD)D") else {
                fatalError("could not lookup method id")
            }

            // 3. Invoke the JNI method with the given arguments
            let jargs = args.map({ $0.toJavaParameter() })
            return try jobj.call(method: mid, jargs)
        } else {
            fatalError("could not identify which function called invokeJava for: \(functionName)")
        }
    }
}

#endif
