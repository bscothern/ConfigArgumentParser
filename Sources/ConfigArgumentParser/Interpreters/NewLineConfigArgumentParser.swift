//
//  NewLineConfigArgumentParser.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

@usableFromInline
enum NewLineConfigFileInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) -> [String] {
        configFileContents
            .split(separator: "\n")
            .map(String.init)
    }
}

extension Interpreters {
    @inlinable
    public static var newLine: ConfigFileInterpreter.Type { NewLineConfigFileInterpreter.self }
}
