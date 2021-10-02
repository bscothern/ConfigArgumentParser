@testable import ConfigArgumentParser
import Foundation
import XCTest

/// This defines all test cases found in the Examples/Package.swift along with how they are setup and should be tested.
let testCases: [ExampleTestCase] = [
    // Test defaults
    .init(name: "ExampleDefault"),
    
    // Only change the custom flags
    .init(name: "ExampleCustomFlags1", config: "test-custom-config", dryRun: "test-custom-dry-run"),
    .init(name: "ExampleCustomFlags2", config: "test-custom-config"),
    .init(name: "ExampleCustomFlags3", dryRun: "test-custom-config-dry-run"),
    
    // Only changing the interpreter to the specified one
    .init(name: "ExampleNewLineConfigFileInterpreter"),
    .init(name: "ExampleOptionPerLineConfigArgumentInterpreter"),
    .init(name: "ExampleSpaceConfigFileInterpreter"),
    
    // Testing both a change to the flags and interpreter
    .init(name: "ExampleAllCustom", config: "foo", dryRun: "bar"),
    
    // Custom Flags Override (WIP)
//    .init(name: "ExampleCLIOverride", arguments: ["--times", "3", "42", "43", "44"]),
]

struct ExampleTestCase {
    /// The name of the example to run.
    var name: String
    /// The name of the config flag for the executable.
    var config: String
    /// The name of the dry run flag for the executable.
    var dryRun: String
    /// Other arguments to pass to the executable
    var arguments: [String]
    
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

final class ConfigArgumentParserExamplesTests: XCTestCase {
    static let packageRoot = "/" + #file.split(separator: "/").dropLast(3).joined(separator: "/") + "/"
    static let namesPath = packageRoot + "Examples/Names.txt"

    let examples = testCases
        .sorted { $0.name < $1.name }

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

    func testAllExamples() throws {
        print()
        try examples.forEach(run(example:))
    }

    func run(example: ExampleTestCase) throws {
        print("===== TEST: \(example.name) =====")
        try build(example: example)
        let configs = try configFilePaths(for: example)
        try run(example: example, configs: configs)
        print()
    }

    func configFilePaths(for example: ExampleTestCase) throws -> (good: String, bad: String) {
        let exampleDirectory = Self.packageRoot + "Examples/Sources/" + example.name
        return (exampleDirectory + "/config_good", exampleDirectory + "/config_bad")
    }

    func build(example: ExampleTestCase) throws {
        try moveToExamplesDirectory(currentExample: example)
        let buildExitCode = simpleShell("swift build --product \(example.name)")
        XCTAssertEqual(buildExitCode, 0, "Build didn't end with exit code 0.")
    }

    func run(example: ExampleTestCase, configs: (good: String, bad: String)) throws {
        try moveToExamplesDirectory(currentExample: example)

        let dryRunGoodExitCode = simpleShell("swift run \(example.name) --\(example.dryRun) --\(example.config) \(configs.good) \(example.arguments)")
        XCTAssertEqual(dryRunGoodExitCode, 0, "Dry run with good config didn't end with exit code 0.")
        let goodExitCode = simpleShell("swift run \(example.name) --\(example.config) \(configs.good)")
        XCTAssertEqual(goodExitCode, 0, "Run with good config didn't end with exit code 0.")

        let dryRunBadExitCode = simpleShell("swift run \(example.name) --\(example.dryRun) --\(example.config) \(configs.bad) \(example.arguments)")
        XCTAssertEqual(dryRunBadExitCode, 0, "Dry run with bad config didn't end with exit code 0.")
        let badExitCode = simpleShell("swift run \(example.name) --\(example.config) \(configs.bad)")
        XCTAssertNotEqual(badExitCode, 0, "Run with bad config ended with exit code 0.")
    }

    func moveToExamplesDirectory(currentExample: ExampleTestCase) throws {
        guard FileManager.default.changeCurrentDirectoryPath(ConfigArgumentParserExamplesTests.packageRoot) else {
            XCTFail("Unable to move to package root. Cannot build and test \(currentExample.name).")
            return
        }
        guard FileManager.default.changeCurrentDirectoryPath("./Examples") else {
            XCTFail("Unable to move into ./Examples from package root. Cannot build and test \(currentExample.name).")
            return
        }
    }

    func simpleShell(_ command: String) -> Int32 {
        print("command: \(command)")
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = command.lazy.split(separator: " ").map(String.init)
        process.launch()
        process.waitUntilExit()
        return process.terminationStatus
    }
}
