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
local __immut_map_mt = {}
__immut_map_mt.__index = __immut_map_mt

local __immut_map_empty = setmetatable({}, __immut_map_mt)

---@return immut.map
---@nodiscard
function immut.map()
    return __immut_map_empty
end

---@return integer
---@nodiscard
function __immut_map_mt:size()
    error 'not implemented yet'
end

---@return boolean
---@nodiscard
function __immut_map_mt:empty()
    error 'not implemented yet'
end

---@param key any
---@param value any
---@return immut.map
---@nodiscard
function __immut_map_mt:insert(key, value)
    error 'not implemented yet'
end

---@param key any
---@return immut.map
---@nodiscard
function __immut_map_mt:remove(key)
    error 'not implemented yet'
end

---@param key any
---@return any
---@nodiscard
function __immut_map_mt:get(key)
    error 'not implemented yet'
end

---@param key any
---@return boolean
---@nodiscard
function __immut_map_mt:has(key)
    error 'not implemented yet'
end

---
---
--- Set
---
---

---@class immut.set
local __immut_set_mt = {}
__immut_set_mt.__index = __immut_set_mt

local __immut_set_empty = setmetatable({}, __immut_set_mt)

---@return immut.set
---@nodiscard
function immut.set()
    return __immut_set_empty
end

---@return integer
---@nodiscard
function __immut_set_mt:size()
    error 'not implemented yet'
end

---@return boolean
---@nodiscard
function __immut_set_mt:empty()
    error 'not implemented yet'
end

---@param key any
---@return immut.set
---@nodiscard
function __immut_set_mt:insert(key)
    error 'not implemented yet'
end

---@param key any
---@return immut.set
---@nodiscard
function __immut_set_mt:remove(key)
    error 'not implemented yet'
end

---@param key any
---@return boolean
---@nodiscard
function __immut_set_mt:has(key)
    error 'not implemented yet'
end

---
---
---
---
---

return immut
