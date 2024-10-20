// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import CJNI

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

