local dict = require 'immut'.dict
local basics = require 'develop.basics'

do
    local m0 = dict.new()

    do
        assert(dict.size(m0) == 0)
        assert(dict.empty(m0) == true)

        assert(dict.contains(m0, 42) == false)
        assert(dict.lookup(m0, 42) == nil)
        assert(dict.contains(m0, 'hello') == false)
        assert(dict.lookup(m0, 'hello') == nil)
    end

    local m1 = dict.assoc(m0, 42, 21)

    do
        assert(dict.size(m0) == 0)
        assert(dict.empty(m0) == true)

        assert(dict.contains(m0, 42) == false)
        assert(dict.lookup(m0, 42) == nil)
        assert(dict.contains(m0, 'hello') == false)
        assert(dict.lookup(m0, 'hello') == nil)
    end

    do
        assert(dict.size(m1) == 1)
        assert(dict.empty(m1) == false)

        assert(dict.contains(m1, 42) == true)
        assert(dict.lookup(m1, 42) == 21)
        assert(dict.contains(m1, 'hello') == false)
        assert(dict.lookup(m1, 'hello') == nil)
    end

    local m2 = dict.assoc(m1, 'hello', 'world')

    do
        assert(dict.size(m0) == 0)
        assert(dict.empty(m0) == true)

        assert(dict.contains(m0, 42) == false)
        assert(dict.lookup(m0, 42) == nil)
        assert(dict.contains(m0, 'hello') == false)
        assert(dict.lookup(m0, 'hello') == nil)
    end

    do
        assert(dict.size(m1) == 1)
        assert(dict.empty(m1) == false)

        assert(dict.contains(m1, 42) == true)
        assert(dict.lookup(m1, 42) == 21)
        assert(dict.contains(m1, 'hello') == false)
        assert(dict.lookup(m1, 'hello') == nil)
    end

    do
        assert(dict.size(m2) == 2)
        assert(dict.empty(m2) == false)

        assert(dict.contains(m2, 42) == true)
        assert(dict.lookup(m2, 42) == 21)
        assert(dict.contains(m2, 'hello') == true)
        assert(dict.lookup(m2, 'hello') == 'world')
    end
end

do
    local m2 = dict.assoc(dict.assoc(dict.new(), 42, 21), 'hello', 'world')

    do
        assert(dict.size(m2) == 2)
        assert(dict.empty(m2) == false)

        assert(dict.contains(m2, 42) == true)
        assert(dict.lookup(m2, 42) == 21)
        assert(dict.contains(m2, 'hello') == true)
        assert(dict.lookup(m2, 'hello') == 'world')
    end

    local m2_without_hello = dict.dissoc(m2, 'hello')
    local m2_without_42 = dict.dissoc(m2, 42)

    do
        assert(dict.size(m2) == 2)
        assert(dict.empty(m2) == false)

        assert(dict.contains(m2, 42) == true)
        assert(dict.lookup(m2, 42) == 21)
        assert(dict.contains(m2, 'hello') == true)
        assert(dict.lookup(m2, 'hello') == 'world')
    end

    do
        assert(dict.size(m2_without_hello) == 1)
        assert(dict.empty(m2_without_hello) == false)

        assert(dict.contains(m2_without_hello, 42) == true)
        assert(dict.lookup(m2_without_hello, 42) == 21)
        assert(dict.contains(m2_without_hello, 'hello') == false)
        assert(dict.lookup(m2_without_hello, 'hello') == nil)
    end

    do
        assert(dict.size(m2_without_42) == 1)
        assert(dict.empty(m2_without_42) == false)

        assert(dict.contains(m2_without_42, 42) == false)
        assert(dict.lookup(m2_without_42, 42) == nil)
        assert(dict.contains(m2_without_42, 'hello') == true)
        assert(dict.lookup(m2_without_42, 'hello') == 'world')
    end
end

do
    local m = dict.new()
    assert(dict.dissoc(m, 'hello') == m)

    m = dict.assoc(m, 'hello', 'world')
    assert(dict.assoc(m, 'hello', 'world') == m)

    assert(dict.dissoc(m, 'world') == m)
    assert(dict.dissoc(m, 'hello') == dict.new())
end

do
    basics.describe_error(function() _ = dict.assoc(dict.new(), nil, 42) end)
    basics.describe_error(function() _ = dict.assoc(dict.new(), 42, nil) end)
    basics.describe_error(function() _ = dict.assoc(dict.new(), nil, nil) end)
    basics.describe_error(function() _ = dict.assoc(dict.new(), {}, 42) end)

    basics.describe_error(function() _ = dict.dissoc(dict.new(), nil) end)
end
