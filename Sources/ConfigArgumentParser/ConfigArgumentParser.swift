//
//  ConfigArgumentParser.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

/// A type that can be executed with a config file or directly calling the `RootCommand` and its subcommands directly.
///
/// If the supplied arguments cannot be interpreted to run the `RootCommand` it is then attempted to be parsed arguments for this type.
/// These flags are listed below:
/// ```bash
/// --config [config_file]  Specifies the config file to parse for arguments
/// --config-dry-run        Print the command that would be generated and run against the RootCommand
/// ```
///
/// - Note:
///     This is a specialization of the `ParsableCommand` from the `ArgumentParser` module of swift-argument-parser.
///
/// - Warning:
///     Because of how arguments need to be parsed in order for your `RootCommand` you should avoid the flags added by the `ConfigArgumentParser` being a part of your `RootCommand`.
public enum ConfigArgumentParser<RootCommand, Interpreter> where RootCommand: ParsableCommand, Interpreter: ConfigFileInterpreter {
    /// Parse the arguments given to the executable and attempt to start the `RootCommand` if directly called otherwise attempt to find a config and execute it instead.
    @inlinable
    public static func main() {
        do {
            var subcommand = try RootCommand.parseAsRoot()
            do {
                try subcommand.run()
            } catch {
                RootCommand.exit(withError: error)
            }
        } catch let subcommandError {
            do {
                var command = try ConfigCommand<RootCommand, Interpreter>.parseAsRoot()
                try command.run()
            } catch {
                RootCommand.exit(withError: subcommandError)
            }
        }
    }
}
