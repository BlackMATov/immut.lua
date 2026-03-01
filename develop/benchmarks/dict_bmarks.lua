local immut = require 'immut'
local basics = require 'develop.basics'

local N = 1000

print '----------------------------------------'

basics.describe_bench(
    string.format('Dict Benchmarks: %d', N),
    function()
    end)
