# ConfigArgumentParser

An extension of the [swift argument parser](https://github.com/apple/swift-argument-parser) to support config files.

![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)
![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)
![Swift Versions](https://img.shields.io/badge/Swift-5.2, 5.3-orange.svg)

## Usage
You should be familiar with at least the basics of the [swift argument parser](https://github.com/apple/swift-argument-parser) which this extends.
Build up your command line executable as you normally would when working with the swift argument parser with one exception which is how you start the executable. Once you have your exeutable ready that is where this library comes in to enable config files.

The type that enables the use of config files is `ConfigArgumentParser<RootCommand, Interpreter>`.
The `RootCommand` is your executable command type that you would normally call `RootCommand.main()` on.
The `Interpreter` is a type responsible for parsing the given config file format to create the arguments list to pass to the `RootCommand`. 
A few common specializations of `ConfigArgumentParser` have been created that only need you to provide the `RootCommand` as they provide the `Interpreter`, these are shared below.

So pick how you are going to interpret your config files and then use code like this to start your executable:

```swift
SpecializedConfigArgumentParser<AwesomeExecutable>.main()
```

If you need to support a custom config file format then you will need to do this instead:

```swift
enum AwesomeExecutableConfigFileInterpreter: ConfigFileInterpreter {
    // Implimentation here
    ...
}

ConfigArgumentParser<AwesomeExecutable, AwesomeExecutableConfigFileInterpreter>.main()
```

### Specialized `ConfigArgumentParser` types
**Note these are not subclasses**</br>
These exist for common formats that can be used for config files.

| Specialization Type | Description |
|---|---|
| `NewLineConfigArgumentParser` | Each argument is on a new line of the config file. |
| `SpaceConfigArgumentParser`   | Each argument is seperated by a space in the config file.  |

## Adding `ConfigArgumentParser` as a dependency
Add the following line to your package dependencies in your `Package.swift` file:
```swift
.package(url: "https://github.com/bscothern/ConfigArgumentParser", from: "1.0.0"),
```

Then in the targets section add this line as a dependency in your `Package.swift` file:
```swift
.product(name: "ConfigArgumentParser", package: "ConfigArgumentParser"),
```


## Known Issues
* Because of how `ConfigArgumentParser` has to function to allow normal usage of your commands and the config options you can't have any help messages or auto complete help with supplying the arguments it supports.
  This means just the `RootCommand` and its subcommands help and autocomplete is available making `--config` and `--config-dry-run` magic hidden commands.
