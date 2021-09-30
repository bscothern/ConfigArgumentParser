// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConfigArgumentParser",
    products: [
        .library(
            name: "ConfigArgumentParser",
            targets: ["ConfigArgumentParser"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "ConfigArgumentParser",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "ConfigArgumentParserTests",
            dependencies: [
                .target(name: "ConfigArgumentParser"),
            ]
        ),
    ]
)
