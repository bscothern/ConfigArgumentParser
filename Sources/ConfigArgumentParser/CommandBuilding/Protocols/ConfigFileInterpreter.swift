//
//  ConfigFileInterpreter.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

/// A type that converts file contents into an array of arguments for the root command of a `ConfigArgumentParser`.
public protocol ConfigFileInterpreter {
    /// An argument to pass to the command being run
    typealias ConfigArgument = String

    /// Converts the contents of a file into an array of arguments for a `ConfigArgumentParser`.
    ///
    /// - Parameter configFileContents: The contents of the specified config file that need to be converted to arguments.
    /// - Returns: An array of arguments that will be passed as the arguments to the root command of a `ConfigArgumentParser` as if they were passed in on the command line.
    static func convertToArguments(configFileContents: String) throws -> [ConfigArgument]

    /// This describes the format of the config file so it can be as part of the help message.
    static var configFileHelp: String { get }

    /// Determines if a `\n` as the last character of the config file should be stripped before being passed to `convertToArguments(configFileContents:)`.
    ///
    /// This defaults to `true` which will remove the dangling new line since it is automatically added by many editors but is obnoxious for breaking down and interpreting config files that aren't based on new lines.
    static var stripConfigFileTrailingNewLine: Bool { get }
}

// MARK: - Customization Points
extension ConfigFileInterpreter {
    @inlinable
    public static var stripConfigFileTrailingNewLine: Bool { true }
}

// MARK: - Internal helpers
extension ConfigFileInterpreter {
    /// A helper function to create an Interpreter type with a specified `RootCommand`.
    ///
    /// - Parameter _: The type of the `RootCommand` to run from this Interpreter.
    /// - Returns: An Interpreter that has been bound to the provided `RootCommand`.
    @usableFromInline
    static func bind<RootCommand>(to _: RootCommand.Type) -> (ConfigFlagCustomizable & ExecutableEntryPoint).Type where RootCommand: ParsableCommand {
        InterpretedConfigExecutable<RootCommand, Self>.self
    }
}
