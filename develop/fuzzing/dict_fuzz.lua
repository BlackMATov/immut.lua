local dict = require 'immut'.dict

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

---@param d immut.dict
---@param expected_size integer
---@param expected_key_values table<any, any>
local function dict_looks_as_expected(d, expected_size, expected_key_values)
    local seen, count = {}, 0
    for k, v in dict.next, d, nil do
        assert(seen[k] == nil)
        count = count + 1
        seen[k] = v
    end
    assert(count == expected_size)
    for k, v in pairs(expected_key_values) do
        assert(seen[k] == v)
    end
end

do
    update_possible_keys_or_values()

    local curr_dict = dict.new()

    local expected_key_values = {} ---@type table<any, any>
    local expected_size = 0 ---@type integer

    for _ = 1, ASSOC_COUNT do
        local new_key = random_key_or_value()
        local new_value = random_key_or_value()

        local next_dict = dict.assoc(curr_dict, new_key, new_value)

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(dict.contains(curr_dict, key) == true)
                assert(dict.lookup(curr_dict, key) == expected_key_values[key])
            else
                assert(dict.contains(curr_dict, key) == false)
                assert(dict.lookup(curr_dict, key) == nil)
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

        assert(dict.size(next_dict) == expected_size)

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(dict.contains(next_dict, key) == true)
                assert(dict.lookup(next_dict, key) == expected_key_values[key])
            else
                assert(dict.contains(next_dict, key) == false)
                assert(dict.lookup(next_dict, key) == nil)
            end
        end

        dict_looks_as_expected(next_dict, expected_size, expected_key_values)

        curr_dict = next_dict
    end
end

do
    local curr_dict = dict.new()

    local expected_key_values = {} ---@type table<any, any>
    local expected_size = 0 ---@type integer

    for _ = 1, ASSOC_COUNT do
        local new_key = random_key_or_value()
        local new_value = random_key_or_value()

        curr_dict = dict.assoc(curr_dict, new_key, new_value)

        if expected_key_values[new_key] == nil then
            expected_size = expected_size + 1
        end

        expected_key_values[new_key] = new_value
    end

    for _ = 1, DISSOC_COUNT do
        local rem_key = random_key_or_value()

        local next_dict = dict.dissoc(curr_dict, rem_key)

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(dict.contains(curr_dict, key) == true)
                assert(dict.lookup(curr_dict, key) == expected_key_values[key])
            else
                assert(dict.contains(curr_dict, key) == false)
                assert(dict.lookup(curr_dict, key) == nil)
            end
        end

        if expected_key_values[rem_key] ~= nil then
            assert(curr_dict ~= next_dict)

            expected_key_values[rem_key] = nil
            expected_size = expected_size - 1
        else
            assert(curr_dict == next_dict)
        end

        assert(dict.size(next_dict) == expected_size)
        assert(dict.empty(next_dict) == (expected_size == 0))

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(dict.contains(next_dict, key) == true)
                assert(dict.lookup(next_dict, key) == expected_key_values[key])
            else
                assert(dict.contains(next_dict, key) == false)
                assert(dict.lookup(next_dict, key) == nil)
            end
        end

        dict_looks_as_expected(next_dict, expected_size, expected_key_values)

        curr_dict = next_dict
    end
end

do
    local curr_dict = dict.new()

    local expected_key_values = {} ---@type table<any, any>
    local expected_size = 0 ---@type integer

    for _ = 1, ASSOC_COUNT + DISSOC_COUNT do
        local r = math.random(1, 2)

        if r == 1 then
            local new_key = random_key_or_value()
            local new_value = random_key_or_value()

            local next_dict = dict.assoc(curr_dict, new_key, new_value)

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(dict.contains(curr_dict, key) == true)
                    assert(dict.lookup(curr_dict, key) == expected_key_values[key])
                else
                    assert(dict.contains(curr_dict, key) == false)
                    assert(dict.lookup(curr_dict, key) == nil)
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

            assert(dict.size(next_dict) == expected_size)

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(dict.contains(next_dict, key) == true)
                    assert(dict.lookup(next_dict, key) == expected_key_values[key])
                else
                    assert(dict.contains(next_dict, key) == false)
                    assert(dict.lookup(next_dict, key) == nil)
                end
            end

            dict_looks_as_expected(next_dict, expected_size, expected_key_values)

            curr_dict = next_dict
        elseif r == 2 then
            local rem_key = random_key_or_value()

            local next_dict = dict.dissoc(curr_dict, rem_key)

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(dict.contains(curr_dict, key) == true)
                    assert(dict.lookup(curr_dict, key) == expected_key_values[key])
                else
                    assert(dict.contains(curr_dict, key) == false)
                    assert(dict.lookup(curr_dict, key) == nil)
                end
            end

            if expected_key_values[rem_key] ~= nil then
                assert(curr_dict ~= next_dict)

                expected_key_values[rem_key] = nil
                expected_size = expected_size - 1
            else
                assert(curr_dict == next_dict)
            end

            assert(dict.size(next_dict) == expected_size)
            assert(dict.empty(next_dict) == (expected_size == 0))

            for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
                if expected_key_values[key] ~= nil then
                    assert(dict.contains(next_dict, key) == true)
                    assert(dict.lookup(next_dict, key) == expected_key_values[key])
                else
                    assert(dict.contains(next_dict, key) == false)
                    assert(dict.lookup(next_dict, key) == nil)
                end
            end

            dict_looks_as_expected(next_dict, expected_size, expected_key_values)

            curr_dict = next_dict
        end
    end
end
