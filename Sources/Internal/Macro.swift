import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct AccessibilityIdentifierGenerationMacro: MemberMacro {
  public enum MacroDiagnostic: String, DiagnosticMessage {
    case requiresStructOrClass = "#AccessibilityIdentifier requires a struct or class"
    case requiresIdentifierBindings =
      "#AccessibilityIdentifier requires stored properties with identifier patterns"

    public var message: String { rawValue }

    public var diagnosticID: MessageID {
      MessageID(domain: "AccessibilityIdentifier", id: rawValue)
    }

    public var severity: DiagnosticSeverity { .error }
  }

  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let name = declaration.classOrStructName,
      let memberBlock = declaration.classOrStructMemberBlock
    else {
      let diagnostic = Diagnostic(
        node: Syntax(attribute),
        message: MacroDiagnostic.requiresStructOrClass
      )
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let propertyPatterns = memberBlock.members
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

    let propertyNames =
      propertyPatterns
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
