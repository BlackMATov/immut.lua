local basics = require 'develop.basics'

basics.describe_test 'develop.testing.dict_tests'
basics.describe_test 'develop.testing.list_tests'

basics.describe_fuzz 'develop.fuzzing.dict_fuzz'
basics.describe_fuzz 'develop.fuzzing.list_fuzz'

require 'develop.benchmarks.dict_bmarks'
require 'develop.benchmarks.list_bmarks'

print 'All tests passed.'
