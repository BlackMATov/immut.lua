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
--- LIST API
---
---

---@class immut.list
local __list_mt = {}
__list_mt.__index = __list_mt

---Returns the number of elements in the list.
---@return integer
---@nodiscard
function __list_mt:size() error 'not implemented' end

---Returns `true` if the list contains no elements, `false` otherwise.
---@return boolean
---@nodiscard
function __list_mt:empty() error 'not implemented' end

---Retrieves the first element of the list.
---If the list is empty, it returns `nil`.
---@return any
---@nodiscard
function __list_mt:head() error 'not implemented' end

---Retrieves the last element of the list.
---If the list is empty, it returns `nil`.
---@return any
---@nodiscard
function __list_mt:last() error 'not implemented' end

---Retrieves a new list containing all elements of the original list except the first one.
---If the list is empty, it returns `nil`.
---@return immut.list
---@nodiscard
function __list_mt:tail() error 'not implemented' end

---Retrieves a new list containing all elements of the original list except the last one.
---If the list is empty, it returns `nil`.
---@return immut.list
---@nodiscard
function __list_mt:init() error 'not implemented' end

---Returns a new list with a given element added to the front of the list.
---@param head any
---@return immut.list
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __list_mt:cons(head) error 'not implemented' end

---Returns a new list with a given element added to the end of the list.
---@param last any
---@return immut.list
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __list_mt:snoc(last) error 'not implemented' end

---
---
--- DICT API
---
---

---@class immut.dict
local __dict_mt = {}
__dict_mt.__index = __dict_mt

---Returns the number of key-value pairs in the dict.
---@return integer
---@nodiscard
function __dict_mt:size() error 'not implemented' end

---Returns `true` if the dict contains no key-value pairs, `false` otherwise.
---@return boolean
---@nodiscard
function __dict_mt:empty() error 'not implemented' end

---Associates a given key with a value in the dict, returning a new dict instance with the updated key-value pair.
---If the key already exists, its value is replaced with the new value.
---@param key any
---@param value any
---@return immut.dict
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:assoc(key, value) error 'not implemented' end

---Dissociates a given key from the dict, returning a new dict instance without the specified key.
---If the key does not exist, the original dict is returned unchanged.
---@param key any
---@return immut.dict
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:dissoc(key) error 'not implemented' end

---Retrieves the value associated with a given key in the dict.
---If the key does not exist, it returns `nil`.
---@param key any
---@return any
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:lookup(key) error 'not implemented' end

---Checks if a given key exists in the dict, returning `true` if it does and `false` otherwise.
---@param key any
---@return boolean
---@nodiscard
---@diagnostic disable-next-line: unused-local
function __dict_mt:contains(key) error 'not implemented' end

---
---
--- LIST CTOR
---
---

---@alias immut.list_mode
---| 'copy' copy-based list implementation
---| 'isll' immutable singly-linked list implementation
immut.AVAILABLE_LIST_MODES = {}

---@type table<immut.list_mode, immut.list>
local __empty_lists = {}

---@param mode immut.list_mode
---@return immut.list
---@nodiscard
function immut.list(mode)
    return __empty_lists[mode] or error(string.format(
        'invalid list mode: %s, expected one of: %s',
        tostring(mode), table.concat(immut.AVAILABLE_LIST_MODES, ', ')))
end

---
---
--- DICT CTOR
---
---

---@alias immut.dict_mode
---| 'copy' copy-based dict implementation
---| 'hamt' hash array mapped trie dict implementation
---| 'tree' balanced binary search tree dict implementation
immut.AVAILABLE_DICT_MODES = {}

---@type table<immut.dict_mode, immut.dict>
local __empty_dicts = {}

---@param mode immut.dict_mode
---@return immut.dict
---@nodiscard
function immut.dict(mode)
    return __empty_dicts[mode] or error(string.format(
        'invalid dict mode: %s, expected one of: %s',
        tostring(mode), table.concat(immut.AVAILABLE_DICT_MODES, ', ')))
end

---
---
--- COPY LIST IMPLEMENTATION
---
---

---@class immut.copy_list : immut.list
---@field package __size integer
---@field package __elems any[]
local __copy_list_mt = setmetatable({}, __list_mt)
__copy_list_mt.__index = __copy_list_mt

local function copy_list_new()
    return setmetatable({ __size = 0, __elems = {} }, __copy_list_mt)
end

__empty_lists['copy'] = copy_list_new()
immut.AVAILABLE_LIST_MODES[#immut.AVAILABLE_LIST_MODES + 1] = 'copy'

function __copy_list_mt:size()
    return self.__size
end

function __copy_list_mt:empty()
    return self.__size == 0
end

function __copy_list_mt:head()
    return self.__elems[1]
end

function __copy_list_mt:last()
    return self.__elems[self.__size]
end

function __copy_list_mt:tail()
    if self.__size == 0 then
        return nil
    end

    local tail = copy_list_new()

    for i = 2, self.__size do
        tail.__elems[i - 1] = self.__elems[i]
    end

    tail.__size = self.__size - 1

    return tail
end

function __copy_list_mt:init()
    if self.__size == 0 then
        return nil
    end

    local init = copy_list_new()

    for i = 1, self.__size - 1 do
        init.__elems[i] = self.__elems[i]
    end

    init.__size = self.__size - 1

    return init
end

function __copy_list_mt:cons(head)
    local new_list = copy_list_new()

    new_list.__elems[1] = head

    for i = 1, self.__size do
        new_list.__elems[i + 1] = self.__elems[i]
    end

    new_list.__size = self.__size + 1

    return new_list
end

function __copy_list_mt:snoc(last)
    local new_list = copy_list_new()

    for i = 1, self.__size do
        new_list.__elems[i] = self.__elems[i]
    end

    new_list.__elems[self.__size + 1] = last
    new_list.__size = self.__size + 1

    return new_list
end

---
---
--- COPY DICT IMPLEMENTATION
---
---

---@class immut.copy_dict : immut.dict
---@field package __size integer
---@field package __pairs table<any, any>
local __copy_dict_mt = setmetatable({}, __dict_mt)
__copy_dict_mt.__index = __copy_dict_mt

local function copy_dict_new()
    return setmetatable({ __size = 0, __pairs = {} }, __copy_dict_mt)
end

__empty_dicts['copy'] = copy_dict_new()
immut.AVAILABLE_DICT_MODES[#immut.AVAILABLE_DICT_MODES + 1] = 'copy'

function __copy_dict_mt:size()
    return self.__size
end

function __copy_dict_mt:empty()
    return self.__size == 0
end

function __copy_dict_mt:assoc(key, value)
    local self_value = self.__pairs[key]

    if self_value == value then
        return self
    end

    local new_dict = copy_dict_new()

    for k, v in pairs(self.__pairs) do
        new_dict.__pairs[k] = v
    end

    new_dict.__pairs[key] = value
    new_dict.__size = self.__size + (self_value == nil and 1 or 0)

    return new_dict
end

function __copy_dict_mt:dissoc(key)
    local self_value = self.__pairs[key]

    if self_value == nil then
        return self
    end

    local new_dict = copy_dict_new()

    for k, v in pairs(self.__pairs) do
        new_dict.__pairs[k] = v
    end

    new_dict.__pairs[key] = nil
    new_dict.__size = self.__size - 1

    return new_dict
end

function __copy_dict_mt:lookup(key)
    return self.__pairs[key]
end

function __copy_dict_mt:contains(key)
    return self.__pairs[key] ~= nil
end

---
---
--- HAMT IMPLEMENTATION
---
---

---@alias immut.hamt_key any
---@alias immut.hamt_hash integer
---@alias immut.hamt_value any

---@class immut.hamt_node

---@diagnostic disable-next-line: unused-local
local function __hamt_hash(key)
    return 0
end

---@param node immut.hamt_node
---@param shift integer
---@param key immut.hamt_key
---@param hash immut.hamt_hash
---@param value immut.hamt_value
---@return immut.hamt_node new_node
---@return integer size_delta
---@return boolean changed
---@nodiscard
---@diagnostic disable-next-line: unused-local
local function __hamt_assoc(node, shift, key, hash, value)
end

---@param node immut.hamt_node
---@param shift integer
---@param key immut.hamt_key
---@param hash immut.hamt_hash
---@return immut.hamt_node new_node
---@return integer size_delta
---@return boolean changed
---@nodiscard
---@diagnostic disable-next-line: unused-local
local function __hamt_dissoc(node, shift, key, hash)
end

---@param node immut.hamt_node
---@param shift integer
---@param key immut.hamt_key
---@param hash immut.hamt_hash
---@return immut.hamt_value value
---@nodiscard
---@diagnostic disable-next-line: unused-local
local function __hamt_lookup(node, shift, key, hash)
end

---
---
--- HAMT DICT IMPLEMENTATION
---
---

---@class immut.hamt_dict : immut.dict
---@field package __size integer
---@field package __root immut.hamt_node
local __hamt_dict_mt = setmetatable({}, __dict_mt)
__hamt_dict_mt.__index = __hamt_dict_mt

local function hamt_dict_new()
    return setmetatable({ __size = 0, __root = nil }, __hamt_dict_mt)
end

__empty_dicts['hamt'] = hamt_dict_new()
immut.AVAILABLE_DICT_MODES[#immut.AVAILABLE_DICT_MODES + 1] = 'hamt'

function __hamt_dict_mt:size()
    return self.__size
end

function __hamt_dict_mt:empty()
    return self.__size == 0
end

function __hamt_dict_mt:assoc(key, value)
    local hash = __hamt_hash(key)

    local new_root, size_delta, changed = __hamt_assoc(self.__root, 0, key, hash, value)

    if not changed then
        return self
    end

    return setmetatable({ __size = self.__size + size_delta, __root = new_root }, __hamt_dict_mt)
end

function __hamt_dict_mt:dissoc(key)
    local hash = __hamt_hash(key)

    local new_root, size_delta, changed = __hamt_dissoc(self.__root, 0, key, hash)

    if not changed then
        return self
    end

    return setmetatable({ __size = self.__size + size_delta, __root = new_root }, __hamt_dict_mt)
end

function __hamt_dict_mt:lookup(key)
    return __hamt_lookup(self.__root, 0, key, __hamt_hash(key))
end

function __hamt_dict_mt:contains(key)
    return __hamt_lookup(self.__root, 0, key, __hamt_hash(key)) ~= nil
end

---
---
---
---
---

return immut
