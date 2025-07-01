import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// A macro that creates an Identifier struct that contains accessibility identifiers
// for all the properties of the object this is applied to.
// Can be used in UI Testing.
public struct AccessibilityIdentifierGenerationMacro: MemberMacro {
  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let name = declaration.as(ClassDeclSyntax.self)?.name.description ?? declaration.as(StructDeclSyntax.self)!.name.description

    let classMemberBlock: MemberBlockSyntax? = declaration.as(ClassDeclSyntax.self)?.memberBlock

    let structMemberBlock: MemberBlockSyntax? = declaration.as(StructDeclSyntax.self)?.memberBlock

    let propertyNames = (classMemberBlock ?? structMemberBlock!).members
      .compactMap { $0 }
      .map(\.decl)
      .compactMap { $0.as(VariableDeclSyntax.self) }
      .compactMap(\.bindings.first?.pattern)
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

@main
struct AccessibilityIdentifierPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    AccessibilityIdentifierGenerationMacro.self
  ]
}
