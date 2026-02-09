# swift-macro-accessibilityIdentifier
`AccessibilityIdentifier` is a Swift macro that generates a type-safe namespace of accessibility identifiers from stored properties on a class or struct. It removes the need to manually keep string identifiers in sync and makes UI tests and audits more reliable.

## Features

- **Automatic Identifier Generation:** Generates static `String` properties for accessibility identifiers based on your stored properties.
- **Improved Testability:** Provides a clear, type-safe way to reference accessibility identifiers in UI tests (e.g., using XCUITest).
- **Reduced Boilerplate:** Eliminates manual string declaration and potential for typos.
- **Compile-Time Safety:** Ensures identifiers are valid and consistent during compilation.

## Installation

Add the `AccessibilityIdentifier` package to your `Package.swift` dependencies and include the product in your target:

```swift
dependencies: [
  .package(url: "https://github.com/YOUR_USERNAME/swift-macro-accessibilityIdentifier.git", from: "1.0.0"),
],
targets: [
  .target(
    name: "YourApp",
    dependencies: [
      .product(name: "AccessibilityIdentifier", package: "swift-macro-accessibilityIdentifier"),
    ]
  )
]
```

## Usage

Annotate a class or struct with `@AccessibilityIdentifier`. The macro will generate a nested `Identifiers` struct at compile time. This example is taken from the test fixture in this repo.

### Input

```swift
@AccessibilityIdentifier
class MyViewController: UIViewController {
  var aButton: UIButton { UIButton() }
  lazy var aTextField = UITextField()
  let aLabel = UILabel()
}
```

### Expanded Output

```swift
class MyViewController: UIViewController {
  var aButton: UIButton { UIButton() }
  lazy var aTextField = UITextField()
  let aLabel = UILabel()

  public struct Identifiers {
    public static let namespace = "MyViewController"

    public static let aButton = "MyViewController.aButton"
    public static let aTextField = "MyViewController.aTextField"
    public static let aLabel = "MyViewController.aLabel"
  }
}
```

You can now reference identifiers like:

```swift
view.accessibilityIdentifier = MyViewController.Identifiers.aButton
```

## Notes

- The macro must be applied to a `class` or `struct`.
- Each stored property must use a simple identifier pattern (e.g., `let foo = ...`, `var bar: Type`, `lazy var baz = ...`).
