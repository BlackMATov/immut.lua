require 'develop.testing.map_tests'
require 'develop.testing.set_tests'

require 'develop.benchmarks.map_bmarks'
require 'develop.benchmarks.set_bmarks'

local basics = require 'develop.basics'

print '----------------------------------------'
basics.describe_fuzz 'develop.fuzzing.map_fuzz'
print '----------------------------------------'
basics.describe_fuzz 'develop.fuzzing.set_fuzz'

print 'All tests passed.'
