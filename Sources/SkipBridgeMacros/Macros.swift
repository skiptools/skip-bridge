// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import Observation

/// Identify a compiled Swift declaration that should be bridged to Kotlin.
@attached(peer)
public macro BridgeToKotlin() = #externalMacro(module: "SkipBridgeMacrosImpl", type: "BridgeToKotlinMacro")

/// Identify a declaration that will be transpiled to Kotlin but should be bridged to compiled Swift.
@attached(peer)
public macro BridgeToSwift() = #externalMacro(module: "SkipBridgeMacrosImpl", type: "BridgeToSwiftMacro")

/// Mark a member that should not be bridged.
@attached(accessor, names: named(willSet))
public macro BridgeIgnored() = #externalMacro(module: "SkipBridgeMacrosImpl", type: "BridgeIgnoredMacro")
#endif
