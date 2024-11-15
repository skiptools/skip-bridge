// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if compiler(>=6.0)
#if canImport(Observation)
import Observation

@available(macOS 14, iOS 17, *)
@Observable
public class ObservedClass {
    public var i = 1
    public var array: [String]?
}

#endif
#endif
