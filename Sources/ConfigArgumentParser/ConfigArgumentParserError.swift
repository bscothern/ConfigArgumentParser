//
//  ConfigArgumentParserError.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// The errors that can be raised while attempting to run a command with a config file.
@usableFromInline
enum ConfigArgumentParserError: Error, CustomStringConvertible {
    case unableToFindConfig(file: String)

    @usableFromInline
    var description: String {
        switch self {
        case let .unableToFindConfig(file):
            return "Unable to find config file: \(file)"
        }
    }
}
