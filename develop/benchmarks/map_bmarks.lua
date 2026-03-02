local immut = require 'immut'
local basics = require 'develop.basics'

local N = 100

for _, mode in ipairs({ 'copy' }) do
    print '----------------------------------------'

    basics.describe_bench(
        string.format('Map (%s) Benchmarks: Insert %d random elements', mode, N),
        function()
            local m = immut.map(mode)

            for _ = 1, N do
                local k = math.random(1, N)
                m = m:insert(k, k)
            end
        end)

    basics.describe_bench(
        string.format('Map (%s) Benchmarks: Insert %d ascending elements', mode, N),
        function()
            local m = immut.map(mode)

            for i = 1, N do
                m = m:insert(i, i)
            end
        end)

    basics.describe_bench(
        string.format('Map (%s) Benchmarks: Insert %d descending elements', mode, N),
        function()
            local m = immut.map(mode)

            for i = N, 1, -1 do
                m = m:insert(i, i)
            end
        end)
end
