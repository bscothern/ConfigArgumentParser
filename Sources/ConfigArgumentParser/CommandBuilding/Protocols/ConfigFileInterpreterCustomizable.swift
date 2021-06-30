//
//  ConfigFileInterpreterCustomizable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/12/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A type that can still set the `ConfigFileInterpreter` to use when running the command.
public protocol ConfigFileInterpreterCustomizable {
    /// Sets the `ConfigFileInterpreter` of the command.
    ///
    /// - Parameter interpreter: The `ConfigFileInterpreter.Type` to use when interpreting config files with the resulting `ExecutableEntryPoint`.
    /// - Returns: A `ExecutableEntryPoint.Type` that can be started or further customized via its conformance to `ConfigFlagCustomizable`.
    static func interpretConfig(with interpreter: ConfigFileInterpreter.Type) -> (ConfigFlagCustomizable & ExecutableEntryPoint).Type
}
