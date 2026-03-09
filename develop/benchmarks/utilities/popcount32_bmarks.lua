local basics = require 'develop.basics'

local N = 10000

local __bit = _G['bit'] or _G['bit32']
---@diagnostic disable-next-line: deprecated
local __load_string = _G['loadstring'] or _G['load']

local __popcount8_lut = {
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
local function __popcount32_naiv(v)
    local sum = 0
    while v ~= 0 do
        local lst = v % 2
        sum = sum + lst
        v = (v - lst) / 2
    end
    return sum
end

local __popcount32_naiv_with_bit

if __bit then
    ---@param v integer
    ---@return integer
    ---@nodiscard
    __popcount32_naiv_with_bit = function(v)
        local sum = 0
        while v ~= 0 do
            v = __bit.band(v, v - 1)
            sum = sum + 1
        end
        return sum
    end
elseif __load_string then
    local loader = __load_string [[
        return function(v)
            local sum = 0
            while v ~= 0 do
                v = v & (v - 1)
                sum = sum + 1
            end
            return sum
        end
    ]]

    if loader then
        __popcount32_naiv_with_bit = loader()
    end
end

---@param v integer
---@return integer
---@nodiscard
local function __popcount32_lut8(v)
    local pc8 = __popcount8_lut

    local bb1 = v % 2 ^ 8; v = (v - bb1) / 2 ^ 8
    local bb2 = v % 2 ^ 8; v = (v - bb2) / 2 ^ 8
    local bb3 = v % 2 ^ 8; v = (v - bb3) / 2 ^ 8
    local bb4 = v

    return pc8[bb1 + 1] + pc8[bb2 + 1] + pc8[bb3 + 1] + pc8[bb4 + 1]
end

local __popcount32_lut8_with_bit

if __bit then
    ---@param v integer
    ---@return integer
    ---@nodiscard
    __popcount32_lut8_with_bit = function(v)
        local pc8 = __popcount8_lut

        local bb1 = __bit.band(v, 0xFF); v = __bit.rshift(v, 8)
        local bb2 = __bit.band(v, 0xFF); v = __bit.rshift(v, 8)
        local bb3 = __bit.band(v, 0xFF); v = __bit.rshift(v, 8)
        local bb4 = v

        return pc8[bb1 + 1] + pc8[bb2 + 1] + pc8[bb3 + 1] + pc8[bb4 + 1]
    end
elseif __load_string then
    local loader = __load_string [[
        local __popcount8_lut = {
            0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
            1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
            1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
            2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
            1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
            2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
            2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
            3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8,
        }

        return function(v)
            local pc8 = __popcount8_lut

            local bb1 = v & 0xFF; v = v >> 8
            local bb2 = v & 0xFF; v = v >> 8
            local bb3 = v & 0xFF; v = v >> 8
            local bb4 = v

            return pc8[bb1 + 1] + pc8[bb2 + 1] + pc8[bb3 + 1] + pc8[bb4 + 1]
        end
    ]]

    if loader then
        __popcount32_lut8_with_bit = loader()
    end
end

local __popcount32_hamming_weight_with_bit

if __bit then
    ---@param v integer
    ---@return integer
    ---@nodiscard
    __popcount32_hamming_weight_with_bit = function(v)
        v = v - __bit.band(__bit.rshift(v, 1), 0x55555555)
        v = __bit.band(v, 0x33333333) + __bit.band(__bit.rshift(v, 2), 0x33333333)
        v = __bit.band(v + __bit.rshift(v, 4), 0x0F0F0F0F)
        v = v + __bit.rshift(v, 8)
        v = v + __bit.rshift(v, 16)
        return __bit.band(v, 0x3F)
    end
elseif __load_string then
    local loader = __load_string [[
        return function(v)
            v = v - ((v >> 1) & 0x55555555)
            v = (v & 0x33333333) + ((v >> 2) & 0x33333333)
            v = (v + (v >> 4)) & 0x0F0F0F0F
            v = v + (v >> 8)
            v = v + (v >> 16)
            return v & 0x3F
        end
    ]]

    if loader then
        __popcount32_hamming_weight_with_bit = loader()
    end
end

local __random_integers = (function()
    local integers = {} ---@type integer[]

    integers[#integers + 1] = 0
    integers[#integers + 1] = 2 ^ 32 - 1

    for _ = 1, N - #integers do
        local hi = math.random(0, 2 ^ 16 - 1)
        local lo = math.random(0, 2 ^ 16 - 1)

        local v = hi * 2 ^ 16 + lo

        integers[#integers + 1] = v
    end

    return integers
end)()

for i = 1, #__random_integers do
    local v = __random_integers[i]

    assert(__popcount32_naiv(v) == __popcount32_lut8(v))

    if __popcount32_naiv_with_bit then
        assert(__popcount32_naiv(v) == __popcount32_naiv_with_bit(v))
    end

    if __popcount32_lut8_with_bit then
        assert(__popcount32_naiv(v) == __popcount32_lut8_with_bit(v))
    end

    if __popcount32_hamming_weight_with_bit then
        assert(__popcount32_naiv(v) == __popcount32_hamming_weight_with_bit(v))
    end
end

basics.describe_bench(
    string.format('Utilities Benchmarks: popcount32_naiv %d random integers', #__random_integers),
    function()
        local s = 0
        for i = 1, #__random_integers do
            s = s + __popcount32_naiv(__random_integers[i])
        end
        return s
    end)

if __popcount32_naiv_with_bit then
    basics.describe_bench(
        string.format('Utilities Benchmarks: popcount32_naiv_with_bit %d random integers', #__random_integers),
        function()
            local s = 0
            for i = 1, #__random_integers do
                s = s + __popcount32_naiv_with_bit(__random_integers[i])
            end
            return s
        end)
end

basics.describe_bench(
    string.format('Utilities Benchmarks: popcount32_lut8 %d random integers', #__random_integers),
    function()
        local s = 0
        for i = 1, #__random_integers do
            s = s + __popcount32_lut8(__random_integers[i])
        end
        return s
    end)

if __popcount32_lut8_with_bit then
    basics.describe_bench(
        string.format('Utilities Benchmarks: popcount32_lut8_with_bit %d random integers', #__random_integers),
        function()
            local s = 0
            for i = 1, #__random_integers do
                s = s + __popcount32_lut8_with_bit(__random_integers[i])
            end
            return s
        end)
end

if __popcount32_hamming_weight_with_bit then
    basics.describe_bench(
        string.format('Utilities Benchmarks: popcount32_hamming_weight_with_bit %d random integers', #__random_integers),
        function()
            local s = 0
            for i = 1, #__random_integers do
                s = s + __popcount32_hamming_weight_with_bit(__random_integers[i])
            end
            return s
        end)
end
