local immut = require 'immut'
local basics = require 'develop.basics'

local N = 100

print '----------------------------------------'

basics.describe_bench(
    string.format('Set Benchmarks: Insert %d random elements', N),
    function()
        local s = immut.set()

        for _ = 1, N do
            local k = math.random(1, N)
            s = s:insert(k)
        end
    end)

basics.describe_bench(
    string.format('Set Benchmarks: Insert %d ascending elements', N),
    function()
        local s = immut.set()

        for i = 1, N do
            s = s:insert(i)
        end
    end)

basics.describe_bench(
    string.format('Set Benchmarks: Insert %d descending elements', N),
    function()
        local s = immut.set()

        for i = N, 1, -1 do
            s = s:insert(i)
        end
    end)
