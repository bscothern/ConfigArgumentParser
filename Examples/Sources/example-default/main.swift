//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleDefault: ParsableCommand {
    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleDefault ===")
        print(values)
    }
}

ConfigExecutable<ExampleDefault>.main()
