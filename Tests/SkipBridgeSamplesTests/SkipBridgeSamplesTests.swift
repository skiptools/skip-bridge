import XCTest
import Foundation
import SkipBridge
import SkipBridgeSamples

final class SkipBridgeSamplesTests: XCTestCase {
    func testMathBridge() throws {
        let math = MathBridge()
        XCTAssertEqual(4.0, math.callPurePOW(2.0, power: 2.0)) // Java -> Java + Swift -> Swift
        XCTAssertEqual(64.0, math.callSwiftPOW(2.0, power: 6.0)) // Java+Swift -> Swift
        XCTAssertEqual(32.0, try math.callJavaPOW(2.0, power: 5.0)) // Swift+Java -> Java
    }

    func testSwiftURLBridge() throws {
        let url = try SwiftURLBridge(urlString: "https://skip.tools")
        XCTAssertFalse(url.isFileURL())
    }

    func testJavaFileBridge() throws {
        let tmpName = "/tmp/skipbridge-" + UUID().uuidString
        let file = try JavaFileBridge(filePath: tmpName)
        XCTAssertFalse(try file.exists())
        XCTAssertTrue(try file.createNewFile())
        XCTAssertTrue(try file.exists())

        let url: SwiftURLBridge = try file.toSwiftURLBridge()
        XCTAssertTrue(url.isFileURL())

        let file2 = try url.toJavaFileBridge()
        XCTAssertTrue(try file2.exists())
        XCTAssertTrue(try file2.delete())
        XCTAssertFalse(try file2.exists())
    }

    func testAsyncFunctions() async throws {
        let tmpName = "/tmp/skipbridge-" + UUID().uuidString
        try "ABC".write(toFile: tmpName, atomically: false, encoding: .utf8)
        let urlBridge = try SwiftURLBridge(urlString: "file:" + tmpName)
        #if SKIP
        throw XCTSkip("TODO: async")
        #else
        let contents = try await urlBridge.readContents()
        XCTAssertEqual("ABC", contents)
        #endif

        _ = try JavaFileBridge(filePath: tmpName).delete()
    }

    func testStaticFunctions() throws {
        let tmpName = "/tmp/skipbridge-" + UUID().uuidString
        let file = try JavaFileBridge(filePath: tmpName)
        do {
            let result = try SwiftURLBridge.fromJavaFileBridge(file).isFileURL()
            XCTAssertTrue(result)
        } catch {
            // FIXME: java.lang.RuntimeException: kotlin.UninitializedPropertyAccessException: lateinit property filestorage has not been initialized
            throw XCTSkip("TODO: fix peer setup for static functions")
        }
    }

    func testThrowingSwiftFunctions() throws {
        let math = MathBridge()
        do {
            try math.callSwiftThrowing(message: "ABC")
            XCTFail("callSwiftThrowing should have thrown an error")
        } catch {
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
            XCTFail("callJavaThrowing should have thrown an error")
        } catch {
            XCTAssertEqual("XYZ", "\(error)")
        }
    }

    func testAsycFunctions() throws {
        throw XCTSkip("TODO")
    }

    func testClosureParameters() throws {
        throw XCTSkip("TODO")
    }
}

#if os(macOS)
import SkipJNI

extension SkipBridgeSamplesTests {

    func testArrayJNI() throws {
        let array: JavaFloatArray = try XCTUnwrap(Float.createArray(len: 5))
        Float.setArrayRegion(values: [1.1, 2.2, 3.3], into: array, offset: 1)
        XCTAssertEqual([0.0, 1.1, 2.2, 3.3, 0.0], Float.getArrayElements(from: array))
    }

    /// On macOS, start up an embedded JVM so we can test the Swift side of the SkipJNI bridge.
    ///
    /// This setup is very delicate, because it relies on the assumed paths of the dependent jars in the `~/.gradle/caches/` folder, among other things.
    /// One potential solution might be to try to get the runtime classpath by forking `gradle` with a custom task that prints out the classpath for the transpiled project, and then using that classpath directly.
    override func setUp() {
        if jni == nil {

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
    }
}
#endif
