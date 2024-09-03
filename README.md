## SkipJNI

SkipJNI provides a Swift interface to the standard C JNI bindings, enabling a 
Swift program to load classes and execute methods instances in a
Java Virtual Machine running in the same process space.

## SkipBridge

SkipBridge provides bridging between Swift and Java, enabling bi-directional
communication between the two languages. A bridge is a subclass of `SkipBridge`
that can encapsulate state for either the Java side, or the Swift side, 
or both.

A bridge is transpiled into Kotlin by the skipstone plugin, and the API
it provides can be used in the same way from either the Swift side or the Kotlin side.
Each instance of the bridge, regardless of which side it was created on,
holds a reference to a "peer" on the other side of the bridge: the Java side
has a `_swiftPeer` property, which is a longint pointer value for the Swift class instance,
and the Swift side has a `_javaPeer` property, which is a JNI jobject reference to the Java instance.

### Swift->Java Bridge

`JavaFileBridge` is an example of a bridge that holds state on the Java
side of the bridge, an instance of `java.io.File`, and provides a single
function `exists()` that checks whether the file exists. The function is
implemented by wrapping the call to the Java `File.exists()` function
inside a block passed to `invokeJava`. When called from the Java side,
`invokeJava` simply executes the closure directly and returns the result.

At build time, the skipstone plugin will
augment the `JavaFileBridge.swift` type with an extension that implements
this `invokeJava` call by making the necessary JNI calls into the Java side
of the bridge, calling the `exists()` function and returning the value.

```swift
import SkipBridge

/// An example of a bridge that manages a `java.io.File` on the Java side and bridges functions to Swift.
public class JavaFileBridge : SkipBridge {
    #if SKIP
    private var file: java.io.File!
    #endif

    public convenience init(filePath: String) throws {
        try self.init()
        try setFilePath(filePath)
    }

    public func setFilePath(_ filePath: String) throws {
        try invokeJavaVoid(filePath) {
            #if SKIP
            self.file = java.io.File(filePath)
            #endif
        }
    }

    public func exists() throws -> Bool {
        try invokeJava() {
            #if SKIP
            self.file.exists()
            #endif
        }
    }
}
```

The `exists()` invocation will be handled with the following generated code:

```swift
extension JavaFileBridge {
    public func invokeJava<T: SkipBridgable>(functionName: String = #function, _ args: SkipBridgable..., implementation: () throws -> ()) throws -> T {
        switch functionName {
        case "exists()":
            return try callJavaT(functionName: "exists", signature: "()Z", arguments: args)
        default:
            fatalError("could not identify which function called invokeJava for: \(functionName)")
        }
    }

    private func callJavaT<T>(functionName: String, signature: String, arguments args: [SkipBridgable], invoke: (JObject, JavaMethodID, [JavaParameter]) throws -> T) throws -> T {
        let jobj: JavaObjectPointer = self._javaPeer
        let mid = jobj.jclass.getMethodID(name: functionName, sig: signature)
        let jargs = args.map({ $0.toJavaParameter() })
        return try jobj.call(method: mid, jargs)
    }
}
```


### Java->Swift Bridge

`SwiftURLBridge` is an example of a bridge that holds state on the Swift
side of the bridge, an instance of `Foundation.URL`, and provides a single
function `isFileURL()` that checks whether the URL is a file URL. The function is
implemented by wrapping the call to the Swift `URL.isFileURL` property
inside a block passed to `invokeSwift`. When called from the Swift side,
`invokeSwift` simply executes the closure directly and returns the result.

At build time, the skipstone plugin will
augment the transpiled `SwiftURLBridge.kt` type with an implementation of
this `invokeSwift` call by making the necessary JNI calls into the Swift side
of the bridge, calling the `isFileURL()` function and returning the value.
It does this by implementing native `external` functions on the Kotlin side,
along with the paired Swift functions with the matching `@_cdecl` JNI signature.

```swift
import SkipBridge

/// An example of a bridge that manages a `Foundation.URL` on the Swift side and bridges functions to Java.
public class SwiftURLBridge : SkipBridge {
    #if !SKIP
    internal var url: Foundation.URL!
    #endif

    public convenience init(urlString: String) throws {
        try self.init()
        try setURLString(urlString)
    }

    internal func setURLString(_ urlString: String) throws {
        invokeSwiftVoid(urlString) {
            #if !SKIP
            self.url = Foundation.URL(string: urlString)
            #endif
        }
    }

    public func isFileURL() -> Bool {
        invokeSwift() {
            #if !SKIP
            self.url.isFileURL
            #endif
        }
    }
}
```

The transpilation will replace the `invokeSwift` call in the `isFileURL()` function body with a call to `invokeSwift_isFileURL()`, whose implementation will look like:

```swift
#if SKIP
public extension SwiftURLBridge {
    /* SKIP EXTERN */ func invokeSwift_isFileURL(_ swiftPeer: SwiftObjectPointer) -> Bool { }
}
#else
@_cdecl("Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL__J")
internal func Java_skip_bridge_samples_SwiftURLBridge_invokeSwift_1isFileURL__J(_ env: JNIEnvPointer, _ obj: JavaObjectPointer?, _ swiftPointer: JavaLong) -> Bool {
    let bridge: SwiftURLBridge = swiftPeer(for: swiftPointer)
    return bridge.isFileURL()
}
#endif
```

The transpiled Kotlin will ultimately look like:

```kotlin
package skip.bridge.samples

import skip.lib.*
import skip.bridge.*

/// An example of a bridge that manages a `Foundation.URL` on the Swift side and bridges functions to Java.
open class SwiftURLBridge: SkipBridge {
    constructor(urlString: String): this() {
        setURLString(urlString)
    }

    internal open fun setURLString(urlString: String): Unit = invokeSwift_setURLString(_swiftPeer, urlString)
    open external fun invokeSwift_setURLString(swiftPeer: Long, value: String)

    open fun isFileURL(): Boolean = invokeSwift_isFileURL(_swiftPeer)
    open external fun invokeSwift_isFileURL(swiftPeer: Long): Boolean
}
```

### Bridging Topics

#### Bridgeable parameters and return values

Any bridged function parameters and return values must be either a primitive or String
that is handled by JNI, with the following mapping:

| Swift  | Java    |
|--------|---------|
| Int8   | jbyte   |
| Int16  | jshort  |
| UInt16 | jchar   |
| Int32  | jint    |
| Int64  | jlong   |
| Float  | jfloat  |
| Double | jdouble |
| String | jstring |

In addition, other types that extend `SkipBridge` can be passed as parameters or
used as return values.

#### Bridge lifecycle and memory management

Each side of the Swift/Java bridge holds a "peer", which is a reference to the
other side of the bridge. A bridge must have a single no-argument constructor,
which, when invoked from one side of the bridge, will be responsible for allocating
the other side of the bridge.

TBD: should the Swift peer always be retained as long as the Java peer? If not,
a Swift instance could be deallocated while the Java side is still awaiting garbage
collection.

#### Throwable

When invoking a Java function from Swift, JNI can be used to check whether
an exception happened during the call using the
[ExceptionOccurred](https://docs.oracle.com/javase/8/docs/technotes/guides/jni/spec/functions.html#ExceptionOccurred)
function, which can then be converted into a Swift exception.

There is no such affordance when going from Java to Swift/C, so any potentially-throwing
Swift functions should use the `handleSwiftError` utility function in their `@_cdecl`
implementation, which will try to execute the function, and if it fails, invoke
`pushSwiftError`, which will store the exception in a thread-local variable.
From the Java side, this error can be checked with the `popSwiftErrorMessageFromStack()`
function, which will check whether an error occurred as a result of the most
recent invocation, and if so, convert it into a Swift error.

#### Static functions

Static functions are implemented similarly to instance functions, with the exception
that since the Java side is transpiled Kotlin (unannotated by `@JvmStatic`),
the Swift invocation side needs to look up the `Companion` instance of the
Java class and invoke the method on the companion.

#### Closure parameters and return values?

**TBD**: How to handle closures. Possibly with a
`SwiftCallback` and `JavaCallback` bridging class that
wraps a closure on the Swift and Kotlin sides. But how
to support multiple parameters to the specified callback?
With `SwiftCallback2`, `SwiftCallback3`, etc?

#### Async/await + coroutines

**TBD**: How will Java calling to Swift async functions, and
how will Swift call into Kotlin coroutines? One possibility
is to use `withCheckedThrowingContinuation` on the Swift
side and `suspendCoroutine` on the Kotlin side with a
`completion` callback bridge wrapper.

#### @Composable functions

**TBD**: If this bridging system is to be used for Compose integration,
how will @Composable functions be supported?

#### Bridge subclassing and extending

**TBD**: Should bridges be allowed to subclassed, or should they have to
be `final`? Similarly, should bridge class be able to have extensions,
either in the same module or in external modules?
