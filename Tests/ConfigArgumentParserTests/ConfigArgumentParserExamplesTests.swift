import ConfigArgumentParser
import Foundation
import SystemPackage
import XCTest

/// This defines all test cases found in the Examples/Package.swift that should be run and tested with other arguments and configurations.
let detailedExampleTestCases: [DetailedExampleTestCase] = [
    // Test defaults
    .init(name: "example-default"),

    // Only change the custom flags
    .init(name: "example-custom-flags1", config: "test-custom-config", dryRun: "test-custom-dry-run"),
    .init(name: "example-custom-flags2", config: "test-custom-config"),
    .init(name: "example-custom-flags3", dryRun: "test-custom-config-dry-run"),

    // Only changing the interpreter to the specified one
    .init(name: "example-new-line-config-file-interpreter"),
    .init(name: "example-option-per-line-config-argument-interpreter"),
    .init(name: "example-space-config-file-interpreter"),

    // Testing both a change to the flags and interpreter
    .init(name: "example-all-custom", config: "foo", dryRun: "bar"),

    // Custom Flags Override (WIP)
//    .init(name: "example-cli-override", arguments: ["--times", "3", "42", "43", "44"]),
]

/// Defines all test cases that should be run with no additional arguments
let simpleExampleTestCases: [SimpleExampleTestCase] = [
    .init(name: "example-auto-config-good", isSuccessful: true, arguments: ["--auto-config"]),
    .init(name: "example-auto-config-bad", isSuccessful: false, arguments: ["--auto-config"]),
]

protocol ExampleTestCase {
    /// The name of the example to run.
    var name: String { get }
    /// Other arguments to pass to the executable
    var arguments: [String] { get }
}

struct DetailedExampleTestCase: ExampleTestCase {
    var name: String
    var arguments: [String]
    /// The name of the config flag for the executable.
    var config: String
    /// The name of the dry run flag for the executable.
    var dryRun: String

    init(name: String, config: String = "config", dryRun: String? = nil, arguments: [String] = []) {
        precondition(!name.isEmpty)
        precondition(!config.isEmpty)
        precondition(!(dryRun?.isEmpty ?? false))
        self.name = name
        self.config = config
        self.dryRun = dryRun ?? "\(config)-dry-run"
        self.arguments = arguments
    }
}

struct SimpleExampleTestCase: ExampleTestCase {
    var name: String
    var arguments: [String]
    /// If the example test case should work or not
    var isSuccessful: Bool

    init(name: String, isSuccessful: Bool = true, arguments: [String]) {
        self.name = name
        self.isSuccessful = isSuccessful
        self.arguments = arguments
    }
}

final class ConfigArgumentParserExamplesTests: XCTestCase {
    static let packageRoot: FilePath = {
        var packageRoot = FilePath(#file)
        for _ in 0..<3 {
            packageRoot.removeLastComponent()
        }
        print(#file)
        print(packageRoot.string)
        print((try? FileManager.default.contentsOfDirectory(atPath: packageRoot.string)) ?? [])
        return packageRoot
    }()

    var originalDirectory: String = ""

    override func setUp() {
        self.continueAfterFailure = false
        originalDirectory = FileManager.default.currentDirectoryPath
    }

    override func tearDown() {
        if originalDirectory != "" {
            FileManager.default.changeCurrentDirectoryPath(originalDirectory)
        }
    }

    func testAllDetailedTestCases() throws {
        print()
        try detailedExampleTestCases.forEach(run(example:))
    }

    func testAllSimpleTestCases() throws {
        print()
        try simpleExampleTestCases.forEach(run(example:))
    }

    func simpleShell(_ command: String) throws -> Int32 {
        print("command: \(command)")
        let process = Process()
        #if !os(Windows)
        
        process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        process.arguments = command.lazy.split(separator: " ").map(String.init)
        #else
        // TODO: Figure out how to get this path in a better way.
        process.executableURL = .init(fileURLWithPath: FilePath(#"C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\bin\swift"#).string)
        process.arguments = command.lazy.split(separator: " ").dropFirst().map(String.init)
        #endif

        try process.run()
        process.waitUntilExit()
        return process.terminationStatus
    }
}

extension ConfigArgumentParserExamplesTests {
    func swiftpmBuild(example: ExampleTestCase) throws {
        try moveToExamplesDirectory(currentExample: example)
        let buildExitCode = try simpleShell("swift build --product \(example.name)")
        XCTAssertEqual(buildExitCode, 0, "Build didn't end with exit code 0.")
    }

    func moveToExamplesDirectory(currentExample: ExampleTestCase) throws {
        guard FileManager.default.changeCurrentDirectoryPath(ConfigArgumentParserExamplesTests.packageRoot.appending("/Examples").string) else {
            XCTFail("Unable to move to Examples directory. Cannot build and test \(currentExample.name).")
            return
        }
    }
}

extension ConfigArgumentParserExamplesTests {
    func run(example: DetailedExampleTestCase) throws {
        print("===== TEST: \(example.name) =====")
        try swiftpmBuild(example: example)
        let configs = try configFilePaths(for: example)
        try swiftpmRun(example: example, configs: configs)
        print()
    }

    func configFilePaths(for example: DetailedExampleTestCase) throws -> (good: FilePath, bad: FilePath) {
        let exampleDirectory = Self.packageRoot.appending("Examples/Sources/" + example.name)
        return (exampleDirectory.appending("/config_good"), exampleDirectory.appending("/config_bad"))
    }

    func swiftpmRun(example: DetailedExampleTestCase, configs: (good: FilePath, bad: FilePath)) throws {
        try moveToExamplesDirectory(currentExample: example)

        let dryRunGoodExitCode = try simpleShell("swift run \(example.name) --\(example.dryRun) --\(example.config) \(configs.good.string) \(example.arguments.joined(separator: " "))")
        XCTAssertEqual(dryRunGoodExitCode, 0, "Dry run with good config didn't end with exit code 0.")
        let goodExitCode = try simpleShell("swift run \(example.name) --\(example.config) \(configs.good.string)")
        XCTAssertEqual(goodExitCode, 0, "Run with good config didn't end with exit code 0.")

        let dryRunBadExitCode = try simpleShell("swift run \(example.name) --\(example.dryRun) --\(example.config) \(configs.bad.string) \(example.arguments.joined(separator: " "))")
        XCTAssertEqual(dryRunBadExitCode, 0, "Dry run with bad config didn't end with exit code 0.")
        let badExitCode = try simpleShell("swift run \(example.name) --\(example.config) \(configs.bad.string)")
        XCTAssertNotEqual(badExitCode, 0, "Run with bad config ended with exit code 0.")
    }
}

extension ConfigArgumentParserExamplesTests {
    func run(example: SimpleExampleTestCase) throws {
        print("===== TEST: \(example.name) =====")
        try swiftpmBuild(example: example)
        try swiftpmRun(example: example)
        print()
    }

    func swiftpmRun(example: SimpleExampleTestCase) throws {
        try moveToExamplesDirectory(currentExample: example)
        let simpleRunExitCode = try simpleShell("swift run \(example.name) \(example.arguments.joined(separator: " "))")

        if example.isSuccessful {
            XCTAssertEqual(simpleRunExitCode, 0, "Simple run failed when it should have succeeded")
        } else {
            XCTAssertNotEqual(simpleRunExitCode, 0, "Simple run succeeded when it should have failed")
        }
    }
}
