//
//  main.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 1/6/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import ConfigArgumentParser

struct ExampleCLIOverride: ParsableCommand {
    static let configuration = CommandConfiguration(
        subcommands: [Foo.self]
    )

    @Option
    var times = 1
//
//    @Argument
//    var values: [Int]

    mutating func run() {
        print("=== ExampleCLIOverride ===")
        for _ in 0..<times {
            print(1) //values)
        }
    }
}

struct Foo: ParsableCommand {
    @Option
    var times2 = 1

    @Argument
    var values: [Int]

    mutating func run() {
        print("=== ExampleCLIOverride ===")
        for _ in 0..<times2 {
            print(values)
        }
    }
}

ConfigExecutable<ExampleCLIOverride>.main()
