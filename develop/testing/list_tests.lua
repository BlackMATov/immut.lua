local list = require 'immut'.list
local basics = require 'develop.basics'

do
    local l0 = list.new()

    do
        assert(list.size(l0) == 0)
        assert(list.empty(l0) == true)
    end

    local l1 = list.cons(42, l0)

    do
        assert(list.size(l0) == 0)
        assert(list.empty(l0) == true)
    end

    do
        assert(list.size(l1) == 1)
        assert(list.empty(l1) == false)
        assert(list.head(l1) == 42)
        assert(list.last(l1) == 42)
        assert(list.size(list.tail(l1)) == 0)
        assert(list.empty(list.tail(l1)) == true)
        assert(list.size(list.init(l1)) == 0)
        assert(list.empty(list.init(l1)) == true)
    end

    local l2 = list.cons(21, l1)

    do
        assert(list.size(l0) == 0)
        assert(list.empty(l0) == true)
    end

    do
        assert(list.size(l1) == 1)
        assert(list.empty(l1) == false)
        assert(list.head(l1) == 42)
        assert(list.last(l1) == 42)
        assert(list.size(list.tail(l1)) == 0)
        assert(list.empty(list.tail(l1)) == true)
        assert(list.size(list.init(l1)) == 0)
        assert(list.empty(list.init(l1)) == true)
    end

    do
        assert(list.size(l2) == 2)
        assert(list.empty(l2) == false)
        assert(list.head(l2) == 21)
        assert(list.last(l2) == 42)
        assert(list.size(list.tail(l2)) == 1)
        assert(list.empty(list.tail(l2)) == false)
        assert(list.head(list.tail(l2)) == 42)
        assert(list.last(list.tail(l2)) == 42)
        assert(list.size(list.tail(list.tail(l2))) == 0)
        assert(list.empty(list.tail(list.tail(l2))) == true)
        assert(list.size(list.init(l2)) == 1)
        assert(list.empty(list.init(l2)) == false)
        assert(list.head(list.init(l2)) == 21)
        assert(list.last(list.init(l2)) == 21)
        assert(list.size(list.init(list.init(l2))) == 0)
        assert(list.empty(list.init(list.init(l2))) == true)
    end

    local l3 = list.snoc(l2, 84)

    do
        assert(list.size(l0) == 0)
        assert(list.empty(l0) == true)
    end

    do
        assert(list.size(l1) == 1)
        assert(list.empty(l1) == false)
        assert(list.head(l1) == 42)
        assert(list.last(l1) == 42)
        assert(list.size(list.tail(l1)) == 0)
        assert(list.empty(list.tail(l1)) == true)
        assert(list.size(list.init(l1)) == 0)
        assert(list.empty(list.init(l1)) == true)
    end

    do
        assert(list.size(l2) == 2)
        assert(list.empty(l2) == false)
        assert(list.head(l2) == 21)
        assert(list.last(l2) == 42)
        assert(list.size(list.tail(l2)) == 1)
        assert(list.empty(list.tail(l2)) == false)
        assert(list.head(list.tail(l2)) == 42)
        assert(list.last(list.tail(l2)) == 42)
        assert(list.size(list.tail(list.tail(l2))) == 0)
        assert(list.empty(list.tail(list.tail(l2))) == true)
        assert(list.size(list.init(l2)) == 1)
        assert(list.empty(list.init(l2)) == false)
        assert(list.head(list.init(l2)) == 21)
        assert(list.last(list.init(l2)) == 21)
        assert(list.size(list.init(list.init(l2))) == 0)
        assert(list.empty(list.init(list.init(l2))) == true)
    end

    do
        assert(list.size(l3) == 3)
        assert(list.empty(l3) == false)
        assert(list.head(l3) == 21)
        assert(list.last(l3) == 84)
        assert(list.size(list.tail(l3)) == 2)
        assert(list.empty(list.tail(l3)) == false)
        assert(list.head(list.tail(l3)) == 42)
        assert(list.last(list.tail(l3)) == 84)
        assert(list.size(list.tail(list.tail(l3))) == 1)
        assert(list.empty(list.tail(list.tail(l3))) == false)
        assert(list.head(list.tail(list.tail(l3))) == 84)
        assert(list.last(list.tail(list.tail(l3))) == 84)
    end
end

do
    local l = list.cons(3, list.cons(2, list.cons(1, list.new())))
    assert(list.size(l) == 3 and not list.empty(l))

    do
        local l_tail = list.tail(l)
        assert(list.size(l_tail) == 2 and not list.empty(l_tail))
        assert(list.head(l_tail) == 2 and list.last(l_tail) == 1)

        local l_tail_tail = list.tail(l_tail)
        assert(list.size(l_tail_tail) == 1 and not list.empty(l_tail_tail))
        assert(list.head(l_tail_tail) == 1 and list.last(l_tail_tail) == 1)

        local l_tail_tail_tail = list.tail(l_tail_tail)
        assert(list.size(l_tail_tail_tail) == 0 and list.empty(l_tail_tail_tail))
    end

    do
        local l_init = list.init(l)
        assert(list.size(l_init) == 2 and not list.empty(l_init))
        assert(list.head(l_init) == 3 and list.last(l_init) == 2)

        local l_init_init = list.init(l_init)
        assert(list.size(l_init_init) == 1 and not list.empty(l_init_init))
        assert(list.head(l_init_init) == 3 and list.last(l_init_init) == 3)

        local l_init_init_init = list.init(l_init_init)
        assert(list.size(l_init_init_init) == 0 and list.empty(l_init_init_init))
    end
end

do
    local l = list.new()
    assert(list.size(l) == 0 and list.empty(l))

    local l1 = list.snoc(l, 1)
    assert(list.size(l1) == 1 and not list.empty(l1))
    assert(list.head(l1) == 1 and list.last(l1) == 1)

    local l2 = list.snoc(l1, 2)
    assert(list.size(l2) == 2 and not list.empty(l2))
    assert(list.head(l2) == 1 and list.last(l2) == 2)

    local l3 = list.snoc(l2, 3)
    assert(list.size(l3) == 3 and not list.empty(l3))
    assert(list.head(l3) == 1 and list.last(l3) == 3)
end

do
    do
        local l1 = list.cons(42, list.new())

        local h, t = list.uncons(l1)
        assert(h == 42 and list.empty(t))

        local i, l = list.unsnoc(l1)
        assert(list.empty(i) and l == 42)
    end

    do
        local l2 = list.cons(21, list.cons(42, list.new()))

        local h, t = list.uncons(l2)
        assert(h == 21 and list.head(t) == 42 and list.last(t) == 42)

        local i, l = list.unsnoc(l2)
        assert(list.head(i) == 21 and list.last(i) == 21 and l == 42)
    end
end

do
    do
        local l0 = list.from_table({})
        assert(list.size(l0) == 0 and list.empty(l0))

        local t0 = list.to_table(l0)
        assert(#t0 == 0)
    end

    do
        local l1 = list.from_table({ 42 })
        assert(list.size(l1) == 1 and not list.empty(l1))
        assert(list.head(l1) == 42 and list.last(l1) == 42)

        local t1 = list.to_table(l1)
        assert(#t1 == 1 and t1[1] == 42)
    end

    do
        local l2 = list.from_table({ 21, 42 })
        assert(list.size(l2) == 2 and not list.empty(l2))
        assert(list.head(l2) == 21 and list.last(l2) == 42)

        local t2 = list.to_table(l2)
        assert(#t2 == 2 and t2[1] == 21 and t2[2] == 42)
    end

    do
        local l2 = list.from_table({ 1, 2, nil, 3 }, 1, 2)
        assert(list.size(l2) == 2 and not list.empty(l2))
        assert(list.head(l2) == 1 and list.last(l2) == 2)
    end

    do
        local l2 = list.from_table({ 1, 2, 3, nil, 5 }, 2, 3)
        assert(list.size(l2) == 2 and not list.empty(l2))
        assert(list.head(l2) == 2 and list.last(l2) == 3)

        local l3 = list.from_table({ 1, 2, 3, nil, 5 }, 1, 3)
        assert(list.size(l3) == 3 and not list.empty(l3))
        assert(list.head(l3) == 1 and list.last(l3) == 3)
    end

    do
        local l = list.from_table({ 1, 2, 3 })

        local t1 = list.to_table(l)
        assert(t1[1] == 1 and t1[2] == 2 and t1[3] == 3)

        local t2 = list.to_table(l, 2)
        assert(t2[1] == nil and t2[2] == 1 and t2[3] == 2 and t2[4] == 3)

        local t3 = {}
        list.to_table(l, 2, t3)
        assert(t3[1] == nil and t3[2] == 1 and t3[3] == 2 and t3[4] == 3)
    end
end

do
    do
        local l0 = list.from_vargs()
        assert(list.size(l0) == 0 and list.empty(l0))

        local e1 = list.to_vargs(l0)
        assert(e1 == nil)
    end

    do
        local l3 = list.from_vargs(1, 2, 3)
        assert(list.size(l3) == 3 and not list.empty(l3))
        assert(list.head(l3) == 1 and list.last(l3) == 3)

        local e1, e2, e3, e4 = list.to_vargs(l3)
        assert(e1 == 1 and e2 == 2 and e3 == 3 and e4 == nil)
    end
end

do
    basics.describe_error(function() _ = list.head(list.new()) end)
    basics.describe_error(function() _ = list.last(list.new()) end)
    basics.describe_error(function() _ = list.tail(list.new()) end)
    basics.describe_error(function() _ = list.init(list.new()) end)
    basics.describe_error(function() _ = list.cons(nil, list.new()) end)
    basics.describe_error(function() _ = list.snoc(list.new(), nil) end)
    basics.describe_error(function() _ = list.uncons(list.new()) end)
    basics.describe_error(function() _ = list.unsnoc(list.new()) end)
end
