local dict = require 'immut'.dict
local basics = require 'develop.basics'

local NS = { 100, 200, 400 }

for _, N in ipairs(NS) do
    basics.describe_bench(
        string.format('Dict Benchmarks: Assoc %d random elements', N),
        function()
            local m = dict.new()

            for _ = 1, N do
                local k = math.random(1, N)
                m = dict.assoc(m, k, k)
            end
        end)
end

print '----------------------------------------'

for _, N in ipairs(NS) do
    basics.describe_bench(
        string.format('Dict Benchmarks: Iter %d random elements', N),
        function(m)
            local s = 0
            for _, k, v in dict.iter(m) do
                s = s + k + v
            end
            return s
        end, function()
            local m = dict.new()

            for i = 1, N do
                m = dict.assoc(m, i, i)
            end

            return m
        end)
end

print '----------------------------------------'

for _, N in ipairs(NS) do
    basics.describe_bench(
        string.format('Dict Benchmarks: Lookup %d random elements', N),
        function(m, vs)
            for i = 1, N do
                local k = vs[i]
                local v = dict.lookup(m, k) ---@diagnostic disable-line: unused-local
            end
        end, function()
            local m, vs = dict.new(), {}

            for i = 1, N do
                local k = math.random(1, N)
                m = dict.assoc(m, k, k)
                vs[i] = k
            end

            return m, vs
        end)
end
