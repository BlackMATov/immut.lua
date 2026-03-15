local immut = require 'immut'

local ASSOC_COUNT = math.random(5, 15)
local DISSOC_COUNT = math.random(10, 20)

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

for _, mode in ipairs(immut.AVAILABLE_DICT_MODES) do
    do
        update_possible_keys_or_values()

        local curr_dict = immut.dict(mode)

        local expected_key_values = {} ---@type table<any, any>
        local expected_size = 0 ---@type integer

        for _ = 1, ASSOC_COUNT do
            local new_key = random_key_or_value()
            local new_value = random_key_or_value()

            local next_dict = curr_dict:assoc(new_key, new_value)

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(curr_dict:contains(key) == true)
                    assert(curr_dict:lookup(key) == expected_key_values[key])
                else
                    assert(curr_dict:contains(key) == false)
                    assert(curr_dict:lookup(key) == nil)
                end
            end

            if expected_key_values[new_key] ~= nil then
                if expected_key_values[new_key] == new_value then
                    assert(curr_dict == next_dict)
                else
                    assert(curr_dict ~= next_dict)
                    expected_key_values[new_key] = new_value
                end
            else
                assert(curr_dict ~= next_dict)
                expected_key_values[new_key] = new_value
                expected_size = expected_size + 1
            end

            assert(next_dict:size() == expected_size)

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(next_dict:contains(key) == true)
                    assert(next_dict:lookup(key) == expected_key_values[key])
                else
                    assert(next_dict:contains(key) == false)
                    assert(next_dict:lookup(key) == nil)
                end
            end

            curr_dict = next_dict
        end
    end

    do
        local curr_dict = immut.dict(mode)

        local expected_key_values = {} ---@type table<any, any>
        local expected_size = 0 ---@type integer

        for _ = 1, ASSOC_COUNT do
            local new_key = random_key_or_value()
            local new_value = random_key_or_value()

            curr_dict = curr_dict:assoc(new_key, new_value)

            if expected_key_values[new_key] == nil then
                expected_size = expected_size + 1
            end

            expected_key_values[new_key] = new_value
        end

        for _ = 1, DISSOC_COUNT do
            local rem_key = random_key_or_value()

            local next_dict = curr_dict:dissoc(rem_key)

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(curr_dict:contains(key) == true)
                    assert(curr_dict:lookup(key) == expected_key_values[key])
                else
                    assert(curr_dict:contains(key) == false)
                    assert(curr_dict:lookup(key) == nil)
                end
            end

            if expected_key_values[rem_key] ~= nil then
                assert(curr_dict ~= next_dict)

                expected_key_values[rem_key] = nil
                expected_size = expected_size - 1
            else
                assert(curr_dict == next_dict)
            end

            assert(next_dict:size() == expected_size)
            assert(next_dict:empty() == (expected_size == 0))

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(next_dict:contains(key) == true)
                    assert(next_dict:lookup(key) == expected_key_values[key])
                else
                    assert(next_dict:contains(key) == false)
                    assert(next_dict:lookup(key) == nil)
                end
            end

            curr_dict = next_dict
        end
    end

    do
        local curr_dict = immut.dict(mode)

        local expected_key_values = {} ---@type table<any, any>
        local expected_size = 0 ---@type integer

        for _ = 1, ASSOC_COUNT + DISSOC_COUNT do
            local r = math.random(1, 2)

            if r == 1 then
                local new_key = random_key_or_value()
                local new_value = random_key_or_value()

                local next_dict = curr_dict:assoc(new_key, new_value)

                for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                    if expected_key_values[key] ~= nil then
                        assert(curr_dict:contains(key) == true)
                        assert(curr_dict:lookup(key) == expected_key_values[key])
                    else
                        assert(curr_dict:contains(key) == false)
                        assert(curr_dict:lookup(key) == nil)
                    end
                end

                if expected_key_values[new_key] ~= nil then
                    if expected_key_values[new_key] == new_value then
                        assert(curr_dict == next_dict)
                    else
                        assert(curr_dict ~= next_dict)
                        expected_key_values[new_key] = new_value
                    end
                else
                    assert(curr_dict ~= next_dict)
                    expected_key_values[new_key] = new_value
                    expected_size = expected_size + 1
                end

                assert(next_dict:size() == expected_size)

                for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                    if expected_key_values[key] ~= nil then
                        assert(next_dict:contains(key) == true)
                        assert(next_dict:lookup(key) == expected_key_values[key])
                    else
                        assert(next_dict:contains(key) == false)
                        assert(next_dict:lookup(key) == nil)
                    end
                end

                curr_dict = next_dict
            elseif r == 2 then
                local rem_key = random_key_or_value()

                local next_dict = curr_dict:dissoc(rem_key)

                for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                    if expected_key_values[key] ~= nil then
                        assert(curr_dict:contains(key) == true)
                        assert(curr_dict:lookup(key) == expected_key_values[key])
                    else
                        assert(curr_dict:contains(key) == false)
                        assert(curr_dict:lookup(key) == nil)
                    end
                end

                if expected_key_values[rem_key] ~= nil then
                    assert(curr_dict ~= next_dict)

                    expected_key_values[rem_key] = nil
                    expected_size = expected_size - 1
                else
                    assert(curr_dict == next_dict)
                end

                assert(next_dict:size() == expected_size)
                assert(next_dict:empty() == (expected_size == 0))

                for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                    if expected_key_values[key] ~= nil then
                        assert(next_dict:contains(key) == true)
                        assert(next_dict:lookup(key) == expected_key_values[key])
                    else
                        assert(next_dict:contains(key) == false)
                        assert(next_dict:lookup(key) == nil)
                    end
                end

                curr_dict = next_dict
            end
        end
    end
end
