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
    do
        local m0 = dict.new()
        local k, v = dict.next(m0)
        assert(k == nil and v == nil)
    end

    do
        local m1 = dict.assoc(dict.new(), 'hello', 42)

        local k1, v1 = dict.next(m1)
        assert(k1 == 'hello' and v1 == 42)

        local k2, v2 = dict.next(m1, k1)
        assert(k2 == nil and v2 == nil)
    end

    do
        local m = dict.new()
        m = dict.assoc(m, 'a', 1)
        m = dict.assoc(m, 'b', 2)
        m = dict.assoc(m, 'c', 3)
        m = dict.assoc(m, 42, 'num')
        m = dict.assoc(m, true, 'bool')

        do
            local seen, count = {}, 0

            for k, v in dict.next, m do
                assert(seen[k] == nil)
                count = count + 1
                seen[k] = v
            end

            assert(count == 5)
            assert(seen['a'] == 1)
            assert(seen['b'] == 2)
            assert(seen['c'] == 3)
            assert(seen[42] == 'num')
            assert(seen[true] == 'bool')
        end

        m = dict.dissoc(m, 'b')
        m = dict.dissoc(m, 42)
        m = dict.dissoc(m, true)

        do
            local seen, count = {}, 0

            for k, v in dict.next, m do
                assert(seen[k] == nil)
                count = count + 1
                seen[k] = v
            end

            assert(count == 2)
            assert(seen['a'] == 1)
            assert(seen['c'] == 3)
            assert(seen['b'] == nil)
        end

        m = dict.assoc(m, 'a', 10)

        do
            local seen, count = {}, 0

            for k, v in dict.next, m do
                assert(seen[k] == nil)
                count = count + 1
                seen[k] = v
            end

            assert(count == 2)
            assert(seen['a'] == 10)
            assert(seen['c'] == 3)
            assert(seen['b'] == nil)
        end

        m = dict.assoc(m, 'a', 42)

        do
            local seen, count = {}, 0

            for k, v in dict.next, m do
                assert(seen[k] == nil)
                count = count + 1
                seen[k] = v
            end

            assert(count == 2)
            assert(seen['a'] == 42)
            assert(seen['c'] == 3)
            assert(seen['b'] == nil)
        end
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
