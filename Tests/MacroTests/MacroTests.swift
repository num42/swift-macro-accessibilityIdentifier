internal import MacroTester
internal import SwiftSyntaxMacros
internal import SwiftSyntaxMacrosTestSupport
internal import Testing

#if canImport(AccessibilityIdentifierMacros)
  import AccessibilityIdentifierMacros

  let testMacros: [String: Macro.Type] = [
    "AccessibilityIdentifier": AccessibilityIdentifierGenerationMacro.self
  ]

  @Suite
  struct AccessibilityIdentifierMacroTests {
    @Test func myViewController() {
      MacroTester.testMacro(macros: testMacros)
    }
  }
#endif
