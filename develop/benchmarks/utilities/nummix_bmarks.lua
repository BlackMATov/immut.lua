local basics = require 'develop.basics'

local N = 10000

---@param v number
---@return integer
---@nodiscard
local function __nummix(v)
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
            v = math.random() * 2 ^ math.random(-60, 60)
            if math.random() < 0.5 then v = -v end
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
            local w1 = math.random(0, 2 ^ 16 - 1)
            local w2 = math.random(0, 2 ^ 16 - 1)
            local w3 = math.random(0, 2 ^ 16 - 1)
            local w4 = math.random(0, 2 ^ 5 - 1)
            v = w1 + w2 * 2 ^ 16 + w3 * 2 ^ 32 + w4 * 2 ^ 48
            if math.random() < 0.5 then v = -v end
        until add_integer(v)
    end

    return integer_list
end)()

do
    assert(__nummix(0) == __nummix(-0))
    assert(__nummix(1) ~= __nummix(-1))
    assert(__nummix(0.5) ~= __nummix(-0.5))
    assert(__nummix(0 / 0) == __nummix(0 / 0))
    assert(__nummix(1 / 0) == __nummix(1 / 0))
    assert(__nummix(-1 / 0) == __nummix(-1 / 0))
    assert(__nummix(1 / 0) ~= __nummix(-1 / 0))

    for i = 1, #__random_numbers do
        local v = __random_numbers[i]
        local h = __nummix(v)

        assert(type(h) == 'number', string.format('non-number hash for %.64g: %s', v, tostring(h)))
        assert(h >= 0 and h < 2 ^ 32, string.format('hash out of range for %.64g: %s', v, tostring(h)))
        assert(h % 1 == 0, string.format('non-integer hash for %.64g: %s', v, tostring(h)))
        assert(h == __nummix(v), string.format('non-deterministic hash for %.64g: %s', v, tostring(h)))
    end
end

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

---@param name string
---@param hash fun(v:number):integer
---@param numbers number[]
---@param strict boolean|nil
local function describe_distribution(name, hash, numbers, strict)
    local BUCKETS = 32

    local counts = {}
    for i = 1, BUCKETS do counts[i] = 0 end

    for i = 1, #numbers do
        local h = hash(numbers[i])
        local bucket = h % BUCKETS + 1
        counts[bucket] = counts[bucket] + 1
    end

    local exp = #numbers / BUCKETS
    local chi2 = 0

    local min_count = 1 / 0
    local max_count = -1 / 0

    for i = 1, BUCKETS do
        local diff = counts[i] - exp
        chi2 = chi2 + diff * diff / exp
        min_count = math.min(min_count, counts[i])
        max_count = math.max(max_count, counts[i])
    end

    local df = BUCKETS - 1
    local chi2_crit = df * (1 - 2 / (9 * df) + 3.09 * (2 / (9 * df)) ^ 0.5) ^ 3

    local pass = chi2 < chi2_crit

    print(string.format(
        '| Distribution: %s | chi2: %.2f / %.2f | exp: %.1f | min: %d | max: %d | %s |',
        name, chi2, chi2_crit, exp, min_count, max_count, pass and 'PASS' or 'FAIL'))

    if not pass then
        for row = 0, 3 do
            local line = '|'
            for col = 1, 8 do
                local i = row * 8 + col
                local pct = counts[i] * 100 / #numbers
                line = line .. string.format('%4.1f%% |', pct)
            end
            print(line)
        end
    end

    if strict then
        assert(pass, string.format('Distribution test FAILED for %s: chi2=%.2f', name, chi2))
    end
end

describe_distribution('random numbers', __nummix, __random_numbers)
describe_distribution('random integers', __nummix, __random_integers)

describe_distribution('sequential 1..N', __nummix, (function()
    local list = {}
    for i = 1, N do list[i] = i end
    return list
end)(), true)

describe_distribution('sequential -1..-N', __nummix, (function()
    local list = {}
    for i = 1, N do list[i] = -i end
    return list
end)(), true)

describe_distribution('sequential evens', __nummix, (function()
    local list = {}
    for i = 1, N do list[i] = i * 2 end
    return list
end)(), true)

describe_distribution('powers of two', __nummix, (function()
    local list = {}
    for i = 1, N do
        local exp = (i - 1) % 53
        local offset = ((i - 1) - (i - 1) % 53) / 53
        list[i] = 2 ^ exp + offset
    end
    return list
end)(), true)

describe_distribution('small fractions i/N', __nummix, (function()
    local list = {}
    for i = 1, N do list[i] = i / 10000 end
    return list
end)(), true)

describe_distribution('multiples of 2 ^ 16', __nummix, (function()
    local list = {}
    for i = 1, N do list[i] = i * 2 ^ 16 end
    return list
end)(), true)

describe_distribution('dense floats 1000+i*0.001', __nummix, (function()
    local list = {}
    for i = 1, N do list[i] = 1000 + i * 0.001 end
    return list
end)(), true)
