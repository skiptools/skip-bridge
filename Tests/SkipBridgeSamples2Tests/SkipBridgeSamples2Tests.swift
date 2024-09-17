// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipBridgeSamples2
import XCTest
#if !SKIP
import SkipJNI
#endif

final class SkipBridgeSamplesTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(1 + 1, 2)
    }

    func testTranspiledGlobalLet() {
        XCTAssertEqual(transpiledGlobalLet, 1)
    }

    func testTranspiledGlobalVar() {
        transpiledGlobalVar = 1
        XCTAssertEqual(transpiledGlobalVar, 1)
        transpiledGlobalVar = 100
        XCTAssertEqual(transpiledGlobalVar, 100)
    }

    #if !SKIP
    override func setUp() {
        if jni == nil {
            // TODO: need to figure out how to get the classpath from the prior gradle run so we can have access to the transpiled classes
            let home = URL.homeDirectory.path
            let gradleCaches = "\(home)/.gradle/caches"

            // XCTestBundlePath=~/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/Build/Products/Debug/SkipBridgeSamplesTests.xctest
            let skipstoneFolder: String
            if let testBundlePath = ProcessInfo.processInfo.environment["XCTestBundlePath"] {
                let projectPath = testBundlePath + "/../../../.."
                let output = "\(projectPath)/SourcePackages/plugins/skip-jni.output"
                skipstoneFolder = "\(output)/SkipBridgeSamples2Tests/skipstone"
            } else {
                skipstoneFolder = "\(URL.currentDirectory().path)/.build/plugins/outputs/skip-jni/SkipBridgeSamples2Tests/skipstone"
            }

            if !FileManager.default.fileExists(atPath: skipstoneFolder) {
                XCTFail("Expected build path did not exist at: \(skipstoneFolder)")
            }

            let cp = [
                "\(skipstoneFolder)/SkipBridgeSamples2/.build/SkipBridgeSamples2/intermediates/runtime_library_classes_jar/debug/bundleLibRuntimeToJarDebug/classes.jar",
                "\(skipstoneFolder)/SkipBridge2/.build/SkipBridgeSamples2/intermediates/runtime_library_classes_jar/debug/bundleLibRuntimeToJarDebug/classes.jar",
                "\(skipstoneFolder)/SkipLib/.build/SkipBridgeSamples2/intermediates/runtime_library_classes_jar/debug/bundleLibRuntimeToJarDebug/classes.jar", // java.lang.ClassNotFoundException: skip.lib.StructKt
                "\(gradleCaches)/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib/2.0.0/b48df2c4aede9586cc931ead433bc02d6fd7879e/kotlin-stdlib-2.0.0.jar", // java.lang.NoClassDefFoundError: kotlin/jvm/functions/Function0
            ]

            for path in cp {
                if !FileManager.default.fileExists(atPath: path) {
                    XCTFail("Classpath element did not exist: \(path)")
                }
            }

            var opts = JVMOptions.default
            opts.classPath = cp
            //opts.verboseJNI = true
            try! launchJavaVM(options: opts)
            XCTAssertNotNil(jni, "jni context should have been created")
        }
    }
    #endif
}
