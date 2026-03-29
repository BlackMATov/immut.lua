local list = require 'immut'.list

do
    local l0 = list.new()
    assert(list.size(l0) == 0)
    assert(list.empty(l0) == true)
end
