import SkipBridge

public class MathBridge : SkipBridge {
    /// This is a normal transpiled function; it exists in both the Swift and Java worlds, and does NOT bridge through JNI.
    public func callPurePOW(_ value: Double, power: Double) -> Double {
        var result = 1.0
        for _ in 0..<Int64(power) {
            result = result * value
        }
        return result
    }

    /// This function is POW implemented in Java. It can be called from either Java or Swift.
    ///
    /// Calling it from Java will invoke it directly,
    /// and calling it from Swift will invoke it through a transpiler-generated JNI implementation of `invokeJava` (see below).
    public func callJavaPOW(_ value: Double, power: Double) throws -> Double {
        return try invokeJava(value, power) {
            #if SKIP
            return java.lang.Math.pow(value, power)
            #endif
        }
    }

    /// Calling this function from Swift will simply invoke the block directly.
    /// When called through the transpiled Kotlin, this function will be invoked through a `@_cdecl` shim function via JNI.
    public func callSwiftPOW(_ value: Double, power: Double) -> Double {
        // skipstone will replace `invokeSwift` call with `invokeSwift_callSwiftPOW(value, power)`, which it will also generate (see below)
        // SKIP REPLACE: return withSwiftBridge { invokeSwift_callSwiftPOW(value, power) }
        return invokeSwift(value, power) {
            #if !SKIP
            return Darwin.pow(value, power)
            #endif
        }
    }

    public func callJavaThrowing(message: String) throws {
        try invokeJavaVoid(message) {
            #if SKIP
            throw MathError(description: message)
            #endif
        }
    }

    public func callSwiftThrowing(message: String) throws {
        // SKIP REPLACE: { checkSwiftErrorVoid { -> withSwiftBridge { invokeSwift_callSwiftThrowing(message) } } }()
        try invokeSwiftVoid(message) {
            #if !SKIP
            throw MathError(description: message)
            #endif
        }
    }
}

public struct MathError: Error, CustomStringConvertible {
    public var description: String

    public init(description: String) {
        self.description = description
    }
}
