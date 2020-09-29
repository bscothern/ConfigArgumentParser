//
//  ExecutableEntryPoint.swift
//  ConfigArgumentParser
//
//  Created by Braden Scothern on 9/10/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// An entry point to an executable.
///
/// This is equivalent to `ArgumentParser.ParsableCommand`'s `static main()` function.
public protocol ExecutableEntryPoint {
    static func main()
}
