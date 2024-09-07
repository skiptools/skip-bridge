// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

// Only available to compiled code under `#if os(Android)`
#if SKIP
// SKIP @bridge
public func javaPow(_ value: Double, power: Double) -> Double {
    java.lang.Math.pow(value, power)
}
#endif

// Available to all compiled code
// SKIP @bridge
public func dualPlatformPow(_ value: Double, power: Double) -> Double {
    #if SKIP
    java.lang.Math.pow(value, power)
    #else
    Darwin.pow(value, power)
    #endif
}
