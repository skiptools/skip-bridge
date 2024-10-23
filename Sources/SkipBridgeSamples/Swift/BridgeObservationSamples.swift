// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if canImport(Observation)
import Observation
#endif

@available(macOS 14, *)
@Observable
class ObservedClass {
    var i = 1
    var array: [String]?
}
