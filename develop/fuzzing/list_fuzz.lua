local immut = require 'immut'

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

for _, mode in ipairs(immut.AVAILABLE_LIST_MODES) do
    do
        update_possible_keys_or_values()

        local curr_list = immut.list(mode)

        local expected_elems = {} ---@type table<integer, any>
        local expected_head_index, expected_last_index = 1, 0

        for _ = 1, OP_COUNT do
            local new_elem = random_key_or_value()

            if math.random(1, 2) == 1 then
                local next_list = curr_list:cons(new_elem)

                do
                    local i = expected_head_index
                    local iter_list = curr_list

                    while i <= expected_last_index do
                        assert(iter_list:head() == expected_elems[i])
                        assert(iter_list:last() == expected_elems[expected_last_index])
                        assert(iter_list:empty() == false)
                        assert(iter_list:size() == expected_last_index - i + 1)
                        iter_list = iter_list:tail()
                        i = i + 1
                    end

                    assert(iter_list:empty() == true)
                    assert(iter_list:size() == 0)
                end

                expected_elems[expected_head_index - 1] = new_elem
                expected_head_index = expected_head_index - 1

                do
                    local i = expected_head_index
                    local iter_list = next_list

                    while i <= expected_last_index do
                        assert(iter_list:head() == expected_elems[i])
                        assert(iter_list:last() == expected_elems[expected_last_index])
                        assert(iter_list:empty() == false)
                        assert(iter_list:size() == expected_last_index - i + 1)
                        iter_list = iter_list:tail()
                        i = i + 1
                    end

                    assert(iter_list:empty() == true)
                    assert(iter_list:size() == 0)
                end

                curr_list = next_list
            else
                local next_list = curr_list:snoc(new_elem)

                do
                    local i = expected_head_index
                    local iter_list = curr_list

                    while i <= expected_last_index do
                        assert(iter_list:head() == expected_elems[i])
                        assert(iter_list:last() == expected_elems[expected_last_index])
                        assert(iter_list:empty() == false)
                        assert(iter_list:size() == expected_last_index - i + 1)
                        iter_list = iter_list:tail()
                        i = i + 1
                    end

                    assert(iter_list:empty() == true)
                    assert(iter_list:size() == 0)
                end

                expected_elems[expected_last_index + 1] = new_elem
                expected_last_index = expected_last_index + 1

                do
                    local i = expected_head_index
                    local iter_list = next_list

                    while i <= expected_last_index do
                        assert(iter_list:head() == expected_elems[i])
                        assert(iter_list:last() == expected_elems[expected_last_index])
                        assert(iter_list:empty() == false)
                        assert(iter_list:size() == expected_last_index - i + 1)
                        iter_list = iter_list:tail()
                        i = i + 1
                    end

                    assert(iter_list:empty() == true)
                    assert(iter_list:size() == 0)
                end

                curr_list = next_list
            end
        end
    end
end
