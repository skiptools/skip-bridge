// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// Throw a Swift error to Kotlin.
public func JavaThrowError(_ error: any Error, env: JNIEnvPointer) {
    let jniEnv = env.pointee!.pointee
    let _ = jniEnv.ThrowNew(env, Java_errorExceptionClass.ptr, String(describing: error))
}

/// Create a Kotlin throwable.
public func JavaErrorThrowable(_ error: any Error, env: JNIEnvPointer) -> JavaObjectPointer {
    let throwable = try! Java_errorExceptionClass.create(ctor: Java_errorException_init_methodID, args: [String(describing: error).toJavaParameter()])
    return throwable
}

private let Java_errorExceptionClass = try! JClass(name: "skip/lib/ErrorException")
private let Java_errorException_init_methodID = Java_errorExceptionClass.getMethodID(name: "<init>", sig: "(Ljava/lang/String;)V")!
