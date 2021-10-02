// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// The names of the example projects to make with default settings
let names = [
    "example-default",
    "example-custom-flags1",
    "example-custom-flags2",
    "example-custom-flags3",
    "example-new-line-config-file-interpreter",
    "example-option-per-line-config-argument-interpreter",
    "example-space-config-file-interpreter",
    "example-all-custom",
    "example-auto-config-good",
    "example-auto-config-bad",
    "example-cli-override"
]

let products = names.map { name -> Product in
    .executable(
        name: name,
        targets: [name]
    )
}

let targets = names.map { name -> Target in
    .target(
        name: name,
        dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "ConfigArgumentParser", package: "ConfigArgumentParser")
        ]
    )
}

let package = Package(
    name: "ConfigArgumentParserExamples",
    platforms: [
        .macOS(.v10_12)
    ],
    products: products,
     dependencies: [
        .package(name: "ConfigArgumentParser", path: ".."),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.1")
     ],
     targets: targets
)
