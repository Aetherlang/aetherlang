# Ætherlang
<img src="Illustrations/logo.png" alt="logo" align="middle" width="200" height="200"/>

Ætherlang is an interpreted constantly-typed functional programming language made with Julia to demonstrate the ether-dimensional programming paradigm. Note that although it is a demonstrational language, it was meant to be usable and engaging. Most libraries with core useful features are still under development, however it is already possible to use Aetherlang. See the [website](https://aetherlang.github.io/EDPP/) for detailed information on the paradigm and tutorials.

## How to install
1. Install Julia (I used Julia v1.6.1 for automatic thread detection and other things, so make sure your version is compatible) and add it to path. No special libraries required.
2. Download the latest release from "Releases" section and unzip the folder with Aetherlang source code. You can either add it to path or open from your command line interface.
3. There are 2 ways to run a `.aeth` file with code in Aetherlang:
```
julia Interpreter.jl -t auto FILENAME.aeth
```
or
```
./aetherlangrun FILENAME.aeth
```
where `aetherlangrun` is simply a shell script located in the root of the source folder. Make sure you have a compatible terminal and a permission to execute this file.

## Versions
You can download the latest version from the "Releases" section. And please, only download Aetherlang from there. The repository's version is neither v0.1 nor v0.2, but rather it is somewhere in between, in the void of undocumented versions. That means, the code from the repository has a somewhat stable support for v0.1 but everything else is beyond it. Moreover, when Aetherlang will get more or less Julia-independent, the binaries will be available in the same "Releases" section. There's also "Projects" section in this repository where plans for future versions are shared.

## Hello, World!
A simple hello world program in current version of Aetherlang would look like this:
```
@ THIS INCLUDES THE TWO NEEDED LIBRARIES
use :base
use :io :io.
@ THIS PRINTS THE TEXT
io.println "Hello, World!"
```
or, like this (Aetherlang is not case-sensitive):
```
USE :IO
GREETING = "Hello, World!"
PRINTLN GREETING
```

## Paradigm Illustrations
![program](Illustrations/algo.png)

## License
Copyright (C) Atell Krasnopolski, 2021
MIT License
