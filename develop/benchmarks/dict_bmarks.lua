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
