local list = require 'immut'.list
local basics = require 'develop.basics'

local NS = { 25, 50, 100 }

for _, N in ipairs(NS) do
    basics.describe_bench(
        string.format('List Benchmarks: Cons %d random elements', N),
        function()
            local l = list.new()

            for _ = 1, N do
                local v = math.random(1, N)
                l = list.cons(v, l)
            end
        end)
end

print '----------------------------------------'

for _, N in ipairs(NS) do
    basics.describe_bench(
        string.format('List Benchmarks: Snoc %d random elements', N),
        function()
            local l = list.new()

            for _ = 1, N do
                local v = math.random(1, N)
                l = list.snoc(l, v)
            end
        end)
end

print '----------------------------------------'

for _, N in ipairs(NS) do
    basics.describe_bench(
        string.format('List Benchmarks: Tail %d random elements', N),
        function(l)
            for _ = 1, N do
                l = list.tail(l)
            end
        end, function()
            local l = list.new()

            for _ = 1, N do
                l = list.cons(math.random(1, N), l)
            end

            return l
        end)
end

print '----------------------------------------'

for _, N in ipairs(NS) do
    basics.describe_bench(
        string.format('List Benchmarks: Init %d random elements', N),
        function(l)
            for _ = 1, N do
                l = list.init(l)
            end
        end, function()
            local l = list.new()

            for _ = 1, N do
                l = list.cons(math.random(1, N), l)
            end

            return l
        end)
end
