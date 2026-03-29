local stack = require 'immut'.stack

do
    local s0 = stack.new()
    assert(stack.size(s0) == 0)
    assert(stack.empty(s0) == true)
end
