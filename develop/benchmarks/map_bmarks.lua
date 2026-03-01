local immut = require 'immut'
local basics = require 'develop.basics'

local N = 100

print '----------------------------------------'

basics.describe_bench(
    string.format('Map Benchmarks: Insert %d random elements', N),
    function()
        local m = immut.map()

        for _ = 1, N do
            local k = math.random(1, N)
            m = m:insert(k, k)
        end
    end)

basics.describe_bench(
    string.format('Map Benchmarks: Insert %d ascending elements', N),
    function()
        local m = immut.map()

        for i = 1, N do
            m = m:insert(i, i)
        end
    end)

basics.describe_bench(
    string.format('Map Benchmarks: Insert %d descending elements', N),
    function()
        local m = immut.map()

        for i = N, 1, -1 do
            m = m:insert(i, i)
        end
    end)
