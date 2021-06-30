//
//  DefaultConfigFlagSettings.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/10/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import ArgumentParser

@usableFromInline
enum DefaultConfigFlagSettings<RootCommand>: ConfigFlagSettings where RootCommand: ParsableCommand {
    @usableFromInline
    static var autoConfigPaths: [String] {
        [
            "./\(RootCommand._commandName).config"
        ]
    }
}
