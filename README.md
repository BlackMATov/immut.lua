# immut.lua (Work In Progress)

> Immutable and persistent data structures for Lua

[![lua5.1][badge.lua5.1]][lua5.1]
[![lua5.4][badge.lua5.4]][lua5.4]
[![luajit][badge.luajit]][luajit]
[![license][badge.license]][license]

[badge.lua5.1]: https://img.shields.io/github/actions/workflow/status/BlackMATov/immut.lua/.github/workflows/lua5.1.yml?label=Lua%205.1
[badge.lua5.4]: https://img.shields.io/github/actions/workflow/status/BlackMATov/immut.lua/.github/workflows/lua5.4.yml?label=Lua%205.4
[badge.luajit]: https://img.shields.io/github/actions/workflow/status/BlackMATov/immut.lua/.github/workflows/luajit.yml?label=LuaJIT
[badge.license]: https://img.shields.io/badge/license-MIT-blue

[lua5.1]: https://github.com/BlackMATov/immut.lua/actions?query=workflow%3Alua5.1
[lua5.4]: https://github.com/BlackMATov/immut.lua/actions?query=workflow%3Alua5.4
[luajit]: https://github.com/BlackMATov/immut.lua/actions?query=workflow%3Aluajit
[license]: https://en.wikipedia.org/wiki/MIT_License

[immut]: https://github.com/BlackMATov/immut.lua

- [Introduction](#introduction)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Cheat Sheet](#cheat-sheet)
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

### Dict

```
dict_mode :: 'copy' | 'hamt' | 'tree'

dict :: dict_mode -> dict_mt

dict_mt:size -> integer
dict_mt:empty -> boolean

dict_mt:insert :: any, any -> dict_mt
dict_mt:remove :: any -> dict_mt

dict_mt:get :: any -> any
dict_mt:has :: any -> boolean
```

## Changelog

> Coming soon...

## License

`immut.lua` is licensed under the [MIT License][license]. For more details, see the [LICENSE.md](./LICENSE.md) file in the repository.
