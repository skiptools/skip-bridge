// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// In order to use JNI to access the Swift side of the bridge, we need to first manually load the library.
/// This only works on macOS; Android will need to load the .so from the embedded jni library path.
///
/// When searching for the library to load, there are four scenarios we need to handle,
/// each of which has different paths that need to be searched:
///
/// 1. Xcode-launched Swift tests where the embedded JVM needs to load the Xcode-created library ("SkipBridgeSamples.framework/SkipBridgeSamples")
/// 2. Xcode-launched Skip gradle tests, where gradle's JVM needs to load the Xcode created-library ("SkipBridgeSamples.framework/SkipBridgeSamples")
/// 3. SwiftPM-launched Swift tests where the embedded JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
/// 4. SwiftPM-launched Skip gradle tests, where gradle's JVM needs to load the SwiftPM-created library ("libSkipBridgeSamples.dylib")
public func loadLibrary(packageName: String, moduleName libName: String) throws {
    let libName_java = libName.toJavaParameter(options: [])
    try Java_systemClass.get().callStatic(method: Java_loadLibrary_methodID.get(), options: [], args: [libName_java])
}

private let Java_systemClass = Result { try JClass(name: "skip.bridge.kt.SystemKt") }
private let Java_loadLibrary_methodID = Result { try Java_systemClass.get().getStaticMethodID(name: "loadLibrary", sig: "(Ljava/lang/String;)V")! }
