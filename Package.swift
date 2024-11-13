// swift-tools-version: 5.9
import Foundation
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "skip-bridge",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "SkipBridge", type: .dynamic, targets: ["SkipBridge"]),
        .library(name: "SkipBridgeKt", type: .dynamic, targets: ["SkipBridgeKt"]),
        .library(name: "SkipBridgeMacros", targets: ["SkipBridgeMacros"]),
        .library(name: "SkipBridgeToKotlinSamples", type: .dynamic, targets: ["SkipBridgeToKotlinSamples"]),
        .library(name: "SkipBridgeToKotlinSamplesHelpers", type: .dynamic, targets: ["SkipBridgeToKotlinSamplesHelpers"]),
        .library(name: "SkipBridgeToSwiftSamples", type: .dynamic, targets: ["SkipBridgeToSwiftSamples"]),
        .library(name: "SkipBridgeToSwiftSamplesHelpers", type: .dynamic, targets: ["SkipBridgeToSwiftSamplesHelpers"]),
        .library(name: "SkipBridgeToSwiftSamplesTestsSupport", type: .dynamic, targets: ["SkipBridgeToSwiftSamplesTestsSupport"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", branch: "main"),
        .package(url: "https://source.skip.tools/skip-lib.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1")
    ],
    targets: [
        .target(name: "CJNI"),
        .target(name: "SkipBridge",
            dependencies: ["CJNI", .product(name: "SkipLib", package: "skip-lib")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeKt",
            dependencies: ["SkipBridge"],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeMacros",
            dependencies: ["SkipBridgeMacrosImpl"]),
        .macro(name: "SkipBridgeMacrosImpl",
            dependencies: [.product(name: "SwiftSyntax", package: "swift-syntax"), .product(name: "SwiftSyntaxMacros", package: "swift-syntax"), .product(name: "SwiftCompilerPlugin", package: "swift-syntax")]),
        .target(name: "SkipBridgeToKotlinSamples",
            dependencies: ["SkipBridgeToKotlinSamplesHelpers"],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeToKotlinSamplesHelpers",
            dependencies: ["SkipBridgeKt", .product(name: "SkipFoundation", package: "skip-foundation")],
                plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeToSwiftSamples",
            dependencies: ["SkipBridgeToSwiftSamplesHelpers"],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeToSwiftSamplesHelpers",
            dependencies: ["SkipBridgeKt", .product(name: "SkipFoundation", package: "skip-foundation")],
                plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeToSwiftSamplesTestsSupport",
            dependencies: ["SkipBridgeToSwiftSamples"],
                plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipBridgeToKotlinSamplesTests",
            dependencies: ["SkipBridgeToKotlinSamples", .product(name: "SkipTest", package: "skip")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipBridgeToSwiftSamplesTestsSupportTests",
            dependencies: ["SkipBridgeToSwiftSamplesTestsSupport", .product(name: "SkipTest", package: "skip")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
