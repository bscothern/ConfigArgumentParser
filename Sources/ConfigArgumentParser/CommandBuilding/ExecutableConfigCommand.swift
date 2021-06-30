//
//  ExecutableConfigCommand.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import Foundation

/// The pointer which will be allocated and hold the additional help messaging if a help command is run.
var executableConfigCommandHelpContext: UnsafeMutablePointer<ExecutableConfigCommandHelpContext>!
struct ExecutableConfigCommandHelpContext {
    var hasSubcomands: Bool
    var message: String
}

/// The `ParsableCommand` that attempts to interpret a given config file and run the provided command.
@usableFromInline
struct ExecutableConfigCommand<RootCommand, Interpreter, Flags>: ParsableCommand, ExecutableEntryPoint where RootCommand: ParsableCommand, Flags: ConfigFlagSettings, Interpreter: ConfigFileInterpreter {
    @usableFromInline
    @Flag(
        name: .customLong(Flags.autoConfig),
        help: ArgumentHelp(Flags.autoConfigHelp)
    )
    var autoConfig: Bool = false
    
    @usableFromInline
    @Flag(
        name: .customLong(Flags.showAutoConfigFile),
        help: ArgumentHelp(Flags.showAutoConfigFileHelp)
    )
    var showAutoConfigFile: Bool = false

    @usableFromInline
    @Option(
        name: .customLong(Flags.config),
        help: ArgumentHelp(Flags.configHelp),
        completion: CompletionKind.file()
    )
    var configFile: String?

    @usableFromInline
    @Flag(
        name: .customLong(Flags.dryRun),
        help: ArgumentHelp(Flags.dryRunHelp)
    )
    var dryRun: Bool = false

    @Argument
    var otherArguments: [String] = []

    @usableFromInline
    init() {}

    @usableFromInline
    mutating func run() throws {
        if let configFile = configFile {
            guard let contents = try? String(contentsOfFile: configFile) else {
                Self.exit(withError: ConfigArgumentParserError.unableToFindConfig(file: configFile))
            }
            try run(with: contents)
        } else {
            guard let config = Flags.autoConfigPaths.lazy.compactMap({ (file: String) -> (file: String, contents: String)? in
                var filePath = file
                
                // String.init(contentsOfFile:) doens't work with a path using ~ for home so replace it by looking it up before trying this config file path.
                if filePath.hasPrefix("~") {
                    let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
                    filePath = filePath.replacingOccurrences(of: "~", with: homeDirectory.path)
                }
                
                guard let contents = try? String(contentsOfFile: filePath) else {
                    return nil
                }
                return (file, contents)
            }).first else {
                Self.exit(withError: ConfigArgumentParserError.noConfigFilesInAutoPaths(Flags.autoConfigPaths))
            }

            if showAutoConfigFile {
                print("Using Config File: \(config.file)")
            }
            try run(with: config.contents)
        }
    }

    mutating func run(with configContents: String) throws {
        var configContents = configContents
        if Interpreter.stripConfigFileTrailingNewLine && configContents.last == "\n" {
            configContents = String(configContents.dropLast())
        }
        let arguments = try Interpreter.convertToArguments(configFileContents: configContents)
        if dryRun {
            print("\(RootCommand._commandName) \(arguments.joined(separator: " "))")
        } else {
            RootCommand.main(arguments)
        }
    }

    @usableFromInline
    static func main() {
        // Attempt to run the main executable directly.
        do {
            var subcommand = try RootCommand.parseAsRoot()
            do {
                try subcommand.run()
            } catch {
                printConfigFileHelpMessageIfNeeded()
                RootCommand.exit(withError: error)
            }
        } catch let subcommandError {
            // Attempt to run the executable with a config file
            do {
                var command = try Self.parseAsRoot()
                try command.run()
            } catch {
                Self.exit(withError: subcommandError)
            }
        }
    }

    static func printConfigFileHelpMessageIfNeeded() {
        // Check if we are using this syntax: command subcommand [...] --help
        if CommandLine.arguments.contains("--help") {
            let expectedSubcommand = CommandLine.arguments.dropFirst().first
            guard !RootCommand.configuration.subcommands.lazy.map({ $0._commandName }).contains(expectedSubcommand) else {
                return
            }

            // Check if we are using this syntax: command help subcommand
        } else if let helpIndex = CommandLine.arguments.firstIndex(where: { $0 == "help" }) {
            let nextIndex = CommandLine.arguments.index(after: helpIndex)
            if CommandLine.arguments.indices.contains(nextIndex) {
                let expectedSubcommand = CommandLine.arguments[nextIndex]
                guard !RootCommand.configuration.subcommands.lazy.map({ $0._commandName }).contains(expectedSubcommand) else {
                    return
                }
            }
        } else {
            return
        }

        func makeHelpProperLength(_ string: inout String) {
            if string.count >= Constants.labelColumnWidth {
                string += "\n"
            }
            if let lastLineCount = string.split(separator: "\n").last?.count,
                lastLineCount < Constants.labelColumnWidth {
                string += String(repeating: " ", count: Constants.labelColumnWidth - lastLineCount)
            }
        }

        var message = ""
        
        if !Flags.autoConfigPaths.isEmpty {
            var autoConfigHelp = "  --\(Flags.autoConfig)"
            makeHelpProperLength(&autoConfigHelp)
            autoConfigHelp += Flags.autoConfigHelp
            message += "\n\(autoConfigHelp)"
            
            var showAutoConfigFileHelp = "  --\(Flags.showAutoConfigFile)"
            makeHelpProperLength(&showAutoConfigFileHelp)
            showAutoConfigFileHelp += Flags.showAutoConfigFileHelp
            message += "\n\(showAutoConfigFileHelp)"
        }

        var configHelp = "  --\(Flags.config) <\(Flags.config)>"
        makeHelpProperLength(&configHelp)
        configHelp += "\(Flags.configHelp) \(Interpreter.configFileHelp)"
        message += "\n\(configHelp)"

        var dryRunHelp = "  --\(Flags.dryRun)"
        makeHelpProperLength(&dryRunHelp)
        dryRunHelp += Flags.dryRunHelp
        message += "\n\(dryRunHelp)"

        executableConfigCommandHelpContext = .allocate(capacity: 1)
        executableConfigCommandHelpContext.initialize(
            to: .init(
                hasSubcomands: !RootCommand.configuration.subcommands.isEmpty,
                message: String(message.dropFirst())
            )
        )

        // We need to register this to actually do the printing of our help because the printing of help is handled by a RootCommand.exit(withError:)
        // where the error data provided to the function has the help message.
        atexit {
            if executableConfigCommandHelpContext.pointee.hasSubcomands {
                print()
            }
            print("CONFIG FILE:\n\(executableConfigCommandHelpContext.pointee.message)")
        }
    }
}
