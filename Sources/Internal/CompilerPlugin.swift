import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AccessibilityIdentifierPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    AccessibilityIdentifierGenerationMacro.self
  ]
}
