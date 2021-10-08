//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 8/29/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser
import SystemPackage

struct ExampleAutoConfigBad: ParsableCommand {
    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleAutoConfigBad ===")
        print(values)
    }
}

enum ExampleAutoConfigBadFlagSettings: ConfigFlagSettings {
    static var autoConfigPaths: [FilePath] {
        [
            .init("Sources/\(ExampleAutoConfigBad._commandName)/\(ExampleAutoConfigBad._commandName).config")
        ]
    }
}

ConfigExecutable<ExampleAutoConfigBad>
    .customizeFlags(with: ExampleAutoConfigBadFlagSettings.self)
    .main()
