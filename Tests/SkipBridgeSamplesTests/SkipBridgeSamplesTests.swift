// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipBridgeSamples
import XCTest

// XXXSKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class SkipBridgeSamplesTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary("SkipBridgeSamples")
        #endif
    }

    func testBridgedNumbers() throws {
        XCTAssertEqual(Int64(56088), globalBridgeInt64Field)
        XCTAssertEqual(Double(56088), globalBridgeDoubleField)
        XCTAssertEqual(Int8(112), globalBridgeInt8Field)
        XCTAssertEqual(UInt8(240), globalBridgeUInt8Field)
    }

    func testBridgedStrings() throws {
        XCTAssertEqual("abc123", globalBridgeStringField)

        XCTAssertEqual("😀", globalBridgeUTF8String1Field)
        XCTAssertEqual("🚀123", globalBridgeUTF8String2Field)

        XCTAssertEqual("😀🚀", globalBridgeUTF8String3Field)

        #if !SKIP
        let codePoints: [UInt8] = Array(globalBridgeUTF8String3Field.utf8)
        #else
        let codePoints: [UInt8] = Array(globalBridgeUTF8String3Field.toByteArray(Charsets.UTF_8).toList().map({ UByte($0) }))
        #endif
        XCTAssertEqual([240, 159, 152, 128, 240, 159, 154, 128], codePoints.map({ Int($0) }))

        #if SKIP && false
        // when we just use NewStringUTF, this is how strings fail
        XCTAssertNotEqual("😀🚀", globalBridgeUTF8String3Field)
        XCTAssertEqual([240, 159], codePoints)
        #endif
    }

    func testBridgedBackIntoJava() throws {
        #if SKIP
        // this test calls from transpiled Kotlin into Swift, and then back out the Java to get the System property
        XCTAssertEqual("/", globalJavaGetFileSeparator)
        #endif
    }

    func testTranspiledToCompiledCall() throws {
        #if SKIP
        XCTAssertEqual(3.100000023841858, globalCompiledtoTranspiledCall)
        #endif
    }

    func testCompiledClass() throws {
        let c = CompiledClass()
        c.publicVar = "xxx"
        XCTAssertEqual(c.publicVar, "xxx")
        c.publicVar = "yyy"
        XCTAssertEqual(c.publicVar, "yyy")
    }

    #if SKIP
    func testTranspiledVar() throws {
        let i = compiledFuncToTranspiledVar(value: 99)
        XCTAssertEqual(i, 99)
    }

    func testTranspiledComputedVar() throws {
        let i = compiledFuncToTranspiledComputedVar()
        XCTAssertEqual(i, 100)
    }

    func testTranspiledCompiledVar() throws {
        let s = compiledFuncToTranspiledCompiledVar()
        XCTAssertEqual(s, "publicVar")
    }

    func testTranspiledClass() throws {
        let str = compiledFuncToTranspiledClassPublicVar(value: "xxx")
        XCTAssertEqual(str, "xxx")
    }

    func testTranspiledTypeCompiledVar() throws {
        let c = TranspiledClass()
        c.publicVar = "fromcompiled"
        compiledVarOfTranspiledType = c

        let c2 = compiledVarOfTranspiledType
        XCTAssertEqual(c2.publicVar, "fromcompiled")
    }

    func testTranspiledTypeTranspiledVar() throws {
        let i = compiledFuncToTranspiledVarOfTranspiledType(value: 101)
        XCTAssertEqual(i, 101)
    }

    func testTranspiledTypeCompiledMemberVar() throws {
        let s = compiledFuncToTranspiledVarOfCompiledType(value: "compiledvar")
        XCTAssertEqual(s, "compiledvar")
    }
    #endif
}

#if SKIP
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
func loadPeerLibrary(_ libName: String) {
    //print("System.getenv(): \(System.getenv())")

    // Xcode output for dynamic library
    // user.dir: ~/Developer/Xcode/DerivedData/ProjectName/SourcePackages/plugins/skip-jni.output/SkipBridgeSamplesTests/skipstone/SkipBridgeSamples
    // framework dylib: ~/Library/Developer/Xcode/DerivedData/ProjectName/Build/Products/Debug/PackageFrameworks/SkipBridgeSamples.framework/Versions/A/SkipBridgeSamples

    // XCTestBundlePath=/Users/marc/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/Build/Products/Debug/SkipBridgeSamplesTests.xctest
    var libraryPath: String
    if let testBundlePath = System.getenv()["XCTestBundlePath"] { // running from within Xcode
        libraryPath = testBundlePath + "/../PackageFrameworks/\(libName).framework/\(libName)"
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
        if !java.io.File(libraryPath).isFile() {
            libraryPath = cwd + "/../../../../../../../\(arch)/debug/\(dylib)" // gradle-launched JVM (Swift 6)
        }
    }

    // load the native library that contains the function implementations
    if !java.io.File(libraryPath).isFile() {
        fatalError("error: missing library: \(libraryPath)")
    } else {
        print("note: loading library: \(libraryPath)")
        System.load(libraryPath)
        print("note: loaded library: \(libraryPath)")
    }
}

#endif
