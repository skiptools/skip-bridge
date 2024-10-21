// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SkipBridgeMacrosPlugin: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        BridgeToKotlinMacro.self,
        BridgeToSwiftMacro.self,
        BridgeIgnoredMacro.self,
        BridgeObservableMacro.self,
        BridgeObservationTrackedMacro.self,
        BridgeObservationIgnoredMacro.self,
    ]
}