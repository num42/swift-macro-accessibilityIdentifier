# swift-macro-accessibilityIdentifier
This repository contains the `AccessibilityIdentifier` Swift Macro, designed to simplify the process of adding accessibility identifiers to your SwiftUI views. By using this macro, you can automatically generate static string properties for your view's accessibility identifiers, making UI testing and accessibility auditing much easier and more consistent.

## Features

- **Automatic Identifier Generation:** Generates static `String` properties for accessibility identifiers based on your enum cases.
- **Improved Testability:** Provides a clear, type-safe way to reference accessibility identifiers in UI tests (e.g., using XCUITest).
- **Reduced Boilerplate:** Eliminates manual string declaration and potential for typos.
- **Compile-Time Safety:** Ensures identifiers are valid and consistent during compilation.

## Installation

Add the `AccessibilityIdentifier` package to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/YOUR_USERNAME/swift-macro-accessibilityIdentifier.git", from: "1.0.0"), // Replace with your actual repo URL and version

