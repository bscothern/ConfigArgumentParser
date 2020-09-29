//
//  ConfigFileInterpreterCustomizable.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/12/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public protocol ConfigFileInterpreterCustomizable {
    static func interpretConfig(with interpreter: ConfigFileInterpreter.Type) -> (ConfigFlagCustomizable & ExecutableEntryPoint).Type
}
