# ConfigArgumentParser

An extension of the [swift argument parser](https://github.com/apple/swift-argument-parser) to support config files.

![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)
![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)
![Swift Versions](https://img.shields.io/badge/Swift-5.2+-orange.svg)

## Supported Features
* Custom Config File Formats.
* Customizable Flags/Help Messages.
* Dry runs to show what commands will be run with the config file being used.
* The ability to auto find and use config files at paths of your choosing.

## Usage
You should be familiar with at least the basics of the [swift argument parser](https://github.com/apple/swift-argument-parser) which this extends.
Build up your command line executable as you normally would when working with the swift argument parser with one exception which is how you start the executable. Once you have your exeutable ready that is where this library comes in to enable config files.

The type that enables the use of config files is `ConfigExecutable<RootCommand>`.
The `RootCommand` is your executable command type that you would normally call `RootCommand.main()` on.
With your `ConfigExecutable` you can then build up your command and customize how the config file is interpreted or what flags are used to supply a config file as needed.

### The simple case
In the most simple case this is all you need:
```swift
ConfigExecutable<YourCommand>.main()
```

### Customizing the config file
When you need to customize how the config file is interpreted and converted to the arguments your command expects you create a `ConfigFileInterpreter` type and then use `interpretConfig(with:)` like this:
```swift
ConfigExecutable<YourCommand>
    .interpretConfig(with: YourConfigFileInterpreter.self)
    .main()
```

### Customizing the flags
When the default flags of `--config [config_file_path]` and `--config-dry-run` aren't what you want you can create a `ConfigFlagSettings` type and use `customizeFlags(with:)` to change them as needed like this:
```swift
ConfigExecutable<YourCommand>
    .interpretConfig(with: YourConfigFileInterpreter.self) // If desired, this is not required
    .customizeFlags(with: YourConfigFlagSettings.self)
    .main()
```

There are example executables that are also used for testing in the `Executables/`.

## Adding `ConfigArgumentParser` as a dependency
Add the following line to your package dependencies in your `Package.swift` file:
```swift
.package(url: "https://github.com/bscothern/ConfigArgumentParser", .upToNextMinor(from: "0.3.0")),
```

Then in the targets section add this line as a dependency in your `Package.swift` file:
```swift
.product(name: "ConfigArgumentParser", package: "ConfigArgumentParser"),
```

Breaking changes will happen on minor versions until version `1.0.0` is reached.

## Known Issues
* Because of how `ConfigArgumentParser` has to function to allow normal usage of your commands and the config options you can't have any auto complete help with supplying the arguments it supports.
* No way to automatically grab and run config file when running executables.
* You cannot override config settings from the command line.
* You cannot add aditional settings from the command line when a config file is used.
