//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleCustomOptions2: ParsableCommand {
    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleCustomOptions2 ===")
        print(values)
    }
}

enum CustomOptionsSettings: ConfigOptionsSettings {
    static var config: String { "test-custom-config" }
}

ConfigExecutable<ExampleCustomOptions2>
    .customizeOptions(with: CustomOptionsSettings.self)
    .main()
