import SkipBridge
#if !SKIP
import Darwin
import Foundation
#endif

// skipstone: MathBridge+SkipExtensions.swift

#if SKIP
extension MathBridge {
    func withSwiftBridge<T>(function: () -> T) -> T {
        if _swiftPeer == Long(0) {
            loadPeerLibrary() // ensure the shared library containing the native implementations is loaded
            // create the Swift peer for this Java instance
            _swiftPeer = createSwiftMathBridge()
        }

        return function()
    }

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
internal func loadPeerLibrary(libName: String = "SkipBridgeSamples") {
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

extension MathBridge : SkipReferenceBridgable {
    public static var javaClass: JClass {
        //print("### className: \(Self.self)") // "className: MathBridge"
        // FIXME: need to be able to implement this in te extension of the type somehow
        return try! JClass(name: "skip.bridge.samples.MathBridge")
    }


    public var javaPeer: JavaObject {
        get throws {
            let swiftPointer = self.swiftPointerValue
            if let existingPeer = swiftJavaPeerMap[swiftPointer] {
                return existingPeer
            }

            let clazz = Self.javaClass
            let constructor = clazz.getMethodID(name: "<init>", sig: "()V")!
            let obj: JavaObject = try! clazz.create(ctor: constructor, [])
            swiftJavaPeerMap[swiftPointer] = obj
            return obj
        }
    }


    public func toJavaObject() -> JavaObject? {
        try? javaPeer
    }

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
    public func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
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
