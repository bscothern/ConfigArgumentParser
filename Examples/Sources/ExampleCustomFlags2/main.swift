//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleCustomFlags2: ParsableCommand {
    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleCustomFlags2 ===")
        print(values)
    }
}

enum CustomFlagSettings: ConfigFlagSettings {
    static var config: String { "test-custom-config" }
}

ConfigExecutable<ExampleCustomFlags2>
    .customizeFlags(with: CustomFlagSettings.self)
    .main()
