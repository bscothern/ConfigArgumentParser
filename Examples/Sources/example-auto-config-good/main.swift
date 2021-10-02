//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleAutoConfigGood: ParsableCommand {
    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleAutoConfigGood ===")
        print(values)
    }
}

enum ExampleAutoConfigGoodFlagSettings: ConfigFlagSettings {
    static var autoConfigPaths: [String] {
        [
            "Sources/\(ExampleAutoConfigGood._commandName)/\(ExampleAutoConfigGood._commandName).config"
        ]
    }
}

ConfigExecutable<ExampleAutoConfigGood>
    .customizeFlags(with: ExampleAutoConfigGoodFlagSettings.self)
    .main()
