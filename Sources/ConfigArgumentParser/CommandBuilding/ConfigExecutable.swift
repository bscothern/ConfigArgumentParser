//
//  ConfigExecutable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/10/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

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
        Self.interpretConfig(with: Interpreters.default)
            .customizeFlags(with: DefaultConfigFlagSettings.self)
            .main()
    }
}
