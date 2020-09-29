//
//  ConfigFlagCustomizable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/12/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A type that can still set the `ConfigFlagSettings` to use when running the command.
public protocol ConfigFlagCustomizable {
    /// Sets the `ConfigFlagSettings` of the command.
    ///
    /// - Parameter flagSettings: The `ConfigFlagSettings.Type` to use when interpreting config files with the resulting `ExecutableEntryPoint`.
    /// - Returns: A `ExecutableEntryPoint.Type` that can be started.
    static func customizeFlags(with flagSettings: ConfigFlagSettings.Type) -> ExecutableEntryPoint.Type
}
