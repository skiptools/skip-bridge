// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if false
@_cdecl("DarwinMath_Bridge_pow__DD")
internal func DarwinMath_Bridge_pow_DD(_ env: JNIEnvPointer, _ value: Double, _ power: Double) -> Double {
    pow(value, power)
}
#endif

/*
 Transpiled Kotlin:

 fun pow(value: Double, power: Double): Double {
    loadPeerLibrary("SkipBridgeSamples2")
    return DarwinMath_Bridge_pow(value, power)
 }

 /* SKIP EXTERN */ fun DarwinMath_Bridge_pow(value: Double, power: Double) { }
 */
