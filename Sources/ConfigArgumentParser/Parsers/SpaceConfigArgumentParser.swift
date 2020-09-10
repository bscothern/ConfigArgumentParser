//
//  SpaceConfigArgumentParser.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/9/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

/// A type that can be executed with a config file with arguments seperated by a space or directly calling the `RootCommand` and its subcommands directly.
///
/// - Note: See `ConfigArgumentParser` for more details.
public enum SpaceConfigArgumentParser<RootCommand> where RootCommand: ParsableCommand {
    @inlinable
    public static func main() {
        ConfigArgumentParser<RootCommand, SpaceConfigFileInterpreter>.main()
    }
}

@usableFromInline
enum SpaceConfigFileInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) -> [String] {
        configFileContents
            .split(separator: " ")
            .map(String.init)
    }
}
