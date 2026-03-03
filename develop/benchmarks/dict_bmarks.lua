local immut = require 'immut'
local basics = require 'develop.basics'

local NS = { 20, 100, 500 }

for _, mode in ipairs(immut.AVAILABLE_DICT_MODES) do
    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('Dict (%s) Benchmarks: Assoc %d random elements', mode, N),
            function()
                local m = immut.dict(mode)

                for _ = 1, N do
                    local k = math.random(1, N)
                    m = m:assoc(k, k)
                end
            end)
    end

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('Dict (%s) Benchmarks: Assoc %d ascending elements', mode, N),
            function()
                local m = immut.dict(mode)

                for i = 1, N do
                    m = m:assoc(i, i)
                end
            end)
    end

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('Dict (%s) Benchmarks: Assoc %d descending elements', mode, N),
            function()
                local m = immut.dict(mode)

                for i = N, 1, -1 do
                    m = m:assoc(i, i)
                end
            end)
    end
end
