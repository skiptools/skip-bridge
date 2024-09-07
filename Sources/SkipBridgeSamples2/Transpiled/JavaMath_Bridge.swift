// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if false
public func javaPow(_ value: Double, power: Double) -> Double {
    // Use SkipBridge to invoke generated javaPow Kotlin function
}

public func dualPlatformPow(_ value: Double, power: Double) -> Double {
    // Use SkipBridge to invoke dualPlatformPow Kotlin function
}
#endif

/*
 Transpiled Kotlin:

 fun javaPow(value: Double, power: Double): Double {
     java.lang.Math.pow(value, power)
 }

 fun dualPlatformPow(value: Double, power: Double): Double {
     java.lang.Math.pow(value, power)
 }
 */
