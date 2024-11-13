// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP @BridgeToSwift
public class KotlinHelperClass: KotlinProtocol {
    public var stringVar = "s"

    public init() {
    }

    public func stringValue() -> String {
        return stringVar
    }

    public static func ==(lhs: KotlinHelperClass, rhs: KotlinHelperClass) -> Bool {
        return lhs.stringVar == rhs.stringVar
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringVar)
    }
}

// SKIP @BridgeToSwift
public protocol KotlinProtocol: Hashable {
    func stringValue() -> String
}

// SKIP @BridgeToSwift
public struct KotlinStruct {
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
