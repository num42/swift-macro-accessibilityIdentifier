import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(AccessibilityIdentifierMacros)
  import AccessibilityIdentifierMacros

  let testMacros: [String: Macro.Type] = [
    "AccessibilityIdentifier": AccessibilityIdentifierGenerationMacro.self
  ]

final class AccessibilityIdentifierGenerationMacroTests: XCTestCase {
  func testMyViewController() throws {
    testMacro(macros: testMacros)
  }
}

#endif
