@testable import ConfigArgumentParser
import Foundation
import XCTest

final class ConfigArgumentParserExamplesTests: XCTestCase {
    static let packageRoot = "/" + #file.split(separator: "/").dropLast(3).joined(separator: "/") + "/"
    static let namesPath = packageRoot + "Examples/Names.txt"

    // The examples that need to be processed along with their config and dry run settings.
    let examples: [(name: String, config: String, dryRun: String, otherArguments: String)] = try! String(contentsOfFile: ConfigArgumentParserExamplesTests.namesPath)
        .split(separator: "\n")
        .lazy
        .filter { !$0.hasPrefix("//") }
        .map { line in
            let argumentSplit = line.split(separator: "|", maxSplits: 1)
            let components = argumentSplit[0].split(separator: ",", omittingEmptySubsequences: false).map(String.init)
            let name = components[0]
            let config: String
            let dryRun: String
            if components.count >= 2,
                !components[1].isEmpty {
                config = components[1]
            } else {
                config = "config"
            }
            if components.count >= 3,
                !components[2].isEmpty {
                dryRun = components[2]
            } else {
                dryRun = "\(config)-dry-run"
            }

            let otherArguments: String
            if argumentSplit.count == 2 {
                otherArguments = String(argumentSplit[1])
            } else {
                otherArguments = ""
            }

            return (name, config, dryRun, otherArguments)
        }
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
        try examples.forEach(runExample(name:config:dryRun:otherArguments:))
    }

    func runExample(name: String, config: String, dryRun: String, otherArguments: String) throws {
        print("===== TEST: \(name) =====")
        try build(example: name)
        let configs = try configFilePaths(for: name)
        try run(example: name, config: config, dryRyn: dryRun, configs: configs, otherArguments: otherArguments)
        print()
    }

    func configFilePaths(for example: String) throws -> (good: String, bad: String) {
        let exampleDirectory = Self.packageRoot + "Examples/Sources/" + example
        return (exampleDirectory + "/config_good", exampleDirectory + "/config_bad")
    }

    func build(example: String) throws {
        try moveToExamplesDirectory(currentExample: example)
        let buildExitCode = simpleShell("swift build --product \(example)")
        XCTAssertEqual(buildExitCode, 0, "Build didn't end with exit code 0.")
    }

    func run(example: String, config: String, dryRyn: String, configs: (good: String, bad: String), otherArguments: String) throws {
        try moveToExamplesDirectory(currentExample: example)

        let dryRunGoodExitCode = simpleShell("swift run \(example) --\(dryRyn) --\(config) \(configs.good) \(otherArguments)")
        XCTAssertEqual(dryRunGoodExitCode, 0, "Dry run with good config didn't end with exit code 0.")
        let goodExitCode = simpleShell("swift run \(example) --\(config) \(configs.good)")
        XCTAssertEqual(goodExitCode, 0, "Run with good config didn't end with exit code 0.")

        let dryRunBadExitCode = simpleShell("swift run \(example) --\(dryRyn) --\(config) \(configs.bad) \(otherArguments)")
        XCTAssertEqual(dryRunBadExitCode, 0, "Dry run with bad config didn't end with exit code 0.")
        let badExitCode = simpleShell("swift run \(example) --\(config) \(configs.bad)")
        XCTAssertNotEqual(badExitCode, 0, "Run with bad config ended with exit code 0.")
    }

    func moveToExamplesDirectory(currentExample: String ) throws {
        guard FileManager.default.changeCurrentDirectoryPath(ConfigArgumentParserExamplesTests.packageRoot) else {
            XCTFail("Unable to move to package root. Cannot build and test \(currentExample).")
            return
        }
        guard FileManager.default.changeCurrentDirectoryPath("./Examples") else {
            XCTFail("Unable to move into ./Examples from package root. Cannot build and test \(currentExample).")
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
