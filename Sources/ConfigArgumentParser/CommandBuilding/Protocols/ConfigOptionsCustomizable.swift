//
//  ConfigOptionsCustomizable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/12/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A type that can still set the `ConfigOptionsSettings` to use when running the command.
public protocol ConfigOptionsCustomizable {
    /// Sets the `ConfigOptionsSettings` of the command.
    ///
    /// - Parameter flagSettings: The `ConfigOptionsSettings.Type` to use when interpreting config files with the resulting `ExecutableEntryPoint`.
    /// - Returns: A `ExecutableEntryPoint.Type` that can be started.
    static func customizeOptions(with optionsSettings: ConfigOptionsSettings.Type) -> ExecutableEntryPoint.Type
}
