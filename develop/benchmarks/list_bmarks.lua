local immut = require 'immut'
local basics = require 'develop.basics'

local NS = { 25, 50, 100 }

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

    print '----------------------------------------'

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('List (%s) Benchmarks: Snoc %d random elements', mode, N),
            function()
                local l = immut.list(mode)

                for _ = 1, N do
                    local v = math.random(1, N)
                    l = l:snoc(v)
                end
            end)
    end

    print '----------------------------------------'

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('List (%s) Benchmarks: Tail %d random elements', mode, N),
            function(l)
                for _ = 1, N do
                    l = l:tail()
                end
            end, function()
                local l = immut.list(mode)

                for _ = 1, N do
                    l = l:cons(math.random(1, N))
                end

                return l
            end)
    end

    print '----------------------------------------'

    for _, N in ipairs(NS) do
        basics.describe_bench(
            string.format('List (%s) Benchmarks: Init %d random elements', mode, N),
            function(l)
                for _ = 1, N do
                    l = l:init()
                end
            end, function()
                local l = immut.list(mode)

                for _ = 1, N do
                    l = l:cons(math.random(1, N))
                end

                return l
            end)
    end
end
