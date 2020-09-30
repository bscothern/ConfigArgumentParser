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
}

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
