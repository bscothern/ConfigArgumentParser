//
//  ConfigFlagSettings.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/10/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

/// A type that defines the flags used by an `ExecutableEntryPoint` so it knows how to identify a config file or a dry run of a config file.
public protocol ConfigFlagSettings {
    /// The long flag that should be used to pass in a config file for this executable.
    ///
    /// - Note: This defaults to `"config"`
    static var config: String { get }

    /// The long flag that should be used to trigger a dry run of the config command.
    ///
    /// When this flag is passed in it results in the generated config command being printed to the console.
    ///
    /// - Note: This defaults to `"\(self.config)-dry-run"`
    static var dryRun: String { get }
}

extension ConfigFlagSettings {
    @inlinable
    public static var config: String { "config" }

    @inlinable
    public static var dryRun: String { "\(config)-dry-run" }
}

extension ConfigFlagSettings {
    @usableFromInline
    static func bind<RootCommand, Interpreter>(to _: RootCommand.Type, _: Interpreter.Type) -> ExecutableEntryPoint.Type where RootCommand: ParsableCommand, Interpreter: ConfigFileInterpreter {
        ExecutableConfigCommand<RootCommand, Interpreter, Self>.self
    }
}
