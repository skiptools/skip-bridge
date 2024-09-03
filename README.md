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
has a `swiftPeer`, and the Swift side has a `javaPeer`.

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

The transpilation will replace the `isFileURL()` function body with a call to `invokeSwift_isFileURL()`, whose implementation will look like:

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

