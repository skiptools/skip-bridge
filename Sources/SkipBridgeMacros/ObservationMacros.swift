// Copyright 2024 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// These are slightly modified versions of the SwiftLang Observation macros:
// `main` on 2024-10-16:
// https://github.com/swiftlang/swift/blob/main/lib/Macros/Sources/ObservationMacros/ObservableMacro.swift

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import SwiftSyntaxBuilder

public struct BridgeObservableMacro {
    static let moduleName = "Observation"
    static let bridgeModuleName = "SkipBridge"

    static let conformanceName = "Observable"
    static var qualifiedConformanceName: String {
        return "\(moduleName).\(conformanceName)"
    }
    
    static var observableConformanceType: TypeSyntax {
        "\(raw: qualifiedConformanceName)"
    }
    
    static let registrarTypeName = "ObservationRegistrar"
    static var qualifiedRegistrarTypeName: String {
        return "\(moduleName).\(registrarTypeName)"
    }
    static let bridgeRegistrarTypeName = "BridgeObservationRegistrar"
    static var qualifiedBridgeRegistrarTypeName: String {
        return "\(bridgeModuleName).\(bridgeRegistrarTypeName)"
    }
    
    static let trackedMacroName = "BridgeObservationTracked"
    static let ignoredMacroName = "BridgeObservationIgnored"

    static let registrarVariableName = "_$observationRegistrar"
    static let bridgeRegistrarVariableName = "_$bridgeObservationRegistrar"

    static func registrarVariable(_ observableType: TokenSyntax) -> DeclSyntax {
        return
      """
      @\(raw: ignoredMacroName) private let \(raw: registrarVariableName) = \(raw: qualifiedRegistrarTypeName)()
      """
    }
    static func bridgeRegistrarVariable(_ observableType: TokenSyntax, propertyNames: [String]) -> DeclSyntax {
        let propertyNamesString = propertyNames
            .map { "\"\($0)\"" }
            .joined(separator: ", ")
        return
      """
      @\(raw: ignoredMacroName) private let \(raw: bridgeRegistrarVariableName) = \(raw: qualifiedBridgeRegistrarTypeName)(for: [\(raw: propertyNamesString)])
      """
    }
    
    static func accessFunction(_ observableType: TokenSyntax) -> DeclSyntax {
        return
      """
      internal nonisolated func access<Member>(
      keyPath: KeyPath<\(observableType), Member>
      ) {
      \(raw: registrarVariableName).access(self, keyPath: keyPath)
      }
      """
    }
    
    static func withMutationFunction(_ observableType: TokenSyntax) -> DeclSyntax {
        return
      """
      internal nonisolated func withMutation<Member, MutationResult>(
      keyPath: KeyPath<\(observableType), Member>,
      _ mutation: () throws -> MutationResult
      ) rethrows -> MutationResult {
      try \(raw: registrarVariableName).withMutation(of: self, keyPath: keyPath, mutation)
      }
      """
    }
    
    static var ignoredAttribute: AttributeSyntax {
        AttributeSyntax(
            leadingTrivia: .space,
            atSign: .atSignToken(),
            attributeName: IdentifierTypeSyntax(name: .identifier(ignoredMacroName)),
            trailingTrivia: .space
        )
    }
}

struct ObservationDiagnostic: DiagnosticMessage {
    enum ID: String {
        case invalidApplication = "invalid type"
        case missingInitializer = "missing initializer"
    }
    
    var message: String
    var diagnosticID: MessageID
    var severity: DiagnosticSeverity
    
    init(message: String, diagnosticID: SwiftDiagnostics.MessageID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = diagnosticID
        self.severity = severity
    }
    
    init(message: String, domain: String, id: ID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = MessageID(domain: domain, id: id.rawValue)
        self.severity = severity
    }
}

extension DiagnosticsError {
    init<S: SyntaxProtocol>(syntax: S, message: String, domain: String = "Observation", id: ObservationDiagnostic.ID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.init(diagnostics: [
            Diagnostic(node: Syntax(syntax), message: ObservationDiagnostic(message: message, domain: domain, id: id, severity: severity))
        ])
    }
}

extension DeclModifierListSyntax {
    func privatePrefixed(_ prefix: String) -> DeclModifierListSyntax {
        let modifier: DeclModifierSyntax = DeclModifierSyntax(name: "private", trailingTrivia: .space)
        return [modifier] + filter {
            switch $0.name.tokenKind {
            case .keyword(let keyword):
                switch keyword {
                case .fileprivate: fallthrough
                case .private: fallthrough
                case .internal: fallthrough
                case .package: fallthrough
                case .public:
                    return false
                default:
                    return true
                }
            default:
                return true
            }
        }
    }
    
    init(keyword: Keyword) {
        self.init([DeclModifierSyntax(name: .keyword(keyword))])
    }
}

extension TokenSyntax {
    func privatePrefixed(_ prefix: String) -> TokenSyntax {
        switch tokenKind {
        case .identifier(let identifier):
            return TokenSyntax(.identifier(prefix + identifier), leadingTrivia: leadingTrivia, trailingTrivia: trailingTrivia, presence: presence)
        default:
            return self
        }
    }
}

extension PatternBindingListSyntax {
    func privatePrefixed(_ prefix: String) -> PatternBindingListSyntax {
        var bindings = self.map { $0 }
        for index in 0..<bindings.count {
            let binding = bindings[index]
            if let identifier = binding.pattern.as(IdentifierPatternSyntax.self) {
                bindings[index] = PatternBindingSyntax(
                    leadingTrivia: binding.leadingTrivia,
                    pattern: IdentifierPatternSyntax(
                        leadingTrivia: identifier.leadingTrivia,
                        identifier: identifier.identifier.privatePrefixed(prefix),
                        trailingTrivia: identifier.trailingTrivia
                    ),
                    typeAnnotation: binding.typeAnnotation,
                    initializer: binding.initializer,
                    accessorBlock: binding.accessorBlock,
                    trailingComma: binding.trailingComma,
                    trailingTrivia: binding.trailingTrivia)
                
            }
        }
        
        return PatternBindingListSyntax(bindings)
    }
}

extension VariableDeclSyntax {
    func privatePrefixed(_ prefix: String, addingAttribute attribute: AttributeSyntax) -> VariableDeclSyntax {
        let newAttributes = attributes + [.attribute(attribute)]
        return VariableDeclSyntax(
            leadingTrivia: leadingTrivia,
            attributes: newAttributes,
            modifiers: modifiers.privatePrefixed(prefix),
            bindingSpecifier: TokenSyntax(bindingSpecifier.tokenKind, leadingTrivia: .space, trailingTrivia: .space, presence: .present),
            bindings: bindings.privatePrefixed(prefix),
            trailingTrivia: trailingTrivia
        )
    }
    
    var isValidForObservation: Bool {
        !isComputed && isInstance && !isImmutable && identifier != nil
    }

}

extension DeclGroupSyntax {
    var bridgeObservationVariableNames: [String] {
        return definedVariables.compactMap { property in
            return property.isValidForObservation &&  !property.hasMacroApplication(BridgeObservableMacro.ignoredMacroName) ? property.identifier?.trimmed.text : nil
        }
    }
}

extension BridgeObservableMacro: MemberMacro {
    public static func expansion<
        Declaration: DeclGroupSyntax,
        Context: MacroExpansionContext
    >(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let identified = declaration.asProtocol(NamedDeclSyntax.self) else {
            return []
        }
        
        let observableType = identified.name.trimmed
        
        if declaration.isEnum {
            // enumerations cannot store properties
            throw DiagnosticsError(syntax: node, message: "'@BridgeObservable' cannot be applied to enumeration type '\(observableType.text)'", id: .invalidApplication)
        }
        if declaration.isStruct {
            // structs are not yet supported; copying/mutation semantics tbd
            throw DiagnosticsError(syntax: node, message: "'@BridgeObservable' cannot be applied to struct type '\(observableType.text)'", id: .invalidApplication)
        }
        if declaration.isActor {
            // actors cannot yet be supported for their isolation
            throw DiagnosticsError(syntax: node, message: "'@BridgeObservable' cannot be applied to actor type '\(observableType.text)'", id: .invalidApplication)
        }
        
        var declarations = [DeclSyntax]()
        
        declaration.addIfNeeded(BridgeObservableMacro.bridgeRegistrarVariable(observableType, propertyNames: declaration.bridgeObservationVariableNames), to: &declarations)
        #if canImport(Observation)
        declaration.addIfNeeded(BridgeObservableMacro.registrarVariable(observableType), to: &declarations)
        declaration.addIfNeeded(BridgeObservableMacro.accessFunction(observableType), to: &declarations)
        declaration.addIfNeeded(BridgeObservableMacro.withMutationFunction(observableType), to: &declarations)
        #endif

        return declarations
    }
}

extension BridgeObservableMacro: MemberAttributeMacro {
    public static func expansion<
        Declaration: DeclGroupSyntax,
        MemberDeclaration: DeclSyntaxProtocol,
        Context: MacroExpansionContext
    >(
        of node: AttributeSyntax,
        attachedTo declaration: Declaration,
        providingAttributesFor member: MemberDeclaration,
        in context: Context
    ) throws -> [AttributeSyntax] {
        guard let property = member.as(VariableDeclSyntax.self), property.isValidForObservation,
              property.identifier != nil else {
            return []
        }
        
        // dont apply to ignored properties or properties that are already flagged as tracked
        if property.hasMacroApplication(BridgeObservableMacro.ignoredMacroName) ||
            property.hasMacroApplication(BridgeObservableMacro.trackedMacroName) {
            return []
        }
        
        
        return [
            AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier(BridgeObservableMacro.trackedMacroName)))
        ]
    }
}

extension BridgeObservableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // This method can be called twice - first with an empty `protocols` when
        // no conformance is needed, and second with a `MissingTypeSyntax` instance.
        if protocols.isEmpty {
            return []
        }
        
        #if canImport(Observation)
        let decl: DeclSyntax = """
        extension \(raw: type.trimmedDescription): \(raw: qualifiedConformanceName) {}
        """
        let ext = decl.cast(ExtensionDeclSyntax.self)
        
        if let availability = declaration.attributes.availability {
            return [ext.with(\.attributes, availability)]
        } else {
            return [ext]
        }
        #else
        return []
        #endif
    }
}

public struct BridgeObservationTrackedMacro: AccessorMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] {
        guard let property = declaration.as(VariableDeclSyntax.self),
              property.isValidForObservation,
              let identifier = property.identifier?.trimmed else {
            return []
        }
        
        if property.hasMacroApplication(BridgeObservableMacro.ignoredMacroName) {
            return []
        }
        
        let initAccessor: AccessorDeclSyntax =
      """
      @storageRestrictions(initializes: _\(identifier))
      init(initialValue) {
      _\(identifier) = initialValue
      }
      """

        #if canImport(Observation)
        let getAccessor: AccessorDeclSyntax =
      """
      get {
      access(keyPath: \\.\(identifier))
      \(raw: BridgeObservableMacro.bridgeRegistrarVariableName).access("\(identifier)")
      return _\(identifier)
      }
      """
        
        let setAccessor: AccessorDeclSyntax =
      """
      set {
      \(raw: BridgeObservableMacro.bridgeRegistrarVariableName).update("\(identifier)", _\(identifier), newValue)
      withMutation(keyPath: \\.\(identifier)) {
      _\(identifier) = newValue
      }
      }
      """
        #else

        let getAccessor: AccessorDeclSyntax =
      """
      get {
      \(raw: BridgeObservableMacro.bridgeRegistrarVariableName).access("\(identifier)")
      return _\(identifier)
      }
      """

        let setAccessor: AccessorDeclSyntax =
      """
      set {
      \(raw: BridgeObservableMacro.bridgeRegistrarVariableName).update("\(identifier)", _\(identifier), newValue)
      _\(identifier) = newValue
      }
      """
        #endif

        //    let modifyAccessor: AccessorDeclSyntax =
        //      """
        //      _modify {
        //      access(keyPath: \\.\(identifier))
        //      \(raw: BridgeObservableMacro.registrarVariableName).willSet(self, keyPath: \\.\(identifier))
        //      defer { \(raw: BridgeObservableMacro.registrarVariableName).didSet(self, keyPath: \\.\(identifier)) }
        //      yield &_\(identifier)
        //      }
        //      """
        
        return [initAccessor, getAccessor, setAccessor, /* modifyAccessor */]
    }
}

extension BridgeObservationTrackedMacro: PeerMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let property = declaration.as(VariableDeclSyntax.self),
              property.isValidForObservation else {
            return []
        }
        
        if property.hasMacroApplication(BridgeObservableMacro.ignoredMacroName) ||
            property.hasMacroApplication(BridgeObservableMacro.trackedMacroName) {
            return []
        }
        
        let storage = DeclSyntax(property.privatePrefixed("_", addingAttribute: BridgeObservableMacro.ignoredAttribute))
        return [storage]
    }
}

package struct BridgeObservationIgnoredMacro: AccessorMacro {
    package static func expansion(of node: AttributeSyntax, providingAccessorsOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AccessorDeclSyntax] {
        return []
    }
}
