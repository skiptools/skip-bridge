// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import Observation

/// Identify a compiled Swift declaration that should be bridged to Kotlin.
@attached(peer)
public macro BridgeToKotlin() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeToKotlinMacro")

/// Identify a declaration that will be transpiled to Kotlin but should be bridged to compiled Swift.
@attached(peer)
public macro BridgeToSwift() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeToSwiftMacro")

/// Mark a member that should not be bridged.
@attached(accessor, names: named(willSet))
public macro BridgeIgnored() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeIgnoredMacro")

/// Add the ability for this type to participate in both SwiftUI and Jetpack Compose state tracking.
@attached(member, names: named(_$observationRegistrar), named(_$BridgeObservationRegistrar), named(access), named(withMutation))
@attached(memberAttribute)
@attached(extension, conformances: Observable)
public macro BridgeToKotlinObservable() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeToKotlinObservableMacro")

/// Add the ability for this property to participate in both SwiftUI and Jetpack Compose state tracking.
@attached(accessor, names: named(init), named(get), named(set))
@attached(peer, names: prefixed(`_`))
public macro BridgeObservationTracked() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeObservationTrackedMacro")

/// Ignore this property for state tracking.
@attached(accessor, names: named(willSet))
public macro BridgeObservationIgnored() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeObservationIgnoredMacro")

/// Helper to bridge Swift observed state changes to Jetpack Compose state tracking.
public struct BridgeObservationRegistrar: Codable, Hashable, @unchecked Sendable {
    private let propertyIndexes: [String: Int]
    private let Java_peer: JavaObjectPointer?

    public init(for properties: [String]) {
        self.propertyIndexes = Self.assignIndexes(to: properties)
        self.Java_peer = Self.Java_initPeer(propertyCount: properties.count)
    }

    public func access(_ property: String) {
        guard let index = propertyIndexes[property] else {
            return
        }
        // TODO
    }

    public func update<T>(_ property: String, _ from: T, _ to: T) where T: Equatable {
        if to != from, let index = propertyIndexes[property] {
            update(index)
        }
    }

    public func update(_ property: String, _ from: Any, _ to: Any) {
        if (to as AnyObject) !== (from as AnyObject), let index = propertyIndexes[property] {
            update(index)
        }
    }

    private func update(_ index: Int) {
        // TODO
    }

    public static func ==(lhs: BridgeObservationRegistrar, rhs: BridgeObservationRegistrar) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        // OK if order is different on decode
        try container.encode(contentsOf: propertyIndexes.keys)
    }

    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var properties: [String] = []
        while !container.isAtEnd {
            try properties.append(container.decode(String.self))
        }
        self.propertyIndexes = Self.assignIndexes(to: properties)
        self.Java_peer = Self.Java_initPeer(propertyCount: properties.count)
    }

    private static func assignIndexes(to properties: [String]) -> [String: Int] {
        return properties.enumerated().reduce(into: [:]) { result, property in
            result[property.element] = property.offset
        }
    }

    private static func Java_initPeer(propertyCount: Int) -> JavaObjectPointer? {
        // TODO
        return nil
    }
}

#endif
