import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

#if canImport(AccessibilityIdentifierMacros)
  import AccessibilityIdentifierMacros

  let testMacros: [String: Macro.Type] = [
    "AccessibilityIdentifier": AccessibilityIdentifierGenerationMacro.self
  ]

@Suite struct AccessibilityIdentifierGenerationMacroTests {
  @Test func myViewController() {
      MacroTester.testMacro(macros: testMacros)
  }
}
#endif
