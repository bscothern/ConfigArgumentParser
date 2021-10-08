//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleCustomOptions1: ParsableCommand {
    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleCustomOptions1 ===")
        print(values)
    }
}

enum CustomOptionsSettings: ConfigOptionsSettings {
    static var config: String { "test-custom-config" }
    static var dryRun: String { "test-custom-dry-run" }
}

ConfigExecutable<ExampleCustomOptions1>
    .customizeOptions(with: CustomOptionsSettings.self)
    .main()
