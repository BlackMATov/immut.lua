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
--- MAP
---
---

---@class immut.map
local __map_mt = {}
__map_mt.__index = __map_mt

---Returns the number of key-value pairs in the map.
---@return integer
---@nodiscard
function __map_mt:size()
    error 'not implemented yet'
end

---Returns `true` if the map contains no key-value pairs, `false` otherwise.
---@return boolean
---@nodiscard
function __map_mt:empty()
    error 'not implemented yet'
end

---Inserts a key-value pair into the map, returning a new map instance with the updated data.
---@param key any
---@param value any
---@return immut.map
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __map_mt:insert(key, value)
    error 'not implemented yet'
end

---Removes a key (and its associated value) from the map, returning a new map instance without the specified key.
---@param key any
---@return immut.map
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __map_mt:remove(key)
    error 'not implemented yet'
end

---Retrieves the value associated with a given key in the map. If the key does not exist, it returns `nil`.
---@param key any
---@return any
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __map_mt:get(key)
    error 'not implemented yet'
end

---Checks if a given key exists in the map, returning `true` if it does and `false` otherwise.
---@param key any
---@return boolean
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __map_mt:has(key)
    error 'not implemented yet'
end

---
---
--- MAP COPY
---
---

---@class immut.map_copy : immut.map
local __map_copy_mt = setmetatable({}, __map_mt)
__map_copy_mt.__index = __map_copy_mt

---@return immut.map_copy
---@nodiscard
local function __map_copy()
    return setmetatable({}, __map_copy_mt)
end

---@return integer
---@nodiscard
function __map_copy_mt:size()
    local size = 0

    for _ in pairs(self) do
        size = size + 1
    end

    return size
end

---@return boolean
---@nodiscard
function __map_copy_mt:empty()
    return next(self) == nil
end

---@param key any
---@param value any
---@return immut.map_copy
---@nodiscard
function __map_copy_mt:insert(key, value)
    if self[key] == value then
        return self
    end

    local new_map = __map_copy()

    for k, v in pairs(self) do
        new_map[k] = v
    end

    new_map[key] = value
    return new_map
end

---@param key any
---@return immut.map_copy
---@nodiscard
function __map_copy_mt:remove(key)
    if self[key] == nil then
        return self
    end

    local new_map = __map_copy()

    for k, v in pairs(self) do
        new_map[k] = v
    end

    new_map[key] = nil
    return new_map
end

---@param key any
---@return any
---@nodiscard
function __map_copy_mt:get(key)
    return self[key]
end

---@param key any
---@return boolean
---@nodiscard
function __map_copy_mt:has(key)
    return self[key] ~= nil
end

---
---
--- MAP HAMT
---
---

---@class immut.map_hamt : immut.map
local __map_hamt_mt = setmetatable({}, __map_mt)
__map_hamt_mt.__index = __map_hamt_mt

---@return immut.map_hamt
---@nodiscard
local function __map_hamt()
    return setmetatable({}, __map_hamt_mt)
end

---
---
--- MAP TREE
---
---

---@class immut.map_tree : immut.map
local __map_tree_mt = setmetatable({}, __map_mt)
__map_tree_mt.__index = __map_tree_mt

---@return immut.map_tree
---@nodiscard
local function __map_tree()
    return setmetatable({}, __map_tree_mt)
end

---
---
--- MAP CTOR
---
---

---@alias immut.map_mode 'copy' | 'hamt' | 'tree'

---@type table<immut.map_mode, fun(): immut.map>
local __MAP_CTORS = {
    copy = __map_copy,
    hamt = __map_hamt,
    tree = __map_tree,
}

---@param mode immut.map_mode
---@return immut.map
---@nodiscard
function immut.map(mode)
    return (__MAP_CTORS[mode] or function()
        error(string.format('invalid map mode: %s', tostring(mode)))
    end)()
end

---
---
--- SET
---
---

---@class immut.set
local __set_mt = {}
__set_mt.__index = __set_mt

---Returns the number of keys in the set.
---@return integer
---@nodiscard
function __set_mt:size()
    error 'not implemented yet'
end

---Returns `true` if the set contains no keys, `false` otherwise.
---@return boolean
---@nodiscard
function __set_mt:empty()
    error 'not implemented yet'
end

---Inserts a key into the set, returning a new set instance with the updated data.
---@param key any
---@return immut.set
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __set_mt:insert(key)
    error 'not implemented yet'
end

---Removes a key from the set, returning a new set instance without the specified key.
---@param key any
---@return immut.set
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __set_mt:remove(key)
    error 'not implemented yet'
end

---Checks if a given key exists in the set, returning `true` if it does and `false` otherwise.
---@param key any
---@return boolean
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __set_mt:has(key)
    error 'not implemented yet'
end

---
---
--- SET COPY
---
---

---@class immut.set_copy : immut.set
local __set_copy_mt = setmetatable({}, __set_mt)
__set_copy_mt.__index = __set_copy_mt

---@return immut.set_copy
---@nodiscard
local function __set_copy()
    return setmetatable({}, __set_copy_mt)
end

---@return integer
---@nodiscard
function __set_copy_mt:size()
    local size = 0

    for _ in pairs(self) do
        size = size + 1
    end

    return size
end

---@return boolean
---@nodiscard
function __set_copy_mt:empty()
    return next(self) == nil
end

---@param key any
---@return immut.set_copy
---@nodiscard
function __set_copy_mt:insert(key)
    if self[key] then
        return self
    end

    local new_set = __set_copy()

    for v in pairs(self) do
        new_set[v] = true
    end

    new_set[key] = true
    return new_set
end

---@param key any
---@return immut.set_copy
---@nodiscard
function __set_copy_mt:remove(key)
    if self[key] == nil then
        return self
    end

    local new_set = __set_copy()

    for v in pairs(self) do
        new_set[v] = true
    end

    new_set[key] = nil
    return new_set
end

---@param key any
---@return boolean
---@nodiscard
function __set_copy_mt:has(key)
    return self[key] ~= nil
end

---
---
--- SET HAMT
---
---

---@class immut.set_hamt : immut.set
local __set_hamt_mt = setmetatable({}, __set_mt)
__set_hamt_mt.__index = __set_hamt_mt

---@return immut.set_hamt
---@nodiscard
local function __set_hamt()
    return setmetatable({}, __set_hamt_mt)
end

---
---
--- SET TREE
---
---

---@class immut.set_tree : immut.set
local __set_tree_mt = setmetatable({}, __set_mt)
__set_tree_mt.__index = __set_tree_mt

---@return immut.set_tree
---@nodiscard
local function __set_tree()
    return setmetatable({}, __set_tree_mt)
end

---
---
--- SET CTOR
---
---

---@alias immut.set_mode 'copy' | 'hamt' | 'tree'

---@type table<immut.set_mode, fun(): immut.set>
local __SET_CTORS = {
    copy = __set_copy,
    hamt = __set_hamt,
    tree = __set_tree,
}

---@param mode immut.set_mode
---@return immut.set
---@nodiscard
function immut.set(mode)
    return (__SET_CTORS[mode] or function()
        error(string.format('invalid set mode: %s', tostring(mode)))
    end)()
end

return immut
