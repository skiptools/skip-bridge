// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "skip-jni",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "SkipJNI", type: .dynamic, targets: ["SkipJNI"]),
        .library(name: "SkipBridge", type: .dynamic, targets: ["SkipBridge"]),
        .library(name: "SkipBridge2", type: .dynamic, targets: ["SkipBridge2"]),
        .library(name: "SkipBridgeSamples", type: .dynamic, targets: ["SkipBridgeSamples"]),
        .library(name: "SkipBridgeSamples2", type: .dynamic, targets: ["SkipBridgeSamples2"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-lib.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "CJNI"),
        .target(name: "SkipJNI", 
            dependencies: ["CJNI"]),
        .target(name: "SkipBridge",
            dependencies: ["SkipJNI", .product(name: "SkipLib", package: "skip-lib")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridge2",
            dependencies: ["SkipJNI", .product(name: "SkipLib", package: "skip-lib")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeSamples",
            dependencies: ["SkipBridge", .product(name: "SkipFoundation", package: "skip-foundation")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeSamples2",
            dependencies: ["SkipBridge2", .product(name: "SkipFoundation", package: "skip-foundation")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        // disable SkipBridgeSamplesTests because the JNI class loading conflicts with that being used by SkipBridgeSamples2Tests
//        .testTarget(name: "SkipBridgeSamplesTests",
//            dependencies: ["SkipBridgeSamples", .product(name: "SkipTest", package: "skip")],
//            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipBridgeSamples2Tests",
            dependencies: ["SkipBridgeSamples2", .product(name: "SkipTest", package: "skip")],
            plugins: [.plugin(name: "skipstone", package: "skip")])
    ]
)
