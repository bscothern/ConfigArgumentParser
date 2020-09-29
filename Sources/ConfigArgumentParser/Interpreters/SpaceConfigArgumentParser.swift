//
//  SpaceConfigArgumentParser.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/9/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

@usableFromInline
enum SpaceConfigFileInterpreter: ConfigFileInterpreter {
    @usableFromInline
    static func convertToArguments(configFileContents: String) -> [String] {
        configFileContents
            .split(separator: " ")
            .map(String.init)
    }
}

extension Interpreters {
    @inlinable
    public static var space: ConfigFileInterpreter.Type { SpaceConfigFileInterpreter.self }
}
