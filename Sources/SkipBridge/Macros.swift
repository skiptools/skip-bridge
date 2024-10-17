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
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@attached(member, names: named(_$observationRegistrar), named(_$bridgingObservationRegistrar), named(access), named(withMutation))
@attached(memberAttribute)
@attached(extension, conformances: Observable)
public macro BridgeToKotlinObservable() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeToKotlinObservableMacro")

/// Add the ability for this property to participate in both SwiftUI and Jetpack Compose state tracking.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@attached(accessor, names: named(init), named(get), named(set))
@attached(peer, names: prefixed(`_`))
public macro BridgeToKotlinObservationTracked() = #externalMacro(module: "SkipBridgeMacros", type: "BridgeToKotlinObservationTrackedMacro")

/// Helper to bridge Swift observed state changes to Jetpack Compose state tracking.
public struct BridgingObservationRegistrar {
    public init(_ propertyCount: Int) {
        // TODO
    }

    public func willAccess(_ property: String) {
        // TODO
    }

    public func willUpdate<T>(_ property: String, _ from: T, _ to: T) where T: Equatable {
        if to != from {
            willChange(property)
        }
    }

    public func willUpdate(_ property: String, _ from: Any, _ to: Any) {
        if (to as AnyObject) !== (from as AnyObject) {
            willChange(property)
        }
    }

    private func willChange(_ property: String) {
        // TODO
    }
}

#endif
