//
//  NewLineConfigArgumentParser.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

/// A type that can be executed with a config file with arguments seperated by new line or directly calling the `RootCommand` and its subcommands directly.
///
/// - Note: See `ConfigArgumentParser` for more details.
public enum NewLineConfigArgumentParser<RootCommand> where RootCommand: ParsableCommand {
    @inlinable
    public static func main() {
        ConfigArgumentParser<RootCommand, NewLineConfigFileInterpreter>.main()
    }
}

@usableFromInline
enum NewLineConfigFileInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) -> [String] {
        configFileContents
            .split(separator: "\n")
            .map(String.init)
    }
}
