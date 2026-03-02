local immut = {
    __HOMEPAGE = 'https://github.com/BlackMATov/immut.lua',
    __DESCRIPTION = 'Immutable Data Structures for Lua',
    __VERSION = '0.0.0',
    __LICENSE = [[
        MIT License

        Copyright (C) 2026, by Matvey Cherevko (blackmatov@gmail.com)

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]]
}

---
---
--- Map
---
---

---@class immut.map
---@field package __impl table
local __immut_map_mt = {}
__immut_map_mt.__index = __immut_map_mt

---@return immut.map
---@nodiscard
function immut.map()
    return setmetatable({ __impl = {} }, __immut_map_mt)
end

---@return integer
---@nodiscard
function __immut_map_mt:size()
    local size = 0

    for _ in pairs(self.__impl) do
        size = size + 1
    end

    return size
end

---@return boolean
---@nodiscard
function __immut_map_mt:empty()
    return next(self.__impl) == nil
end

---@param key any
---@param value any
---@return immut.map
---@nodiscard
function __immut_map_mt:insert(key, value)
    if key == nil then error 'key cannot be nil' end
    if value == nil then error 'value cannot be nil' end

    if self.__impl[key] == value then
        return self
    end

    local new_map = immut.map()

    for k, v in pairs(self.__impl) do
        new_map.__impl[k] = v
    end

    new_map.__impl[key] = value
    return new_map
end

---@param key any
---@return immut.map
---@nodiscard
function __immut_map_mt:remove(key)
    if key == nil then error 'key cannot be nil' end

    if self.__impl[key] == nil then
        return self
    end

    local new_map = immut.map()

    for k, v in pairs(self.__impl) do
        new_map.__impl[k] = v
    end

    new_map.__impl[key] = nil
    return new_map
end

---@param key any
---@return any
---@nodiscard
function __immut_map_mt:get(key)
    if key == nil then error 'key cannot be nil' end

    return self.__impl[key]
end

---@param key any
---@return boolean
---@nodiscard
function __immut_map_mt:has(key)
    if key == nil then error 'key cannot be nil' end

    return self.__impl[key] ~= nil
end

---
---
--- Set
---
---

---@class immut.set
---@field package __impl table
local __immut_set_mt = {}
__immut_set_mt.__index = __immut_set_mt

---@return immut.set
---@nodiscard
function immut.set()
    return setmetatable({ __impl = {} }, __immut_set_mt)
end

---@return integer
---@nodiscard
function __immut_set_mt:size()
    local size = 0

    for _ in pairs(self.__impl) do
        size = size + 1
    end

    return size
end

---@return boolean
---@nodiscard
function __immut_set_mt:empty()
    return next(self.__impl) == nil
end

---@param key any
---@return immut.set
---@nodiscard
function __immut_set_mt:insert(key)
    if key == nil then error 'key cannot be nil' end

    if self.__impl[key] then
        return self
    end

    local new_set = immut.set()

    for k in pairs(self.__impl) do
        new_set.__impl[k] = true
    end

    new_set.__impl[key] = true
    return new_set
end

---@param key any
---@return immut.set
---@nodiscard
function __immut_set_mt:remove(key)
    if key == nil then error 'key cannot be nil' end

    if self.__impl[key] == nil then
        return self
    end

    local new_set = immut.set()

    for k in pairs(self.__impl) do
        new_set.__impl[k] = true
    end

    new_set.__impl[key] = nil
    return new_set
end

---@param key any
---@return boolean
---@nodiscard
function __immut_set_mt:has(key)
    if key == nil then error 'key cannot be nil' end

    return self.__impl[key] ~= nil
end

---
---
---
---
---

return immut
