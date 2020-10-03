//
//  ExecutableConfigCommand.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser
import Foundation

/// The `ParsableCommand` that attempts to interpret a given config file and run the provided command.
@usableFromInline
struct ExecutableConfigCommand<RootCommand, Interpreter, Flags>: ParsableCommand, ExecutableEntryPoint where RootCommand: ParsableCommand, Flags: ConfigFlagSettings, Interpreter: ConfigFileInterpreter {
    @usableFromInline
    @Option(
        name: .customLong(Flags.config),
        help: "The config file to use for arguments to execute a subcommand. Each part of the command should be on its own line.",
        completion: CompletionKind.file()
    )
    var configFile: String

    @usableFromInline
    @Flag(
        name: .customLong(Flags.dryRun),
        help: "When set this flag will cause command generated by the config to print rather than run."
    )
    var dryRun: Bool = false

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
        do {
            var subcommand = try RootCommand.parseAsRoot()
            do {
                try subcommand.run()
            } catch {
                RootCommand.exit(withError: error)
            }
        } catch let subcommandError {
            do {
                var command = try Self.parseAsRoot()
                try command.run()
            } catch {
                RootCommand.exit(withError: subcommandError)
            }
        }
    }
}
