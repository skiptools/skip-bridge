import XCTest
import SkipBridge
import SkipBridgeSamples
#if os(macOS)
import SkipJNI
#endif

final class SkipBridgeSamplesTests: XCTestCase {
    override func setUp() {
        #if os(macOS)
        if jni == nil {
            // on macOS, start up an embedded JVM so we can test the Swift side of the SkipJNI bridge.

            //print("env: " + ProcessInfo.processInfo.environment.map({ $0 + "=" + $1 }).joined(separator: "\n").description)

            // TODO: need to figure out how to get the classpath from the prior gradle run so we can have access to the transpiled classes
            let home = URL.homeDirectory.path
            let gradleCaches = "\(home)/.gradle/caches"

            // XCTestBundlePath=~/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/Build/Products/Debug/SkipBridgeSamplesTests.xctest
            let skipstoneFolder: String
            if let testBundlePath = ProcessInfo.processInfo.environment["XCTestBundlePath"] {
                let projectPath = testBundlePath + "/../../../.."
                let output = "\(projectPath)/SourcePackages/plugins/skip-jni.output"
                skipstoneFolder = "\(output)/SkipBridgeSamplesTests/skipstone"
            } else {
                skipstoneFolder = "\(URL.currentDirectory().path)/.build/plugins/outputs/skip-jni/SkipBridgeSamplesTests/skipstone"
            }

            if !FileManager.default.fileExists(atPath: skipstoneFolder) {
                XCTFail("Expected build path did not exist at: \(skipstoneFolder)")
            }

            let cp = [
                "\(skipstoneFolder)/SkipBridgeSamples/.build/SkipBridgeSamples/intermediates/runtime_library_classes_jar/debug/bundleLibRuntimeToJarDebug/classes.jar",
                "\(skipstoneFolder)/SkipBridge/.build/SkipBridgeSamples/intermediates/runtime_library_classes_jar/debug/bundleLibRuntimeToJarDebug/classes.jar",
                "\(skipstoneFolder)/SkipLib/.build/SkipBridgeSamples/intermediates/runtime_library_classes_jar/debug/bundleLibRuntimeToJarDebug/classes.jar", // java.lang.ClassNotFoundException: skip.lib.StructKt
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
        #endif
    }

    func testSimpleBridging() throws {
        let math = MathBridge()
        XCTAssertEqual(4.0, math.callPurePOW(2.0, power: 2.0))

        #if SKIP
        // Java -> Java
        XCTAssertEqual(8.0, try math.callJavaPOW(2.0, power: 3.0))

        //print("### Classpath: " + System.getProperty("java.class.path"))
        #else
        // Swift -> Swift
        XCTAssertEqual(16.0, math.callSwiftPOW(2.0, power: 4.0))
        #endif

        // Java+Swift -> Swift
        XCTAssertEqual(64.0, math.callSwiftPOW(2.0, power: 6.0))

        // Swift+Java -> Java
        XCTAssertEqual(32.0, try math.callJavaPOW(2.0, power: 5.0))
    }

    func testThrowingSwiftFunctions() throws {
        let math = MathBridge()
        do {
            try math.callSwiftThrowing(message: "ABC")
            XCTFail("callSwiftThrowing should have failed")
        } catch {
            // expected
            #if SKIP
            XCTAssertEqual("skip.lib.ErrorException: java.lang.RuntimeException: ABC", "\(error)")
            #else
            XCTAssertEqual("ABC", "\(error)")
            #endif
        }
    }

    func testThrowingJavaFunctions() throws {
        let math = MathBridge()
        do {
            try math.callJavaThrowing(message: "XYZ")
            XCTFail("callJavaThrowing should have failed")
        } catch {
            // expected
            #if SKIP
            XCTAssertEqual("XYZ", "\(error)")
            #else
            XCTAssertEqual("XYZ", "\(error)")
            #endif
        }
    }

    func testStateManagement() throws {
        throw XCTSkip("TODO")
    }

    func testStaticFunctions() throws {
        throw XCTSkip("TODO")
    }

    func testAsycFunctions() throws {
        throw XCTSkip("TODO")
    }

    func testClosureFunctions() throws {
        throw XCTSkip("TODO")
    }

    func testBridgeReferenceFunctions() throws {
        throw XCTSkip("TODO")
    }

}
