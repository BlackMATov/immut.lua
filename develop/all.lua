require 'develop.testing.dict_tests'

require 'develop.benchmarks.dict_bmarks'

local basics = require 'develop.basics'

print '----------------------------------------'
basics.describe_fuzz 'develop.fuzzing.dict_fuzz'

print 'All tests passed.'
