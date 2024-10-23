// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import CJNI
import Foundation

public struct Observation {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    public struct ObservationRegistrar: Sendable, Equatable, Hashable {
        private let registrar = ObservationModule.ObservationRegistrarType()
        private let bridgeSupport = BridgeObservationSupport()

        public init() {
        }

        public func access<Subject, Member>(_ subject: Subject, keyPath: KeyPath<Subject, Member>) where Subject : Observable {
            bridgeSupport.access(subject, keyPath: keyPath)
            registrar.access(subject, keyPath: keyPath)
        }

        public func willSet<Subject, Member>(_ subject: Subject, keyPath: KeyPath<Subject, Member>) where Subject : Observable {
            bridgeSupport.willSet(subject, keyPath: keyPath)
            registrar.willSet(subject, keyPath: keyPath)
        }

        public func didSet<Subject, Member>(_ subject: Subject, keyPath: KeyPath<Subject, Member>) where Subject : Observable {
            registrar.didSet(subject, keyPath: keyPath)
        }

        public func withMutation<Subject, Member, T>(of subject: Subject, keyPath: KeyPath<Subject, Member>, _ mutation: () throws -> T) rethrows -> T where Subject : Observable {
            bridgeSupport.willSet(subject, keyPath: keyPath)
            return try registrar.withMutation(of: subject, keyPath: keyPath, mutation)
        }

        public static func ==(_: Self, _: Self) -> Bool {
            return true
        }

        public func hash(into hasher: inout Hasher) {
        }

        public init(from decoder: any Decoder) throws {
        }

        public func encode(to encoder: any Encoder) throws {
        }
    }

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    public typealias Observable = ObservationModule.ObservableType

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    public func withObservationTracking<T>(_ apply: () -> T, onChange: @autoclosure () -> @Sendable () -> Void) -> T {
        return ObservationModule.withObservationTrackingFunc(apply, onChange: onChange())
    }
}

private final class BridgeObservationSupport: @unchecked Sendable {
    init() {
    }

    public func access<Subject, Member>(_ subject: Subject, keyPath: KeyPath<Subject, Member>) {
        guard subject is BridgedToKotlin else {
            return
        }
        let index = Java_init(forKeyPath: keyPath)
        Java_access(index)
    }

    public func willSet<Subject, Member>(_ subject: Subject, keyPath: KeyPath<Subject, Member>) {
        guard subject is BridgedToKotlin else {
            return
        }
        let index = Java_init(forKeyPath: keyPath)
        Java_update(index)
    }

    #if SKIP_JNI_MODE
    private static let Java_stateClass = try? JClass(name: "skip/model/MutableStateBacking")
    private static let Java_state_init_methodID = Java_stateClass?.getMethodID(name: "<init>", sig: "()V")
    private static let Java_state_access_methodID = Java_stateClass?.getMethodID(name: "access", sig: "(I)V")
    private static let Java_state_update_methodID = Java_stateClass?.getMethodID(name: "update", sig: "(I)V")

    private var Java_peer: JObject?
    private var Java_hasInitialized = false

    private func Java_init(forKeyPath keyPath: AnyKeyPath) -> Int {
        lock.lock()
        defer { lock.unlock() }
        if !Java_hasInitialized {
            Java_hasInitialized = true
            Java_peer = Java_initPeer()
        }
        guard Java_peer != nil else {
            return 0
        }
        return index(forKeyPath: keyPath)
    }

    private func Java_initPeer() -> JObject? {
        guard let cls = Self.Java_stateClass, let initMethod = Self.Java_state_init_methodID else {
            return nil
        }
        let ptr: JavaObjectPointer = try! cls.create(ctor: initMethod, args: [])
        return JObject(ptr)
    }

    private func Java_access(_ index: Int) {
        guard let peer = Java_peer, let accessMethod = Self.Java_state_access_methodID else {
            return
        }
        try! peer.call(method: accessMethod, args: [Int32(index).toJavaParameter()])
    }

    private func Java_update(_ index: Int) {
        guard let peer = Java_peer, let updateMethod = Self.Java_state_update_methodID else {
            return
        }
        try! peer.call(method: updateMethod, args: [Int32(index).toJavaParameter()])
    }

    private let lock = NSLock()
    private var indexes: [AnyKeyPath: Int] = [:]

    private func index(forKeyPath keyPath: AnyKeyPath) -> Int {
        if let index = indexes[keyPath] {
            return index
        }
        let nextIndex = indexes.count
        indexes[keyPath] = nextIndex
        return nextIndex
    }
    #else

    private func Java_init(forKeyPath: AnyKeyPath) -> Int {
        return 0
    }

    private func Java_access(_ index: Int) {
    }

    private func Java_update(_ index: Int) {
    }
    #endif
}
#endif
