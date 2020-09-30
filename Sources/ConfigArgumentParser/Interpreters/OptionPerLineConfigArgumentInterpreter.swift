//
//  OptionPerLineConfigArgumentInterpreter.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/10/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@usableFromInline
enum OptionPerLineConfigArgumentInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) throws -> [ConfigArgument] {
        configFileContents
            .split(separator: "\n")
            .lazy
            // TODO: What other validation should happen here?
            .flatMap { $0.split(separator: " ", maxSplits: 1) }
            .map(ConfigArgument.init)
    }
}

extension Interpreters {
    @inlinable
    public static var optionPerLine: ConfigFileInterpreter.Type { OptionPerLineConfigArgumentInterpreter.self }
}
