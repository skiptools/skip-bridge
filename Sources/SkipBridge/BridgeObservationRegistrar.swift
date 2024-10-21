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

    public init(for properties: [String]) {
        self.propertyIndexes = Self.assignIndexes(to: properties)
        self.Java_peer = Self.Java_initPeer(propertyCount: properties.count)
    }

    public func access(_ property: String) {
        if let index = propertyIndexes[property] {
            Java_access(index)
        }
    }

    public func update<T>(_ property: String, _ from: T, _ to: T) where T: Equatable {
        if to != from, let index = propertyIndexes[property] {
            Java_update(index)
        }
    }

    public func update(_ property: String, _ from: Any, _ to: Any) {
        if (to as AnyObject) !== (from as AnyObject), let index = propertyIndexes[property] {
            Java_update(index)
        }
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

    #if SKIP_JNI_MODE
    private static let Java_stateClass = try? JClass(name: "skip/model/MutableStateBacking")
    private static let Java_state_init_methodID = Java_stateClass?.getMethodID(name: "<init>", sig: "(I)V")
    private static let Java_state_access_methodID = Java_stateClass?.getMethodID(name: "access", sig: "(I)V")
    private static let Java_state_update_methodID = Java_stateClass?.getMethodID(name: "update", sig: "(I)V")

    private let Java_peer: JObject?

    private static func Java_initPeer(propertyCount: Int) -> JObject? {
        guard let cls = Java_stateClass, let initMethod = Java_state_init_methodID else {
            return nil
        }
        let ptr: JavaObjectPointer = try! cls.create(ctor: initMethod, args: [Int32(propertyCount).toJavaParameter()])
        return JObject(ptr)
    }

    private func Java_access(_ index: Int) {
        guard let peer = Java_peer, let accessMethod = Self.Java_state_access_methodID else {
            return
        }
        try! peer.call(method: accessMethod, args: [Int32(index).toJavaParameter()])
    }

    private func Java_update(_ index: Int) {
        guard let peer = Java_peer, let updateMethod = Self.Java_state_update_methodID else {
            return
        }
        try! peer.call(method: updateMethod, args: [Int32(index).toJavaParameter()])
    }
    #else

    private var Java_peer: Any?

    private static func Java_initPeer(propertyCount: Int) -> Any? {
        return nil
    }

    private func Java_access(_ index: Int) {
    }

    private func Java_update(_ index: Int) {
    }
    #endif
}
#endif

