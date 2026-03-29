// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
public class SwiftHelperClass: SwiftProtocol {
    public var id: String {
        return stringVar
    }
    public var stringVar = "s"

    public init() {
    }

    public func stringValue() -> String {
        return stringVar
    }

    public static func ==(lhs: SwiftHelperClass, rhs: SwiftHelperClass) -> Bool {
        return lhs.stringVar == rhs.stringVar
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringVar)
    }
}

public protocol SwiftProtocol: Hashable {
    func stringValue() -> String
}

public struct SwiftStruct {
    public var intVar = 1

    public init(string: String) {
        self.intVar = Int(string) ?? 0
    }

    public func intFunc() -> Int {
        return intVar
    }

    public mutating func setIntFunc(_ i: Int) {
        self.intVar = i
    }
}

