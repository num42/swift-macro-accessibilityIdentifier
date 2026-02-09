import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

// A macro that creates an Identifier struct that contains accessibility identifiers
// for all the properties of the object this is applied to.
// Can be used in UI Testing.
public struct AccessibilityIdentifierGenerationMacro: MemberMacro {
  enum MacroDiagnostic: String, DiagnosticMessage {
    case requiresStructOrClass = "#AccessibilityIdentifier requires a struct or class"
    case requiresIdentifierBindings = "#AccessibilityIdentifier requires stored properties with identifier patterns"

    var message: String { rawValue }

    var diagnosticID: MessageID {
      MessageID(domain: "AccessibilityIdentifier", id: rawValue)
    }

    var severity: DiagnosticSeverity { .error }
  }

  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let classDeclaration = declaration.as(ClassDeclSyntax.self)
    let structDeclaration = declaration.as(StructDeclSyntax.self)

    guard let typeDeclaration = classDeclaration ?? structDeclaration else {
      let diagnostic = Diagnostic(
        node: Syntax(attribute),
        message: MacroDiagnostic.requiresStructOrClass
      )
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let name = typeDeclaration.name.description

    let classMemberBlock: MemberBlockSyntax? = declaration.as(ClassDeclSyntax.self)?.memberBlock

    let structMemberBlock: MemberBlockSyntax? = declaration.as(StructDeclSyntax.self)?.memberBlock

    let propertyPatterns = (classMemberBlock ?? structMemberBlock!).members
      .compactMap(\.decl)
      .compactMap { $0.as(VariableDeclSyntax.self) }
      .compactMap(\.bindings.first?.pattern)

    guard propertyPatterns.allSatisfy({ $0.is(IdentifierPatternSyntax.self) }) else {
      let diagnostic = Diagnostic(
        node: Syntax(attribute),
        message: MacroDiagnostic.requiresIdentifierBindings
      )
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let propertyNames = propertyPatterns
      .compactMap { $0.as(IdentifierPatternSyntax.self)!.identifier.description }
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

    let properties = propertyNames.map {
      "public static let \($0) = \"\(name).\($0)\""
    }

    return [
      """
      public struct Identifiers {
        public static let namespace = "\(raw: name)"

        \(raw: properties.joined(separator: "\n\n"))
      }
      """
    ]
  }
}
