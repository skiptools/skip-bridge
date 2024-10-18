// swift-tools-version: 5.9
import Foundation
import CompilerPluginSupport
import PackageDescription

var swiftSettings: [SwiftSetting] = []
if ProcessInfo.processInfo.environment["SKIP_JNI_MODE"] == "1" {
    swiftSettings.append(.define("SKIP_JNI_MODE"))
}

let package = Package(
    name: "skip-bridge",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "SkipBridge", type: .dynamic, targets: ["SkipBridge"]),
        .library(name: "SkipBridgeSamples", type: .dynamic, targets: ["SkipBridgeSamples"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
        .package(url: "https://source.skip.tools/skip.git", branch: "main"),
        .package(url: "https://source.skip.tools/skip-lib.git", from: "1.0.0"),
    ],
    targets: [
        .macro(name: "SkipBridgeMacros",
            dependencies: [.product(name: "SwiftSyntaxMacros", package: "swift-syntax"), .product(name: "SwiftCompilerPlugin", package: "swift-syntax")]),
        .target(name: "CJNI"),
        .target(name: "SkipBridge",
            dependencies: ["CJNI", "SkipBridgeMacros", .product(name: "SkipLib", package: "skip-lib")],
            swiftSettings: swiftSettings,
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeSamples",
            dependencies: ["SkipBridge"],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipBridgeSamplesTests",
            dependencies: ["SkipBridgeSamples", .product(name: "SkipTest", package: "skip")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

