local immut = require 'immut'
local basics = require 'develop.basics'

local NS = { 100, 200, 400 }

for mode_index, mode in ipairs(immut.AVAILABLE_DICT_MODES) do
    if mode_index > 1 then
        print '----------------------------------------'
    end

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
end
