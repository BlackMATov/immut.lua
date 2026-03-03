local immut = require 'immut'

for _, mode in ipairs(immut.AVAILABLE_LIST_MODES) do
    do
        local l0 = immut.list(mode)

        do
            assert(l0:size() == 0)
            assert(l0:empty() == true)
            assert(l0:head() == nil)
            assert(l0:last() == nil)
            assert(l0:tail() == nil)
            assert(l0:init() == nil)
        end

        local l1 = l0:cons(42)

        do
            assert(l0:size() == 0)
            assert(l0:empty() == true)
            assert(l0:head() == nil)
            assert(l0:last() == nil)
            assert(l0:tail() == nil)
            assert(l0:init() == nil)
        end

        do
            assert(l1:size() == 1)
            assert(l1:empty() == false)
            assert(l1:head() == 42)
            assert(l1:last() == 42)
            assert(l1:tail():size() == 0)
            assert(l1:tail():empty() == true)
            assert(l1:init():size() == 0)
            assert(l1:init():empty() == true)
        end

        local l2 = l1:cons(21)

        do
            assert(l0:size() == 0)
            assert(l0:empty() == true)
            assert(l0:head() == nil)
            assert(l0:last() == nil)
            assert(l0:tail() == nil)
            assert(l0:init() == nil)
        end

        do
            assert(l1:size() == 1)
            assert(l1:empty() == false)
            assert(l1:head() == 42)
            assert(l1:last() == 42)
            assert(l1:tail():size() == 0)
            assert(l1:tail():empty() == true)
            assert(l1:init():size() == 0)
            assert(l1:init():empty() == true)
        end

        do
            assert(l2:size() == 2)
            assert(l2:empty() == false)
            assert(l2:head() == 21)
            assert(l2:last() == 42)
            assert(l2:tail():size() == 1)
            assert(l2:tail():empty() == false)
            assert(l2:tail():head() == 42)
            assert(l2:tail():last() == 42)
            assert(l2:tail():tail():size() == 0)
            assert(l2:tail():tail():empty() == true)
            assert(l2:init():size() == 1)
            assert(l2:init():empty() == false)
            assert(l2:init():head() == 21)
            assert(l2:init():last() == 21)
            assert(l2:init():init():size() == 0)
            assert(l2:init():init():empty() == true)
        end

        local l3 = l2:snoc(84)

        do
            assert(l0:size() == 0)
            assert(l0:empty() == true)
            assert(l0:head() == nil)
            assert(l0:last() == nil)
            assert(l0:tail() == nil)
            assert(l0:init() == nil)
        end

        do
            assert(l1:size() == 1)
            assert(l1:empty() == false)
            assert(l1:head() == 42)
            assert(l1:last() == 42)
            assert(l1:tail():size() == 0)
            assert(l1:tail():empty() == true)
            assert(l1:init():size() == 0)
            assert(l1:init():empty() == true)
        end

        do
            assert(l2:size() == 2)
            assert(l2:empty() == false)
            assert(l2:head() == 21)
            assert(l2:last() == 42)
            assert(l2:tail():size() == 1)
            assert(l2:tail():empty() == false)
            assert(l2:tail():head() == 42)
            assert(l2:tail():last() == 42)
            assert(l2:tail():tail():size() == 0)
            assert(l2:tail():tail():empty() == true)
            assert(l2:init():size() == 1)
            assert(l2:init():empty() == false)
            assert(l2:init():head() == 21)
            assert(l2:init():last() == 21)
            assert(l2:init():init():size() == 0)
            assert(l2:init():init():empty() == true)
        end

        do
            assert(l3:size() == 3)
            assert(l3:empty() == false)
            assert(l3:head() == 21)
            assert(l3:last() == 84)
            assert(l3:tail():size() == 2)
            assert(l3:tail():empty() == false)
            assert(l3:tail():head() == 42)
            assert(l3:tail():last() == 84)
            assert(l3:tail():tail():size() == 1)
            assert(l3:tail():tail():empty() == false)
            assert(l3:tail():tail():head() == 84)
            assert(l3:tail():tail():last() == 84)
        end
    end
end
