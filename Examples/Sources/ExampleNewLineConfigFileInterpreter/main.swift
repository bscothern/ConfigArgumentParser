//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleNewLineConfigFileInterpreter: ParsableCommand {
    @Option
    var times = 1

    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleNewLineConfigFileInterpreter ===")
        for _ in 0..<times {
            print(values)
        }
    }
}

ConfigExecutable<ExampleNewLineConfigFileInterpreter>
    .interpretConfig(with: Interpreters.newLine)
    .main()
