//
//  InterpretedConfigExecutable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/12/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser

@usableFromInline
enum InterpretedConfigExecutable<RootCommand, Interpreter> where RootCommand: ParsableCommand, Interpreter: ConfigFileInterpreter {}

extension InterpretedConfigExecutable: ConfigOptionsCustomizable {
    @usableFromInline
    static func customizeOptions(with customizeOptions: ConfigOptionsSettings.Type) -> ExecutableEntryPoint.Type {
        customizeOptions.bind(to: RootCommand.self, Interpreter.self)
    }
}

extension InterpretedConfigExecutable: ExecutableEntryPoint {
    @usableFromInline
    static func main() {
        Self.customizeOptions(with: DefaultConfigOptionsSettings<RootCommand>.self)
            .main()
    }
}
