internal import SwiftSyntaxMacrosGenericTestSupport
internal import Testing

#if canImport(AccessibilityIdentifierMacros)
  import AccessibilityIdentifierMacros

  @Suite
  struct AccessibilityIdentifierDiagnosticsTests {
    @Test func enumThrowsError() {
      assertMacroExpansion(
        """
        @AccessibilityIdentifier
        enum SomeEnum {}
        """,
        expandedSource: """
          enum SomeEnum {}
          """,
        diagnostics: [
          .init(
            message: AccessibilityIdentifierGenerationMacro.MacroDiagnostic.requiresStructOrClass
              .message,
            line: 1,
            column: 1
          )
        ],
        macros: testMacros
      )
    }

    @Test func tupleBindingThrowsError() {
      assertMacroExpansion(
        """
        @AccessibilityIdentifier
        struct Widget {
          let (a, b): (Int, Int)
        }
        """,
        expandedSource: """
          struct Widget {
            let (a, b): (Int, Int)
          }
          """,
        diagnostics: [
          .init(
            message: AccessibilityIdentifierGenerationMacro.MacroDiagnostic
              .requiresIdentifierBindings.message,
            line: 1,
            column: 1
          )
        ],
        macros: testMacros
      )
    }
  }
#endif
