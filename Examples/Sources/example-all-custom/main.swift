//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleAllCustom: ParsableCommand {
    @Option
    var times = 1

    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleAllCustom ===")
        for _ in 0..<times {
            print(values)
        }
    }
}

enum CommaSeperatedConfigFileInterpreter: ConfigFileInterpreter {
    static var configFileHelp: String { "\(#function) help "}

    static func convertToArguments(configFileContents: String) -> [ConfigArgument] {
        configFileContents
            .split(separator: ",")
            .map(ConfigArgument.init)
    }
}

enum FooBarOptioinsSettings: ConfigOptionsSettings {
    @usableFromInline
    static var autoConfigPaths: [String] {
        [
            "./\(ExampleAllCustom._commandName).config"
        ]
    }
    static var config: String { "foo" }
    static var dryRun: String { "bar" }
}

ConfigExecutable<ExampleAllCustom>
    .interpretConfig(with: CommaSeperatedConfigFileInterpreter.self)
    .customizeOptions(with: FooBarOptioinsSettings.self)
    .main()
