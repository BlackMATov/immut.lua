local basics = require 'develop.basics'

local N = 10000

local __math_huge = math.huge
local __math_random = math.random

---@param v number
---@return integer
---@nodiscard
local function __nummix(v)
    return 0
end

local __random_numbers = (function()
    local number_set = {} ---@type table<number, boolean>
    local number_list = {} ---@type number[]

    ---@param v number
    ---@return boolean
    ---@nodiscard
    local function add_number(v)
        if number_set[v] then
            return false
        end
        number_set[v] = true
        number_list[#number_list + 1] = v
        return true
    end

    for _ = 1, N - #number_list do
        local v
        repeat
            v = __math_random() * 2 ^ 64
            if __math_random() < 0.5 then v = -v end
        until add_number(v)
    end

    return number_list
end)()

local __random_integers = (function()
    local integer_set = {} ---@type table<integer, boolean>
    local integer_list = {} ---@type integer[]

    ---@param v integer
    ---@return boolean
    ---@nodiscard
    local function add_integer(v)
        if integer_set[v] then
            return false
        end
        integer_set[v] = true
        integer_list[#integer_list + 1] = v
        return true
    end

    for _ = 1, N - #integer_list do
        local v
        repeat
            local w1 = __math_random(0, 2 ^ 16 - 1)
            local w2 = __math_random(0, 2 ^ 16 - 1)
            local w3 = __math_random(0, 2 ^ 16 - 1)
            local w4 = __math_random(0, 2 ^ 5 - 1)
            v = w1 + w2 * 2 ^ 16 + w3 * 2 ^ 32 + w4 * 2 ^ 48
            if __math_random() < 0.5 then v = -v end
        until add_integer(v)
    end

    return integer_list
end)()

basics.describe_bench(
    string.format('Utilities Benchmarks: nummix %d random numbers', #__random_numbers),
    function()
        local s = 0
        for i = 1, #__random_numbers do
            s = s + __nummix(__random_numbers[i])
        end
        return s
    end)

basics.describe_bench(
    string.format('Utilities Benchmarks: nummix %d random integers', #__random_integers),
    function()
        local s = 0
        for i = 1, #__random_integers do
            s = s + __nummix(__random_integers[i])
        end
        return s
    end)
