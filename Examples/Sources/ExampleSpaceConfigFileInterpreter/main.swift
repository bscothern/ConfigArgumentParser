//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleSpaceConfigFileInterpreter: ParsableCommand {
    @Option
    var times = 1
    
    @Argument
    var values: [Int]
    
    mutating func run() {
        print("=== ExampleSpaceConfigFileInterpreter ===")
        for _ in 0..<times {
            print(values)
        }
    }
}

ConfigExecutable<ExampleSpaceConfigFileInterpreter>
    .interpretConfig(with: Interpreters.space)
    .main()
