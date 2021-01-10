//
//  ExecutableConfigCommand.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
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
    @Option(
        name: .customLong(Flags.config),
        help: ArgumentHelp(Flags.configHelp),
        completion: CompletionKind.file()
    )
    var configFile: String

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
        guard var contents = try? String(contentsOfFile: configFile) else {
            Self.exit(withError: ConfigArgumentParserError.unableToFindConfig(file: configFile))
        }
        if Interpreter.stripConfigFileTrailingNewLine && contents.last == "\n" {
            contents = String(contents.dropLast())
        }
        let arguments = try Interpreter.convertToArguments(configFileContents: contents)
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

        /// This values comes from HelpGenerator.labelColumnWidth
        let labelColumnWidth = 26

        var configHelp = "  --\(Flags.config) <\(Flags.config)>"
        if configHelp.count >= labelColumnWidth {
            configHelp += "\n"
        }
        if var configHelpLastLineCount = configHelp.split(separator: "\n").last?.count {
            while configHelpLastLineCount < labelColumnWidth {
                configHelp += " "
                configHelpLastLineCount += 1
            }
        }
        configHelp += "\(Flags.configHelp) \(Interpreter.configFileHelp)"

        var dryRunHelp = "  --\(Flags.dryRun)"
        if dryRunHelp.count >= labelColumnWidth {
            dryRunHelp += "\n"
        }
        if var dryRunHelpLineCount = dryRunHelp.split(separator: "\n").last?.count {
            while dryRunHelpLineCount < labelColumnWidth {
                dryRunHelp += " "
                dryRunHelpLineCount += 1
            }
        }
        dryRunHelp += Flags.dryRunHelp

        executableConfigCommandHelpContext = .allocate(capacity: 1)
        executableConfigCommandHelpContext.initialize(
            to: .init(
                hasSubcomands: !RootCommand.configuration.subcommands.isEmpty,
                message: "\(configHelp)\n\(dryRunHelp)"
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
