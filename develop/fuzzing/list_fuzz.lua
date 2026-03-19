local list = require 'immut'.list

local OP_COUNT = math.random(5, 15)

---@type any[]
local POSSIBLE_KEYS_OR_VALUES = {}

---@return any
---@nodiscard
local function random_key_or_value()
    return POSSIBLE_KEYS_OR_VALUES[math.random(1, #POSSIBLE_KEYS_OR_VALUES)]
end

local function update_possible_keys_or_values()
    for _ = 1, math.random(5, 15) do
        local r = math.random(1, 4)

        if r == 1 then
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = math.random(1, 10)
        elseif r == 2 then
            local chars = {}
            for i = 1, math.random(0, 10) do
                chars[i] = string.char(math.random(97, 122))
            end
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = table.concat(chars)
        elseif r == 3 then
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = math.random() < 0.5
        elseif r == 4 then
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = -100 + math.random() * 200
        else
            error 'unreachable'
        end
    end
end

do
    update_possible_keys_or_values()

    local curr_list = list.new()

    local expected_elems = {} ---@type table<integer, any>
    local expected_head_index, expected_last_index = 1, 0

    for _ = 1, OP_COUNT do
        local new_elem = random_key_or_value()

        if math.random(1, 2) == 1 then
            local next_list = list.cons(curr_list, new_elem)

            do
                local i = expected_head_index
                local iter_list = curr_list

                while i <= expected_last_index do
                    assert(list.head(iter_list) == expected_elems[i])
                    assert(list.last(iter_list) == expected_elems[expected_last_index])
                    assert(list.empty(iter_list) == false)
                    assert(list.size(iter_list) == expected_last_index - i + 1)
                    iter_list = list.tail(iter_list)
                    i = i + 1
                end

                assert(list.empty(iter_list) == true)
                assert(list.size(iter_list) == 0)
            end

            expected_elems[expected_head_index - 1] = new_elem
            expected_head_index = expected_head_index - 1

            do
                local i = expected_head_index
                local iter_list = next_list

                while i <= expected_last_index do
                    assert(list.head(iter_list) == expected_elems[i])
                    assert(list.last(iter_list) == expected_elems[expected_last_index])
                    assert(list.empty(iter_list) == false)
                    assert(list.size(iter_list) == expected_last_index - i + 1)
                    iter_list = list.tail(iter_list)
                    i = i + 1
                end

                assert(list.empty(iter_list) == true)
                assert(list.size(iter_list) == 0)
            end

            curr_list = next_list
        else
            local next_list = list.snoc(curr_list, new_elem)

            do
                local i = expected_head_index
                local iter_list = curr_list

                while i <= expected_last_index do
                    assert(list.head(iter_list) == expected_elems[i])
                    assert(list.last(iter_list) == expected_elems[expected_last_index])
                    assert(list.empty(iter_list) == false)
                    assert(list.size(iter_list) == expected_last_index - i + 1)
                    iter_list = list.tail(iter_list)
                    i = i + 1
                end

                assert(list.empty(iter_list) == true)
                assert(list.size(iter_list) == 0)
            end

            expected_elems[expected_last_index + 1] = new_elem
            expected_last_index = expected_last_index + 1

            do
                local i = expected_head_index
                local iter_list = next_list

                while i <= expected_last_index do
                    assert(list.head(iter_list) == expected_elems[i])
                    assert(list.last(iter_list) == expected_elems[expected_last_index])
                    assert(list.empty(iter_list) == false)
                    assert(list.size(iter_list) == expected_last_index - i + 1)
                    iter_list = list.tail(iter_list)
                    i = i + 1
                end

                assert(list.empty(iter_list) == true)
                assert(list.size(iter_list) == 0)
            end

            curr_list = next_list
        end
    end
end
