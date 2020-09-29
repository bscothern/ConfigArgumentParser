//
//  ConfigFlagCustomizable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/12/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public protocol ConfigFlagCustomizable {
    static func customizeFlags(with flagSettings: ConfigFlagSettings.Type) -> ExecutableEntryPoint.Type
}
