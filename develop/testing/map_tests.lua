local immut = require 'immut'

for _, mode in ipairs({ 'copy' }) do
    do
        local m0 = immut.map(mode)

        do
            assert(m0:size() == 0)
            assert(m0:empty() == true)

            assert(m0:has(42) == false)
            assert(m0:get(42) == nil)
            assert(m0:has('hello') == false)
            assert(m0:get('hello') == nil)
        end

        local m1 = m0:insert(42, 21)

        do
            assert(m0:size() == 0)
            assert(m0:empty() == true)

            assert(m0:has(42) == false)
            assert(m0:get(42) == nil)
            assert(m0:has('hello') == false)
            assert(m0:get('hello') == nil)
        end

        do
            assert(m1:size() == 1)
            assert(m1:empty() == false)

            assert(m1:has(42) == true)
            assert(m1:get(42) == 21)
            assert(m1:has('hello') == false)
            assert(m1:get('hello') == nil)
        end

        local m2 = m1:insert('hello', 'world')

        do
            assert(m0:size() == 0)
            assert(m0:empty() == true)

            assert(m0:has(42) == false)
            assert(m0:get(42) == nil)
            assert(m0:has('hello') == false)
            assert(m0:get('hello') == nil)
        end

        do
            assert(m1:size() == 1)
            assert(m1:empty() == false)

            assert(m1:has(42) == true)
            assert(m1:get(42) == 21)
            assert(m1:has('hello') == false)
            assert(m1:get('hello') == nil)
        end

        do
            assert(m2:size() == 2)
            assert(m2:empty() == false)

            assert(m2:has(42) == true)
            assert(m2:get(42) == 21)
            assert(m2:has('hello') == true)
            assert(m2:get('hello') == 'world')
        end
    end

    do
        local m2 = immut.map(mode):insert(42, 21):insert('hello', 'world')

        do
            assert(m2:size() == 2)
            assert(m2:empty() == false)

            assert(m2:has(42) == true)
            assert(m2:get(42) == 21)
            assert(m2:has('hello') == true)
            assert(m2:get('hello') == 'world')
        end

        local m2_removed_hello = m2:remove('hello')
        local m2_removed_42 = m2:remove(42)

        do
            assert(m2:size() == 2)
            assert(m2:empty() == false)

            assert(m2:has(42) == true)
            assert(m2:get(42) == 21)
            assert(m2:has('hello') == true)
            assert(m2:get('hello') == 'world')
        end

        do
            assert(m2_removed_hello:size() == 1)
            assert(m2_removed_hello:empty() == false)

            assert(m2_removed_hello:has(42) == true)
            assert(m2_removed_hello:get(42) == 21)
            assert(m2_removed_hello:has('hello') == false)
            assert(m2_removed_hello:get('hello') == nil)
        end

        do
            assert(m2_removed_42:size() == 1)
            assert(m2_removed_42:empty() == false)

            assert(m2_removed_42:has(42) == false)
            assert(m2_removed_42:get(42) == nil)
            assert(m2_removed_42:has('hello') == true)
            assert(m2_removed_42:get('hello') == 'world')
        end
    end
end
