local immut = require 'immut'
local basics = require 'develop.basics'

local N = 100

for _, mode in ipairs({ 'copy' }) do
    print '----------------------------------------'

    basics.describe_bench(
        string.format('Set (%s) Benchmarks: Insert %d random elements', mode, N),
        function()
            local s = immut.set(mode)

            for _ = 1, N do
                local k = math.random(1, N)
                s = s:insert(k)
            end
        end)

    basics.describe_bench(
        string.format('Set (%s) Benchmarks: Insert %d ascending elements', mode, N),
        function()
            local s = immut.set(mode)

            for i = 1, N do
                s = s:insert(i)
            end
        end)

    basics.describe_bench(
        string.format('Set (%s) Benchmarks: Insert %d descending elements', mode, N),
        function()
            local s = immut.set(mode)

            for i = N, 1, -1 do
                s = s:insert(i)
            end
        end)
end
