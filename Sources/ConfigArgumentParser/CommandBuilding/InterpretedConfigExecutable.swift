//
//  InterpretedConfigExecutable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/12/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ArgumentParser

@usableFromInline
enum InterpretedConfigExecutable<RootCommand, Interpreter> where RootCommand: ParsableCommand, Interpreter: ConfigFileInterpreter {}

extension InterpretedConfigExecutable: ConfigFlagCustomizable {
    @usableFromInline
    static func customizeFlags(with flagSettings: ConfigFlagSettings.Type) -> ExecutableEntryPoint.Type {
        fatalError("TODO")
    }
}

extension InterpretedConfigExecutable: ExecutableEntryPoint {
    @usableFromInline
    static func main() {
        Self.customizeFlags(with: DefaultConfigFlagSettings.self)
            .main()
    }
}
