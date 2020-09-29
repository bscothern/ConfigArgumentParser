// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConfigArgumentParserExamples",
    products: [
        .executable(
            name: "ExampleDefault",
            targets: ["ExampleDefault"]
        )
    ],
     dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.1")),
        .package(name: "ConfigArgumentParser", path: ".."),
    ],
    targets: [
        .target(
            name: "ExampleDefault",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ConfigArgumentParser", package: "ConfigArgumentParser"),
            ]
        )
    ]
)
