//
//  ConfigArgumentParserError.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// The errors that can be raised while attempting to run a command with a config file.
@usableFromInline
enum ConfigArgumentParserError: Error, CustomStringConvertible {
    case noConfigFilesInAutoPaths([String])
    case unableToFindConfig(file: String)

    @usableFromInline
    var description: String {
        switch self {
        case let .noConfigFilesInAutoPaths(paths):
            return "There were no config files found in the searched paths: \(paths.joined(separator: ", "))"
        case let .unableToFindConfig(file):
            return "Unable to find config file: \(file)"
        }
    }
}
