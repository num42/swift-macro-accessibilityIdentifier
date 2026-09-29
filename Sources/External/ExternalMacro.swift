@attached(member, names: named(Identifiers))
public macro AccessibilityIdentifier() =
  #externalMacro(
    module: "AccessibilityIdentifierMacros",
    type: "AccessibilityIdentifierGenerationMacro"
  )
