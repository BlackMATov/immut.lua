local list = require 'immut'.list

do
    local l0 = list.new()

    do
        assert(list.size(l0) == 0)
        assert(list.empty(l0) == true)
    end

    local l1 = list.cons(l0, 42)

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

    local l2 = list.cons(l1, 21)

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
    local l = list.cons(list.cons(list.cons(list.new(), 1), 2), 3)
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
