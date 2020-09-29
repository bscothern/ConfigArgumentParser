//
//  NewLineConfigArgumentParser.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@usableFromInline
enum NewLineConfigFileInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) -> [Argument] {
        configFileContents
            .split(separator: "\n")
            .map(Argument.init)
    }
}

extension Interpreters {
    @inlinable
    public static var newLine: ConfigFileInterpreter.Type { NewLineConfigFileInterpreter.self }
}
