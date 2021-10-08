//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleCustomOptions3: ParsableCommand {
    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleCustomOptions3 ===")
        print(values)
    }
}

enum CustomOptionsSettings: ConfigOptionsSettings {
    static var dryRun: String { "test-custom-config-dry-run" }
}

ConfigExecutable<ExampleCustomOptions3>
    .customizeOptions(with: CustomOptionsSettings.self)
    .main()
