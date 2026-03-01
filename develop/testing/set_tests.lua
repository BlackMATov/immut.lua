local immut = require 'immut'

do
    local s0 = immut.set()

    do
        assert(s0:size() == 0)
        assert(s0:empty() == true)

        assert(s0:has(42) == false)
        assert(s0:has('hello') == false)
    end

    local s1 = s0:insert(42)

    do
        assert(s0:size() == 0)
        assert(s0:empty() == true)

        assert(s0:has(42) == false)
        assert(s0:has('hello') == false)
    end

    do
        assert(s1:size() == 1)
        assert(s1:empty() == false)

        assert(s1:has(42) == true)
        assert(s1:has('hello') == false)
    end

    local s2 = s1:insert('hello')

    do
        assert(s0:size() == 0)
        assert(s0:empty() == true)

        assert(s0:has(42) == false)
        assert(s0:has('hello') == false)
    end

    do
        assert(s1:size() == 1)
        assert(s1:empty() == false)

        assert(s1:has(42) == true)
        assert(s1:has('hello') == false)
    end

    do
        assert(s2:size() == 2)
        assert(s2:empty() == false)

        assert(s2:has(42) == true)
        assert(s2:has('hello') == true)
    end
end

do
    local s2 = immut.set():insert(42):insert('hello')

    do
        assert(s2:size() == 2)
        assert(s2:empty() == false)

        assert(s2:has(42) == true)
        assert(s2:has('hello') == true)
    end

    local s2_removed_hello = s2:remove('hello')
    local s2_removed_42 = s2:remove(42)

    do
        assert(s2:size() == 2)
        assert(s2:empty() == false)

        assert(s2:has(42) == true)
        assert(s2:has('hello') == true)
    end

    do
        assert(s2_removed_hello:size() == 1)
        assert(s2_removed_hello:empty() == false)

        assert(s2_removed_hello:has(42) == true)
        assert(s2_removed_hello:has('hello') == false)
    end

    do
        assert(s2_removed_42:size() == 1)
        assert(s2_removed_42:empty() == false)

        assert(s2_removed_42:has(42) == false)
        assert(s2_removed_42:has('hello') == true)
    end
end
