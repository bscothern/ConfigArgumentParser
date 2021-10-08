//
//  DefaultConfigOptionsSettings.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/10/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser
import SystemPackage

@usableFromInline
enum DefaultConfigOptionsSettings<RootCommand>: ConfigOptionsSettings where RootCommand: ParsableCommand {
    @usableFromInline
    static var autoConfigPaths: [FilePath] {
        [
            .init("./\(RootCommand._commandName).config")
        ]
    }
}
