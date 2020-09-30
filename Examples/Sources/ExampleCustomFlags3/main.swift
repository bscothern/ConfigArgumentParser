//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleCustomFlags3: ParsableCommand {
    @Argument
    var values: [Int]
    
    mutating func run() {
        print("=== ExampleCustomFlags3 ===")
        print(values)
    }
}

enum CustomFlagSettings: ConfigFlagSettings {
    static var dryRun: String { "test-custom-config-dry-run" }
}

ConfigExecutable<ExampleCustomFlags3>
    .customizeFlags(with: CustomFlagSettings.self)
    .main()
