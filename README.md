# immut.lua (Work In Progress)

> Immutable and persistent data structures for Lua

[![lua5.1.5][badge.lua5.1.5]][lua5.1.5]
[![lua5.4.8][badge.lua5.4.8]][lua5.4.8]
[![luajit2.1][badge.luajit2.1]][luajit2.1]
[![license][badge.license]][license]

[badge.lua5.1.5]: https://img.shields.io/github/actions/workflow/status/BlackMATov/immut.lua/.github/workflows/lua5.1.5.yml?label=Lua%205.1.5
[badge.lua5.4.8]: https://img.shields.io/github/actions/workflow/status/BlackMATov/immut.lua/.github/workflows/lua5.4.8.yml?label=Lua%205.4.8
[badge.luajit2.1]: https://img.shields.io/github/actions/workflow/status/BlackMATov/immut.lua/.github/workflows/luajit2.1.yml?label=LuaJIT%202.1
[badge.license]: https://img.shields.io/badge/license-MIT-blue

[lua5.1.5]: https://github.com/BlackMATov/immut.lua/actions?query=workflow%3Alua5.1.5
[lua5.4.8]: https://github.com/BlackMATov/immut.lua/actions?query=workflow%3Alua5.4.8
[luajit2.1]: https://github.com/BlackMATov/immut.lua/actions?query=workflow%3Aluajit2.1
[license]: https://en.wikipedia.org/wiki/MIT_License

[immut]: https://github.com/BlackMATov/immut.lua

- [Introduction](#introduction)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Cheat Sheet](#cheat-sheet)
  - [List](#list)
  - [Dict](#dict)
- [Changelog](#changelog)
- [License](#license)

## Introduction

## Installation

`immut.lua` is a single-file pure Lua library and does not require any external dependencies. It is designed to work with [Lua 5.1](https://www.lua.org/) and later, [LuaJIT](https://luajit.org/), and [Luau](https://luau.org/) (Roblox).

All you need to start using the library is the [immut.lua](./immut.lua) source file. You can download it from the [releases](https://github.com/BlackMATov/immut.lua/releases) page or clone the [repository](https://github.com/BlackMATov/immut.lua) and copy the file to your project.

If you are using [LuaRocks](https://luarocks.org/), you can install the library using the following command:

```bash
luarocks install immut.lua
```

## Quick Start

> Coming soon...

## Cheat Sheet

### List

```
list.new :: list

list.size :: list -> integer
list.empty :: list -> boolean

list.head :: list -> any
list.last :: list -> any

list.tail :: list -> list?
list.init :: list -> list?

list.cons :: list, any -> list
list.snoc :: list, any -> list
```

### Dict

```
dict.new :: dict

dict.size :: dict -> integer
dict.empty :: dict -> boolean

dict.assoc :: dict, any, any -> dict
dict.dissoc :: dict, any -> dict

dict.lookup :: dict, any -> any
dict.contains :: dict, any -> boolean
```

## Changelog

> Coming soon...

## License

`immut.lua` is licensed under the [MIT License][license]. For more details, see the [LICENSE.md](./LICENSE.md) file in the repository.
