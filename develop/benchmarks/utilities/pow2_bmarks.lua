local basics = require 'develop.basics'

local N = 10000

local __pow2_lut = {
    1, 2, 4, 8, 16, 32, 64, 128,
    256, 512, 1024, 2048, 4096, 8192, 16384, 32768,
    65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608,
    16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483648,
}

local __random_integers = (function()
    local integer_list = {} ---@type integer[]

    for _ = 1, N - #integer_list do
        local v = math.random(0, 31)
        integer_list[#integer_list + 1] = v
    end

    return integer_list
end)()

for i = 1, #__random_integers do
    local v = __random_integers[i]

    assert(2 ^ v == __pow2_lut[v + 1])
end

basics.describe_bench(
    string.format('Utilities Benchmarks: pow2 %d random integers', #__random_integers),
    function()
        local s = 0
        for i = 1, #__random_integers do
            s = s + 2 ^ __random_integers[i]
        end
        return s
    end)

basics.describe_bench(
    string.format('Utilities Benchmarks: pow2_lut %d random integers', #__random_integers),
    function()
        local s = 0
        for i = 1, #__random_integers do
            s = s + __pow2_lut[__random_integers[i] + 1]
        end
        return s
    end)
