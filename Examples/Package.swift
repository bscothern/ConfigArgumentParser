// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// The source of truth of all examples that should be built.
let namesPath = "/" + #file.split(separator: "/").dropLast().joined(separator: "/") + "/Names.txt"

/// The names of the example projects to make with default settings
let names: Array = try! String(contentsOfFile: namesPath)
    .split(separator: "\n")
    .lazy
    // Filter out comments as denoted by a starting // which should never be used as a path anyways
    .filter { !$0.hasPrefix("//") }
    .map { line in
        String(line.split(separator: ",").first!)
    }

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
            .product(name: "ConfigArgumentParser", package: "ConfigArgumentParser"),
        ]
    )
}

let package = Package(
    name: "ConfigArgumentParserExamples",
    products: products,
     dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.1")),
        .package(name: "ConfigArgumentParser", path: ".."),
     ],
     targets: targets
)
