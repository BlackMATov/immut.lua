local basics = require 'develop.basics'

local N = 1000

local __math_random = math.random
local __string_byte = string.byte
local __string_char = string.char

---@param s string
---@return integer
---@nodiscard
local function __djb2(s)
    local i, l, h = 1, #s, 5381

    while i <= l do
        local c = __string_byte(s, i)

        h = h * 33 + c
        h = h % 2 ^ 32

        i = i + 1
    end

    return h
end

---@param s string
---@return integer
---@nodiscard
local function __djb2_unrolled(s)
    local i, l, h = 1, #s, 5381

    while i <= l - 7 do
        local c1, c2, c3, c4, c5, c6, c7, c8 = __string_byte(s, i, i + 7)

        h = h * 33 + c1
        h = h * 33 + c2
        h = h * 33 + c3
        h = h * 33 + c4
        h = h % 2 ^ 32

        h = h * 33 + c5
        h = h * 33 + c6
        h = h * 33 + c7
        h = h * 33 + c8
        h = h % 2 ^ 32

        i = i + 8
    end

    while i <= l - 3 do
        local c1, c2, c3, c4 = __string_byte(s, i, i + 3)

        h = h * 33 + c1
        h = h * 33 + c2
        h = h * 33 + c3
        h = h * 33 + c4
        h = h % 2 ^ 32

        i = i + 4
    end

    while i <= l - 1 do
        local c1, c2 = __string_byte(s, i, i + 1)

        h = h * 33 + c1
        h = h * 33 + c2
        h = h % 2 ^ 32

        i = i + 2
    end

    while i <= l do
        local c = __string_byte(s, i)

        h = h * 33 + c
        h = h % 2 ^ 32

        i = i + 1
    end

    return h
end

local __random_strings = (function()
    local strings = {} ---@type string[]

    do
        local s = ''

        for _ = 1, 17 do
            s = s .. __string_char(255)
        end

        strings[#strings + 1] = s
    end

    for _ = 2, N do
        local s, l = '', __math_random(0, 32)

        for _ = 1, l do
            s = s .. __string_char(__math_random(0, 255))
        end

        strings[#strings + 1] = s
    end

    return strings
end)()

for i = 1, N do
    local s = __random_strings[i]

    assert(__djb2(s) == __djb2_unrolled(s))
end

basics.describe_bench(
    string.format('Utilities Benchmarks: djb2 %d random strings', N),
    function()
        local s = 0
        for i = 1, N do
            s = s + __djb2(__random_strings[i])
        end
        return s
    end)

basics.describe_bench(
    string.format('Utilities Benchmarks: djb2_unrolled %d random strings', N),
    function()
        local s = 0
        for i = 1, N do
            s = s + __djb2_unrolled(__random_strings[i])
        end
        return s
    end)
