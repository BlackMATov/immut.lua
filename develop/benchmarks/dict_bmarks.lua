local immut = require 'immut'
local basics = require 'develop.basics'

local NS = { 20, 100, 500 }

for _, mode in ipairs({ 'copy' }) do
    print '----------------------------------------'

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('Dict (%s) Benchmarks: Insert %d random elements', mode, N),
            function()
                local m = immut.dict(mode)

                for _ = 1, N do
                    local k = math.random(1, N)
                    m = m:insert(k, k)
                end
            end)
    end

    print '----------------------------------------'

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('Dict (%s) Benchmarks: Insert %d ascending elements', mode, N),
            function()
                local m = immut.dict(mode)

                for i = 1, N do
                    m = m:insert(i, i)
                end
            end)
    end

    print '----------------------------------------'

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('Dict (%s) Benchmarks: Insert %d descending elements', mode, N),
            function()
                local m = immut.dict(mode)

                for i = N, 1, -1 do
                    m = m:insert(i, i)
                end
            end)
    end
end
