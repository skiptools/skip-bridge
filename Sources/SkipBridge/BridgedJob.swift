// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftJNI

/// The `kotlinx.coroutines.Job` running a bridged `async throws` call.
///
/// Generated Swift awaits the Kotlin `callback_` function inside `withTaskCancellationHandler` and
/// attaches the job it returns. Cancelling the awaiting Swift task cancels the job, so a Kotlin
/// implementation suspended in e.g. `suspendCancellableCoroutine` observes the cancellation
/// instead of running to completion.
public final class BridgedJob: @unchecked Sendable {
    private let lock = NSLock()
    private var job: JObject?
    private var isCancelled = false

    public init() {
    }

    /// Adopt the job returned by the Kotlin `callback_` function, cancelling it if the awaiting task was already cancelled.
    public func attach(_ ptr: JavaObjectPointer) {
        let job = JObject(ptr)
        lock.lock()
        self.job = job
        let cancelNow = isCancelled
        lock.unlock()
        if cancelNow {
            Self.cancel(job)
        }
    }

    public func cancel() {
        lock.lock()
        isCancelled = true
        let job = self.job
        lock.unlock()
        if let job {
            Self.cancel(job)
        }
    }

    /// The error to throw for a throwable delivered by the callback: `CancellationError` once the awaiting task cancelled the job.
    public func error(_ throwable: JavaObjectPointer, options: JConvertibleOptions) -> any Error {
        lock.lock()
        let isCancelled = self.isCancelled
        lock.unlock()
        if isCancelled {
            return CancellationError()
        }
        return JThrowable.toError(throwable, options: options)!
    }

    private static func cancel(_ job: JObject) {
        jniContext {
            _ = try? job.call(method: Java_Job_cancel_methodID, options: [], args: [JavaParameter(l: nil)])
        }
    }
}

private let Java_Job_class = try! JClass(name: "kotlinx/coroutines/Job")
private let Java_Job_cancel_methodID = Java_Job_class.getMethodID(name: "cancel", sig: "(Ljava/util/concurrent/CancellationException;)V")!
