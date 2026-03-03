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
--- DICT
---
---

---@class immut.dict
local __dict_mt = {}
__dict_mt.__index = __dict_mt

---Returns the number of key-value pairs in the dict.
---@return integer
---@nodiscard
function __dict_mt:size()
    error 'not implemented yet'
end

---Returns `true` if the dict contains no key-value pairs, `false` otherwise.
---@return boolean
---@nodiscard
function __dict_mt:empty()
    error 'not implemented yet'
end

---Inserts a key-value pair into the dict, returning a new dict instance with the updated data.
---@param key any
---@param value any
---@return immut.dict
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:insert(key, value)
    error 'not implemented yet'
end

---Removes a key (and its associated value) from the dict, returning a new dict instance without the specified key.
---@param key any
---@return immut.dict
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:remove(key)
    error 'not implemented yet'
end

---Retrieves the value associated with a given key in the dict. If the key does not exist, it returns `nil`.
---@param key any
---@return any
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:get(key)
    error 'not implemented yet'
end

---Checks if a given key exists in the dict, returning `true` if it does and `false` otherwise.
---@param key any
---@return boolean
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:has(key)
    error 'not implemented yet'
end

---
---
--- DICT COPY
---
---

---@class immut.dict_copy : immut.dict
local __dict_copy_mt = setmetatable({}, __dict_mt)
__dict_copy_mt.__index = __dict_copy_mt

---@return immut.dict_copy
---@nodiscard
local function __dict_copy()
    return setmetatable({}, __dict_copy_mt)
end

---@return integer
---@nodiscard
function __dict_copy_mt:size()
    local size = 0

    for _ in pairs(self) do
        size = size + 1
    end

    return size
end

---@return boolean
---@nodiscard
function __dict_copy_mt:empty()
    return next(self) == nil
end

---@param key any
---@param value any
---@return immut.dict_copy
---@nodiscard
function __dict_copy_mt:insert(key, value)
    if self[key] == value then
        return self
    end

    local new_dict = __dict_copy()

    for k, v in pairs(self) do
        new_dict[k] = v
    end

    new_dict[key] = value
    return new_dict
end

---@param key any
---@return immut.dict_copy
---@nodiscard
function __dict_copy_mt:remove(key)
    if self[key] == nil then
        return self
    end

    local new_dict = __dict_copy()

    for k, v in pairs(self) do
        new_dict[k] = v
    end

    new_dict[key] = nil
    return new_dict
end

---@param key any
---@return any
---@nodiscard
function __dict_copy_mt:get(key)
    return self[key]
end

---@param key any
---@return boolean
---@nodiscard
function __dict_copy_mt:has(key)
    return self[key] ~= nil
end

---
---
--- DICT HAMT
---
---

---@class immut.dict_hamt : immut.dict
local __dict_hamt_mt = setmetatable({}, __dict_mt)
__dict_hamt_mt.__index = __dict_hamt_mt

---@return immut.dict_hamt
---@nodiscard
local function __dict_hamt()
    return setmetatable({}, __dict_hamt_mt)
end

---
---
--- DICT TREE
---
---

---@class immut.dict_tree : immut.dict
local __dict_tree_mt = setmetatable({}, __dict_mt)
__dict_tree_mt.__index = __dict_tree_mt

---@return immut.dict_tree
---@nodiscard
local function __dict_tree()
    return setmetatable({}, __dict_tree_mt)
end

---
---
--- DICT CTOR
---
---

---@alias immut.dict_mode 'copy' | 'hamt' | 'tree'

---@type table<immut.dict_mode, fun(): immut.dict>
local __DICT_CTORS = {
    copy = __dict_copy,
    hamt = __dict_hamt,
    tree = __dict_tree,
}

---@param mode immut.dict_mode
---@return immut.dict
---@nodiscard
function immut.dict(mode)
    return (__DICT_CTORS[mode] or function()
        error(string.format('invalid dict mode: %s', tostring(mode)))
    end)()
end

return immut
