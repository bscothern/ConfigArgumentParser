//
//  SpaceConfigFileInterpreter.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/9/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@usableFromInline
enum SpaceConfigFileInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) -> [ConfigArgument] {
        configFileContents
            .split(separator: " ")
            .map(ConfigArgument.init)
    }

    @usableFromInline
    static let configFileHelp: String = "The config file should be formatted with each argument seperated by a space."
}

extension Interpreters {
    @inlinable
    public static var space: ConfigFileInterpreter.Type { SpaceConfigFileInterpreter.self }
}
