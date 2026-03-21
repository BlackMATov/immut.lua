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

local __lua_error = error
local __lua_string_byte = string.byte
local __lua_string_format = string.format
local __lua_tostring = tostring
local __lua_type = type

---
---
--- LUA EXTENSIONS
---
---

---@type fun(nseq?: integer): table
local __opt_table_new = (function()
    -- https://luajit.org/extensions.html
    -- https://www.lua.org/manual/5.5/manual.html#pdf-table.create
    -- https://create.roblox.com/docs/reference/engine/libraries/table#create
    -- https://forum.defold.com/t/solved-is-luajit-table-new-function-available-in-defold/78623

    do
        ---@diagnostic disable-next-line: deprecated, undefined-field
        local table_new = table and table.new
        if table_new then return function(nseq) return table_new(nseq or 0, 0) end end
    end

    do
        ---@diagnostic disable-next-line: deprecated, undefined-field
        local table_create = table and table.create
        if table_create then return function(nseq) return table_create(nseq or 0) end end
    end

    if package and package.loaded then
        local loaded_table_create = package.loaded.table and package.loaded.table.create
        if loaded_table_create then return function(nseq) return loaded_table_create(nseq or 0) end end
    end

    if package and package.preload then
        local table_new_loader = package.preload['table.new']
        local table_new = table_new_loader and table_new_loader()
        if table_new then return function(nseq) return table_new(nseq or 0, 0) end end
    end
end)()

---@type fun(a1: table, f: integer, e: integer, t: integer, a2?: table): table
local __opt_table_move = (function()
    -- https://luajit.org/extensions.html
    -- https://www.lua.org/manual/5.3/manual.html#pdf-table.move
    -- https://create.roblox.com/docs/reference/engine/libraries/table#move
    -- https://forum.defold.com/t/solved-is-luajit-table-new-function-available-in-defold/78623
    -- https://github.com/LuaJIT/LuaJIT/blob/v2.1/src/lib_table.c#L132

    do
        ---@diagnostic disable-next-line: deprecated, undefined-field
        local table_move = table and table.move
        if table_move then return table_move end
    end

    if package and package.loaded then
        local loaded_table_move = package.loaded.table and package.loaded.table.move
        if loaded_table_move then return loaded_table_move end
    end

    if package and package.preload then
        local table_move_loader = package.preload['table.move']
        local table_move = table_move_loader and table_move_loader()
        if table_move then return table_move end
    end
end)()

---
---
--- NUMBER HASHING
---
---

---@param v number
---@return integer
---@nodiscard
local function __immut_num_hash(v)
    if v * 0 ~= 0 then
        if v ~= v then return 0xDEADBEEF end
        return v < 0 and 0xCAFEBABE or 0xBABECAFE
    end

    local h = 0x517CC1B7

    if v < 0 then
        h = 0x85EBCA77
        v = -v
    end

    local f_part = v % 1

    if f_part == 0 then
        local i_part_lo = v % 2 ^ 32
        local i_part_hi = (v - i_part_lo) / 2 ^ 32

        h = (h * 0x19660D + i_part_lo * 1013 + i_part_hi) % 2 ^ 32

        local t = (h - h % 2 ^ 16) / 2 ^ 16
        h = (h + t * 0x9E3779B1) % 2 ^ 32

        h = (h * 0x19660D) % 2 ^ 32
    else
        v = v - f_part

        local i_part_lo = v % 2 ^ 32
        local i_part_hi = (v - i_part_lo) / 2 ^ 32

        f_part = f_part * 2 ^ 32
        local f_part_hi = f_part - f_part % 1
        f_part = (f_part - f_part_hi) * 2 ^ 32
        local f_part_lo = f_part - f_part % 1

        h = (h * 0x19660D + i_part_lo * 1013 + i_part_hi) % 2 ^ 32

        local t = (h - h % 2 ^ 16) / 2 ^ 16
        h = (h + t * 0x9E3779B1) % 2 ^ 32

        h = (h * 0x19660D + f_part_hi * 1013 + f_part_lo) % 2 ^ 32
    end

    return h
end

---
---
--- STRING HASHING
---
---

---@param s string
---@return integer
---@nodiscard
local function __immut_str_hash(s)
    local i, l, h = 1, #s, 5381

    while i <= l - 15 do
        local c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16 = __lua_string_byte(s, i, i + 15)

        h = h * 33 ^ 4 + c1 * 33 ^ 3 + c2 * 33 ^ 2 + c3 * 33 + c4
        h = h % 2 ^ 32

        h = h * 33 ^ 4 + c5 * 33 ^ 3 + c6 * 33 ^ 2 + c7 * 33 + c8
        h = h % 2 ^ 32

        h = h * 33 ^ 4 + c9 * 33 ^ 3 + c10 * 33 ^ 2 + c11 * 33 + c12
        h = h % 2 ^ 32

        h = h * 33 ^ 4 + c13 * 33 ^ 3 + c14 * 33 ^ 2 + c15 * 33 + c16
        h = h % 2 ^ 32

        i = i + 16
    end

    while i <= l - 7 do
        local c1, c2, c3, c4, c5, c6, c7, c8 = __lua_string_byte(s, i, i + 7)

        h = h * 33 ^ 4 + c1 * 33 ^ 3 + c2 * 33 ^ 2 + c3 * 33 + c4
        h = h % 2 ^ 32

        h = h * 33 ^ 4 + c5 * 33 ^ 3 + c6 * 33 ^ 2 + c7 * 33 + c8
        h = h % 2 ^ 32

        i = i + 8
    end

    while i <= l - 3 do
        local c1, c2, c3, c4 = __lua_string_byte(s, i, i + 3)

        h = h * 33 ^ 4 + c1 * 33 ^ 3 + c2 * 33 ^ 2 + c3 * 33 + c4
        h = h % 2 ^ 32

        i = i + 4
    end

    while i <= l - 1 do
        local c1, c2 = __lua_string_byte(s, i, i + 1)

        h = h * 33 ^ 2 + c1 * 33 + c2
        h = h % 2 ^ 32

        i = i + 2
    end

    while i <= l do
        local c = __lua_string_byte(s, i)

        h = h * 33 + c
        h = h % 2 ^ 32

        i = i + 1
    end

    return h
end

---
---
--- BITMAP UTILITIES
---
---

---@type integer[]
local __immut_pow2 = {
    1, 2, 4, 8, 16, 32, 64, 128,
    256, 512, 1024, 2048, 4096, 8192, 16384, 32768,
    65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608,
    16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483648,
}

---@type integer[]
local __immut_popcount8 = {
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8,
}

---@param v integer
---@return integer
---@nodiscard
local function __immut_popcount32(v)
    local pc8 = __immut_popcount8

    local bb1 = v % 2 ^ 8; v = (v - bb1) / 2 ^ 8
    local bb2 = v % 2 ^ 8; v = (v - bb2) / 2 ^ 8
    local bb3 = v % 2 ^ 8; v = (v - bb3) / 2 ^ 8
    local bb4 = v

    return pc8[bb1 + 1] + pc8[bb2 + 1] + pc8[bb3 + 1] + pc8[bb4 + 1]
end

---
---
--- HAMT IMPLEMENTATION
---
---

---@alias immut.hamt_key any
---@alias immut.hamt_hash integer
---@alias immut.hamt_value any

---@alias immut.hamt_node table<any, any>
---@alias immut.hamt_node_leaf immut.hamt_node
---@alias immut.hamt_node_bitmap immut.hamt_node
---@alias immut.hamt_node_collision immut.hamt_node

-- HAMT Constants
local __HAMT_BITS = 5
local __HAMT_SIZE = 2 ^ __HAMT_BITS

-- HAMT Node Types
local __HAMT_LEAF = 1
local __HAMT_BITMAP = 2
local __HAMT_COLLISION = 3

-- HAMT Leaf Node Layout: {LEAF, key, hash, value}
local __HAMT_LEAF_NODE_KEY = 2
local __HAMT_LEAF_NODE_HASH = 3
local __HAMT_LEAF_NODE_VALUE = 4

-- HAMT Bitmap Node Layout: {BITMAP, arity, bitmap, child1, child2, ...}
local __HAMT_BITMAP_NODE_ARITY = 2
local __HAMT_BITMAP_NODE_BITMAP = 3
local __HAMT_BITMAP_NODE_CHILDREN = 4

-- HAMT Collision Node Layout: {COLLISION, hash, arity, key1, value1, key2, value2, ...}
local __HAMT_COLLISION_NODE_HASH = 2
local __HAMT_COLLISION_NODE_ARITY = 3
local __HAMT_COLLISION_NODE_ENTRIES = 4

---@param hash immut.hamt_hash
---@param level integer
---@return integer
---@nodiscard
local function __hamt_frag(hash, level)
    local base = __immut_pow2[(level - 1) * __HAMT_BITS + 1]
    return __immut_pow2[((hash - hash % base) / base) % __HAMT_SIZE + 1]
end

---@param key immut.hamt_key
---@return immut.hamt_hash
---@nodiscard
local function __hamt_hash(key)
    local key_type = __lua_type(key)

    if key_type == 'number' then
        return __immut_num_hash(key)
    elseif key_type == 'string' then
        return __immut_str_hash(key)
    elseif key_type == 'boolean' then
        return key and 0x93C467E3 or 0x7B5A4F1E
    else
        __lua_error(__lua_string_format(
            'unsupported key type for hamt dict: %s',
            key_type))
    end
end

---@param level integer
---@param hash1 immut.hamt_hash
---@param node1 immut.hamt_node
---@param hash2 immut.hamt_hash
---@param node2 immut.hamt_node
---@return immut.hamt_node_bitmap
---@nodiscard
local function __hamt_bitmap_pack(level, hash1, node1, hash2, node2)
    local hash1_frag = __hamt_frag(hash1, level)
    local hash2_frag = __hamt_frag(hash2, level)

    if hash1_frag == hash2_frag then
        local new_node = __hamt_bitmap_pack(level + 1, hash1, node1, hash2, node2)
        return { __HAMT_BITMAP, 1, hash1_frag, new_node }
    end

    if hash1_frag < hash2_frag then
        return { __HAMT_BITMAP, 2, hash1_frag + hash2_frag, node1, node2 }
    else
        return { __HAMT_BITMAP, 2, hash1_frag + hash2_frag, node2, node1 }
    end
end

---@param arity integer
---@param bitmap integer
---@return immut.hamt_node_bitmap
---@nodiscard
local function __hamt_bitmap_node(arity, bitmap)
    ---@type immut.hamt_node_bitmap
    local node

    if __opt_table_new then
        node = __opt_table_new(3 + arity)
        node[1], node[2], node[3] = __HAMT_BITMAP, arity, bitmap
    else
        if arity <= 16 then
            if arity <= 8 then
                node = { __HAMT_BITMAP, arity, bitmap,
                    0, 0, 0, 0, 0, 0, 0, 0,
                }
            else
                node = { __HAMT_BITMAP, arity, bitmap,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                }
            end
        else
            if arity <= 24 then
                node = { __HAMT_BITMAP, arity, bitmap,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                }
            else
                node = { __HAMT_BITMAP, arity, bitmap,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                }
            end
        end
    end

    return node
end

---@param hash immut.hamt_hash
---@param arity integer
---@return immut.hamt_node_collision
---@nodiscard
local function __hamt_collision_node(hash, arity)
    ---@type immut.hamt_node_collision
    local node

    if __opt_table_new then
        node = __opt_table_new(3 + 2 * arity)
        node[1], node[2], node[3] = __HAMT_COLLISION, hash, arity
    else
        if arity <= 4 then
            if arity <= 2 then
                node = { __HAMT_COLLISION, hash, arity,
                    0, 0, 0, 0,
                }
            else
                node = { __HAMT_COLLISION, hash, arity,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                }
            end
        else
            if arity <= 6 then
                node = { __HAMT_COLLISION, hash, arity,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                }
            else
                node = { __HAMT_COLLISION, hash, arity,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                }
            end
        end
    end

    return node
end

---@param node? immut.hamt_node
---@param level integer
---@param key immut.hamt_key
---@param hash immut.hamt_hash
---@param value immut.hamt_value
---@return immut.hamt_node new_node
---@return integer size_delta
---@nodiscard
local function __hamt_assoc(node, level, key, hash, value)
    if not node then
        return { __HAMT_LEAF, key, hash, value }, 1
    end

    ---@type integer
    local node_type = node[1]

    if node_type == __HAMT_LEAF then
        local node_key = node[__HAMT_LEAF_NODE_KEY]
        local node_hash = node[__HAMT_LEAF_NODE_HASH]

        if node_key == key then
            local node_value = node[__HAMT_LEAF_NODE_VALUE]

            if node_value == value then
                return node, 0
            end

            return { __HAMT_LEAF, key, hash, value }, 0
        elseif node_hash == hash then
            local node_value = node[__HAMT_LEAF_NODE_VALUE]
            return { __HAMT_COLLISION, hash, 2, node_key, node_value, key, value }, 1
        else
            local new_node = { __HAMT_LEAF, key, hash, value }
            return __hamt_bitmap_pack(level, node_hash, node, hash, new_node), 1
        end
    elseif node_type == __HAMT_BITMAP then
        local pc32 = __immut_popcount32

        ---@type integer
        local node_arity = node[__HAMT_BITMAP_NODE_ARITY]

        ---@type integer
        local node_bitmap = node[__HAMT_BITMAP_NODE_BITMAP]

        local fst_child = __HAMT_BITMAP_NODE_CHILDREN
        local lst_child = fst_child + node_arity - 1

        local hash_frag = __hamt_frag(hash, level)

        if node_bitmap % (hash_frag + hash_frag) < hash_frag then
            local bit_child = pc32(node_bitmap % hash_frag) + fst_child

            local new_node = __hamt_bitmap_node(node_arity + 1, node_bitmap + hash_frag)

            if __opt_table_move then
                __opt_table_move(node, fst_child, bit_child - 1, fst_child, new_node)
                new_node[bit_child] = { __HAMT_LEAF, key, hash, value }
                __opt_table_move(node, bit_child, lst_child, bit_child + 1, new_node)
            else
                for i = fst_child, bit_child - 1 do new_node[i] = node[i] end
                new_node[bit_child] = { __HAMT_LEAF, key, hash, value }
                for i = bit_child, lst_child do new_node[i + 1] = node[i] end
            end

            return new_node, 1
        else
            local bit_child = pc32(node_bitmap % hash_frag) + fst_child
            local bit_child_node = node[bit_child]

            local new_child_node, size_delta = __hamt_assoc(
                bit_child_node, level + 1, key, hash, value)

            if new_child_node == bit_child_node then
                return node, 0
            end

            local new_node = __hamt_bitmap_node(node_arity, node_bitmap)

            if __opt_table_move then
                __opt_table_move(node, fst_child, lst_child, fst_child, new_node)
                new_node[bit_child] = new_child_node
            else
                for i = fst_child, lst_child do new_node[i] = node[i] end
                new_node[bit_child] = new_child_node
            end

            return new_node, size_delta
        end
    elseif node_type == __HAMT_COLLISION then
        local node_hash = node[__HAMT_COLLISION_NODE_HASH]
        local node_arity = node[__HAMT_COLLISION_NODE_ARITY]

        if node_hash ~= hash then
            local new_node = { __HAMT_LEAF, key, hash, value }
            return __hamt_bitmap_pack(level, node_hash, node, hash, new_node), 1
        end

        local fst_entry = __HAMT_COLLISION_NODE_ENTRIES
        local lst_entry = fst_entry + 2 * node_arity - 2

        for i = fst_entry, lst_entry, 2 do
            local entry_key = node[i]

            if entry_key == key then
                local entry_value = node[i + 1]

                if entry_value == value then
                    return node, 0
                end

                local new_node = __hamt_collision_node(node_hash, node_arity)

                if __opt_table_move then
                    __opt_table_move(node, fst_entry, i - 1, fst_entry, new_node)
                    new_node[i], new_node[i + 1] = key, value
                    __opt_table_move(node, i + 2, lst_entry + 1, i + 2, new_node)
                else
                    for j = fst_entry, i - 1 do new_node[j] = node[j] end
                    new_node[i], new_node[i + 1] = key, value
                    for j = i + 2, lst_entry + 1 do new_node[j] = node[j] end
                end

                return new_node, 0
            end
        end

        local new_node = __hamt_collision_node(node_hash, node_arity + 1)

        if __opt_table_move then
            __opt_table_move(node, fst_entry, lst_entry + 1, fst_entry, new_node)
            new_node[lst_entry + 2], new_node[lst_entry + 3] = key, value
        else
            for j = fst_entry, lst_entry + 1 do new_node[j] = node[j] end
            new_node[lst_entry + 2], new_node[lst_entry + 3] = key, value
        end

        return new_node, 1
    else
        __lua_error(__lua_string_format(
            'invalid hamt node type: %s',
            __lua_tostring(node_type)))
    end
end

---@param node? immut.hamt_node
---@param level integer
---@param key immut.hamt_key
---@param hash immut.hamt_hash
---@return immut.hamt_node? new_node
---@return integer size_delta
---@nodiscard
local function __hamt_dissoc(node, level, key, hash)
    if not node then
        return nil, 0
    end

    ---@type integer
    local node_type = node[1]

    if node_type == __HAMT_LEAF then
        local node_key = node[__HAMT_LEAF_NODE_KEY]

        if node_key == key then
            return nil, -1
        end

        return node, 0
    elseif node_type == __HAMT_BITMAP then
        local pc32 = __immut_popcount32

        ---@type integer
        local node_arity = node[__HAMT_BITMAP_NODE_ARITY]

        ---@type integer
        local node_bitmap = node[__HAMT_BITMAP_NODE_BITMAP]

        local fst_child = __HAMT_BITMAP_NODE_CHILDREN
        local lst_child = fst_child + node_arity - 1

        local hash_frag = __hamt_frag(hash, level)

        if node_bitmap % (hash_frag + hash_frag) < hash_frag then
            return node, 0
        else
            local bit_child = pc32(node_bitmap % hash_frag) + fst_child
            local bit_child_node = node[bit_child]

            local new_child_node, size_delta = __hamt_dissoc(
                bit_child_node, level + 1, key, hash)

            if new_child_node == bit_child_node then
                return node, 0
            end

            if new_child_node then
                if node_arity == 1 then
                    local new_child_node_type = new_child_node[1]

                    if new_child_node_type ~= __HAMT_BITMAP then
                        return new_child_node, size_delta
                    end
                end

                local new_node = __hamt_bitmap_node(node_arity, node_bitmap)

                if __opt_table_move then
                    __opt_table_move(node, fst_child, lst_child, fst_child, new_node)
                    new_node[bit_child] = new_child_node
                else
                    for i = fst_child, lst_child do new_node[i] = node[i] end
                    new_node[bit_child] = new_child_node
                end

                return new_node, size_delta
            else
                if node_arity == 1 then
                    return nil, size_delta
                end

                if node_arity == 2 then
                    local rem_i = bit_child == fst_child and lst_child or fst_child

                    local rem_node = node[rem_i]
                    local rem_node_type = rem_node[1]

                    if rem_node_type ~= __HAMT_BITMAP then
                        return rem_node, size_delta
                    end
                end

                local new_node = __hamt_bitmap_node(node_arity - 1, node_bitmap - hash_frag)

                if __opt_table_move then
                    __opt_table_move(node, fst_child, bit_child - 1, fst_child, new_node)
                    __opt_table_move(node, bit_child + 1, lst_child, bit_child, new_node)
                else
                    for i = fst_child, bit_child - 1 do new_node[i] = node[i] end
                    for i = bit_child + 1, lst_child do new_node[i - 1] = node[i] end
                end

                return new_node, size_delta
            end
        end
    elseif node_type == __HAMT_COLLISION then
        local node_hash = node[__HAMT_COLLISION_NODE_HASH]
        local node_arity = node[__HAMT_COLLISION_NODE_ARITY]

        if node_hash ~= hash then
            return node, 0
        end

        local fst_entry = __HAMT_COLLISION_NODE_ENTRIES
        local lst_entry = fst_entry + 2 * node_arity - 2

        for i = fst_entry, lst_entry, 2 do
            local entry_key = node[i]

            if entry_key == key then
                if node_arity == 2 then
                    local rem_i = i == fst_entry and lst_entry or fst_entry
                    return { __HAMT_LEAF, node[rem_i], node_hash, node[rem_i + 1] }, -1
                end

                local new_node = __hamt_collision_node(node_hash, node_arity - 1)

                if __opt_table_move then
                    __opt_table_move(node, fst_entry, i - 1, fst_entry, new_node)
                    __opt_table_move(node, i + 2, lst_entry + 1, i, new_node)
                else
                    for j = fst_entry, i - 1 do new_node[j] = node[j] end
                    for j = i + 2, lst_entry + 1 do new_node[j - 2] = node[j] end
                end

                return new_node, -1
            end
        end

        return node, 0
    else
        __lua_error(__lua_string_format(
            'invalid hamt node type: %s',
            __lua_tostring(node_type)))
    end
end

---@param node? immut.hamt_node
---@param level integer
---@param key immut.hamt_key
---@param hash immut.hamt_hash
---@return immut.hamt_value? value
---@nodiscard
local function __hamt_lookup(node, level, key, hash)
    local pc32 = __immut_popcount32

    while node do
        local node_type = node[1]

        if node_type == __HAMT_LEAF then
            local node_key = node[__HAMT_LEAF_NODE_KEY]
            if node_key ~= key then return nil end
            local node_value = node[__HAMT_LEAF_NODE_VALUE]
            return node_value
        elseif node_type == __HAMT_BITMAP then
            local node_bitmap = node[__HAMT_BITMAP_NODE_BITMAP]

            local hash_frag = __hamt_frag(hash, level)

            if node_bitmap % (hash_frag + hash_frag) < hash_frag then
                return nil
            end

            local fst_child = __HAMT_BITMAP_NODE_CHILDREN
            local bit_child = pc32(node_bitmap % hash_frag) + fst_child

            node, level = node[bit_child], level + 1
        elseif node_type == __HAMT_COLLISION then
            local node_hash = node[__HAMT_COLLISION_NODE_HASH]
            if node_hash ~= hash then return nil end

            local node_arity = node[__HAMT_COLLISION_NODE_ARITY]

            local fst_entry = __HAMT_COLLISION_NODE_ENTRIES
            local lst_entry = fst_entry + 2 * node_arity - 2

            for i = fst_entry, lst_entry, 2 do
                local entry_key = node[i]

                if entry_key == key then
                    local entry_value = node[i + 1]
                    return entry_value
                end
            end

            return nil
        else
            __lua_error(__lua_string_format(
                'invalid hamt node type: %s',
                __lua_tostring(node_type)))
        end
    end
end

---
---
--- LIST IMPLEMENTATION
---
---

---@class immut.list
---@field package [1] any head
---@field package [2] immut.list? tail

local __LIST_HEAD = 1
local __LIST_TAIL = 2

---@type immut.list
local __EMPTY_LIST = { nil, nil }

local __immut_list = {}
immut.list = __immut_list

---Returns an empty list.
---@return immut.list
---@nodiscard
function __immut_list.new()
    return __EMPTY_LIST
end

---O(n). Returns the number of elements in the list.
---@param list immut.list
---@return integer
---@nodiscard
function __immut_list.size(list)
    local curr, size = list, 0

    while curr[__LIST_TAIL] do
        size = size + 1
        curr = curr[__LIST_TAIL]
    end

    return size
end

---O(1). Returns `true` if the list contains no elements, `false` otherwise.
---@param list immut.list
---@return boolean
---@nodiscard
function __immut_list.empty(list)
    return not list[__LIST_TAIL]
end

---O(1). Retrieves the first element of the list.
---If the list is empty, it throws an error.
---@param list immut.list
---@return any
---@nodiscard
function __immut_list.head(list)
    local tail = list[__LIST_TAIL]

    if not tail then
        __lua_error('attempt to get head of empty list')
    end

    return list[__LIST_HEAD]
end

---O(n). Retrieves the last element of the list.
---If the list is empty, it throws an error.
---@param list immut.list
---@return any
---@nodiscard
function __immut_list.last(list)
    local tail = list[__LIST_TAIL]

    if not tail then
        __lua_error('attempt to get last of empty list')
    end

    local curr, last = tail, list[__LIST_HEAD]

    while curr[__LIST_TAIL] do
        last = curr[__LIST_HEAD]
        curr = curr[__LIST_TAIL]
    end

    return last
end

---O(1). Retrieves a new list containing all elements of the original list except the first one.
---If the list is empty, it throws an error.
---@param list immut.list
---@return immut.list
---@nodiscard
function __immut_list.tail(list)
    local tail = list[__LIST_TAIL]

    if not tail then
        __lua_error('attempt to get tail of empty list')
    end

    return tail
end

---O(n). Retrieves a new list containing all elements of the original list except the last one.
---If the list is empty, it throws an error.
---@param list immut.list
---@return immut.list
---@nodiscard
function __immut_list.init(list)
    local tail = list[__LIST_TAIL]

    if not tail then
        __lua_error('attempt to get init of empty list')
    end

    local curr = tail
    local head_list, head_count = { list[__LIST_HEAD] }, 1

    while curr[__LIST_TAIL] do
        head_count = head_count + 1
        head_list[head_count] = curr[__LIST_HEAD]
        curr = curr[__LIST_TAIL]
    end

    local init = __EMPTY_LIST

    for i = head_count - 1, 1, -1 do
        init = { head_list[i], init }
    end

    return init
end

---O(1). Returns a new list with a given element added to the front of the list.
---@param list immut.list
---@param head any
---@return immut.list
---@nodiscard
function __immut_list.cons(list, head)
    if head == nil then
        __lua_error('list does not support nil elements')
    end

    return { head, list }
end

---O(n). Returns a new list with a given element added to the end of the list.
---@param list immut.list
---@param last any
---@return immut.list
---@nodiscard
function __immut_list.snoc(list, last)
    if last == nil then
        __lua_error('list does not support nil elements')
    end

    local tail = list[__LIST_TAIL]

    if not tail then
        return { last, __EMPTY_LIST }
    end

    local curr = tail
    local head_list, head_count = { list[__LIST_HEAD] }, 1

    while curr[__LIST_TAIL] do
        head_count = head_count + 1
        head_list[head_count] = curr[__LIST_HEAD]
        curr = curr[__LIST_TAIL]
    end

    local snoc = { last, __EMPTY_LIST }

    for i = head_count, 1, -1 do
        snoc = { head_list[i], snoc }
    end

    return snoc
end

---
---
--- DICT IMPLEMENTATION
---
---

---@class immut.dict
---@field package [1] integer size
---@field package [2] immut.hamt_node? root

local __DICT_SIZE = 1
local __DICT_ROOT = 2

---@type immut.dict
local __EMPTY_DICT = { 0, nil }

local __immut_dict = {}
immut.dict = __immut_dict

---Returns an empty dict.
---@return immut.dict
---@nodiscard
function __immut_dict.new()
    return __EMPTY_DICT
end

---O(1). Returns the number of key-value pairs in the dict.
---@param dict immut.dict
---@return integer
---@nodiscard
function __immut_dict.size(dict)
    return dict[__DICT_SIZE]
end

---O(1). Returns `true` if the dict contains no key-value pairs, `false` otherwise.
---@param dict immut.dict
---@return boolean
---@nodiscard
function __immut_dict.empty(dict)
    return dict[__DICT_SIZE] == 0
end

---O(log32 n). Associates a given key with a value in the dict, returning a new dict instance with the updated key-value pair.
---If the key already exists, its value is replaced with the new value.
---@param dict immut.dict
---@param key any
---@param value any
---@return immut.dict
---@nodiscard
function __immut_dict.assoc(dict, key, value)
    if key == nil then
        __lua_error('dict does not support nil keys')
    end

    if value == nil then
        __lua_error('dict does not support nil values')
    end

    local root, hash = dict[__DICT_ROOT], __hamt_hash(key)

    local new_root, size_delta = __hamt_assoc(root, 1, key, hash, value)

    if new_root == root then
        return dict
    end

    return { dict[__DICT_SIZE] + size_delta, new_root }
end

---O(log32 n). Dissociates a given key from the dict, returning a new dict instance without the specified key.
---If the key does not exist, the original dict is returned unchanged.
---@param dict immut.dict
---@param key any
---@return immut.dict
---@nodiscard
function __immut_dict.dissoc(dict, key)
    if key == nil then
        __lua_error('dict does not support nil keys')
    end

    local root, hash = dict[__DICT_ROOT], __hamt_hash(key)

    local new_root, size_delta = __hamt_dissoc(root, 1, key, hash)

    if not new_root then
        return __EMPTY_DICT
    end

    if new_root == root then
        return dict
    end

    return { dict[__DICT_SIZE] + size_delta, new_root }
end

---O(log32 n). Retrieves the value associated with a given key in the dict.
---If the key does not exist, it returns `nil`.
---@param dict immut.dict
---@param key any
---@return any
---@nodiscard
function __immut_dict.lookup(dict, key)
    if key == nil then
        __lua_error('dict does not support nil keys')
    end

    return __hamt_lookup(dict[__DICT_ROOT], 1, key, __hamt_hash(key))
end

---O(log32 n). Checks if a given key exists in the dict, returning `true` if it does and `false` otherwise.
---@param dict immut.dict
---@param key any
---@return boolean
---@nodiscard
function __immut_dict.contains(dict, key)
    if key == nil then
        __lua_error('dict does not support nil keys')
    end

    return __hamt_lookup(dict[__DICT_ROOT], 1, key, __hamt_hash(key)) ~= nil
end

---
---
---
---
---

return immut
