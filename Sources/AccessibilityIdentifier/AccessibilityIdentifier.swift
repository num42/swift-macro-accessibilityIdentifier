@attached(member, names: arbitrary)
public macro AccessibilityIdentifier() = #externalMacro(
  module: "AccessibilityIdentifierMacros",
  type: "AccessibilityIdentifierGenerationMacro"
)
