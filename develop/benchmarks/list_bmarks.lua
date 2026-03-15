local immut = require 'immut'
local basics = require 'develop.basics'

local NS = { 20, 100, 500 }

for mode_index, mode in ipairs(immut.AVAILABLE_LIST_MODES) do
    if mode_index > 1 then
        print '----------------------------------------'
    end

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('List (%s) Benchmarks: Cons %d random elements', mode, N),
            function()
                local l = immut.list(mode)

                for _ = 1, N do
                    local v = math.random(1, N)
                    l = l:cons(v)
                end
            end)
    end
end
