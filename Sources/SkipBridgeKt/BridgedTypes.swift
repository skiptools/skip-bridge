// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP

//
// NOTE:
// Keep this in sync with `SkipBridge.BridgedTypes`
//

/// Supported bridged type constants.
public enum BridgedTypes {
    case boolean_
    case byte_
    case char_
    case double_
    case float_
    case int_
    case long_
    case short_
    case string_

    case byteArray
    case date
    case list
    case locale
    case map
    case result
    case set
    case throwable
    case uuid
    case uri

    case swiftArray
    case swiftData
    case swiftDate
    case swiftDictionary
    case swiftLocale
    case swiftResult
    case swiftSet
    case swiftUUID
    case swiftURL

    case other
}

public func bridgedTypeOf(_ object: Any) -> BridgedTypes {
    // Likely most common case is a custom-bridged object
    guard !(object is SwiftProjecting) else {
        return .other
    }

    if object is Bool {
        return .boolean_
    } else if object is Int8 {
        return .byte_
    } else if object is Character {
        return .char_
    } else if object is Double {
        return .double_
    } else if object is Float {
        return .float_
    } else if object is Int {
        return .int_
    } else if object is Int64 {
        return .long_
    } else if object is Int16 {
        return .short_
    } else if object is String {
        return .string_
    }

    if object is kotlin.ByteArray {
        return .byteArray
    } else if object is java.util.Date {
        return .date
    } else if object is kotlin.collections.List<Any> {
        return .list
    } else if object is java.util.Locale {
        return .locale
    } else if object is kotlin.collections.Map<Any, Any> {
        return .map
    } else if object is kotlin.Result<Any> {
        return .result
    } else if object is kotlin.collections.Set<Any> {
        return .set
    } else if object is kotlin.Throwable {
        return .throwable
    } else if object is java.util.UUID {
        return .uuid
    } else if object is java.net.URI {
        return .uri
    }

    // Use class name so that we don't have a dependency on Skip libraries for these types
    // SKIP INSERT: val className = object_::class.java.name
    switch className {
    case "skip.lib.Array":
        return .swiftArray
    case "skip.foundation.Data":
        return .swiftData
    case "skip.foundation.Date":
        return .swiftDate
    case "skip.lib.Dictionary":
        return .swiftDictionary
    case "skip.foundation.Locale":
        return .swiftLocale
    case "skip.lib.Result":
        return .swiftResult
    case "skip.lib.Set":
        return .swiftSet
    default:
        return .other
    }
}

#endif
