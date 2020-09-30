//
//  NewLineConfigFileInterpreter.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@usableFromInline
enum NewLineConfigFileInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) -> [ConfigArgument] {
        configFileContents
            .split(separator: "\n")
            .map(ConfigArgument.init)
    }
}

extension Interpreters {
    @inlinable
    public static var newLine: ConfigFileInterpreter.Type { NewLineConfigFileInterpreter.self }
}
