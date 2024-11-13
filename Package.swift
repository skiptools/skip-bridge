// swift-tools-version: 5.9
import Foundation
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "skip-bridge",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "SkipBridge", type: .dynamic, targets: ["SkipBridge"]),
        .library(name: "SkipBridgeSamples", type: .dynamic, targets: ["SkipBridgeSamples"]),
        .library(name: "SkipBridgeMacros", targets: ["SkipBridgeMacros"])
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
            dependencies: [.product(name: "SkipLib", package: "skip-lib")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "SkipBridgeMacros",
            dependencies: ["SkipBridgeMacrosImpl"]),
        .macro(name: "SkipBridgeMacrosImpl",
            dependencies: [.product(name: "SwiftSyntax", package: "swift-syntax"), .product(name: "SwiftSyntaxMacros", package: "swift-syntax"), .product(name: "SwiftCompilerPlugin", package: "swift-syntax")]),
        .target(name: "SkipBridgeSamples",
            dependencies: ["SkipBridge", "SkipBridgeKt", .product(name: "SkipFoundation", package: "skip-foundation")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipBridgeSamplesTests",
            dependencies: ["SkipBridgeSamples", .product(name: "SkipTest", package: "skip")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
