//
//  ConfigExecutable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/10/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser

/// Builds up a `ExecutableEntryPoint` to run a `ParsableCommand` that can be executed with a config file.
///
/// Usage is like this:
/// ```
/// ConfigExecutable<YourCommand>
///     .interpretConfig(with: YourConfigFileInterpreter.self)
///     .customizeFlags(with: YourConfigFlagSettings.self)
///     .main()
/// ```
///
/// You are only required to provide an interpreter and flag settings when desired.
///
/// The default `ConfigFileInterpreter` used will take one flag/option/argument per line along with one value.
/// If you have an option or argument that takes an array of arguments they should be supplied with one value per line or use a custom interpreter.
///
/// The default `ConfigFlagSettings` uses `--config [config_path]` to find the config file when supplied and `--config-dry-run` flag to print out what would have been run if just `--config [config_path]` were supplied.
///
/// - Note: Because of how `ArgumentParser` generates its help commands the the config flags are entirely hidden and cannot match flags in your normal command otherwise `ConfigExecutable` will not work and just your command will be run with those arguments.
public enum ConfigExecutable<RootCommand> where RootCommand: ParsableCommand {}

extension ConfigExecutable: ConfigFileInterpreterCustomizable {
    @inlinable
    public static func interpretConfig(with interpreter: ConfigFileInterpreter.Type) -> (ConfigFlagCustomizable & ExecutableEntryPoint).Type {
        interpreter.bind(to: RootCommand.self)
    }
}

extension ConfigExecutable: ConfigFlagCustomizable {
    @inlinable
    public static func customizeFlags(with flagSettings: ConfigFlagSettings.Type) -> ExecutableEntryPoint.Type {
        Self.interpretConfig(with: Interpreters.default)
            .customizeFlags(with: flagSettings)
    }
}

extension ConfigExecutable: ExecutableEntryPoint {
    @inlinable
    public static func main() {
        Self.customizeFlags(with: DefaultConfigFlagSettings<RootCommand>.self)
            .main()
    }
}
