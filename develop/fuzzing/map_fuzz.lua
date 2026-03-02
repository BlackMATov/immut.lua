local immut = require 'immut'

local N = 10

local INSERT_COUNT = math.random(5, 15)
local REMOVE_COUNT = math.random(10, 20)

---@type any[]
local POSSIBLE_KEYS_OR_VALUES = {}

---@return any
---@nodiscard
local function get_random_key_or_value()
    return POSSIBLE_KEYS_OR_VALUES[math.random(1, #POSSIBLE_KEYS_OR_VALUES)]
end

local function update_possible_keys_or_values()
    for _ = 1, math.random(5, 15) do
        local r = math.random(1, 4)

        if r == 1 then
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = math.random(1, 10)
        elseif r == 2 then
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = string.char(math.random(97, 122))
        elseif r == 3 then
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = math.random() < 0.5
        elseif r == 4 then
            POSSIBLE_KEYS_OR_VALUES[#POSSIBLE_KEYS_OR_VALUES + 1] = math.random() * 100
        else
            error 'unreachable'
        end
    end
end

for _ = 1, N do
    update_possible_keys_or_values()

    local curr_map = immut.map()

    local expected_key_values = {} ---@type table<any, any>
    local expected_size = 0 ---@type integer

    for _ = 1, INSERT_COUNT do
        local new_key = get_random_key_or_value()
        local new_value = get_random_key_or_value()

        local next_map = curr_map:insert(new_key, new_value)

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(curr_map:has(key) == true)
                assert(curr_map:get(key) == expected_key_values[key])
            else
                assert(curr_map:has(key) == false)
                assert(curr_map:get(key) == nil)
            end
        end

        if expected_key_values[new_key] ~= nil then
            if expected_key_values[new_key] == new_value then
                assert(curr_map == next_map)
            else
                assert(curr_map ~= next_map)
                expected_key_values[new_key] = new_value
            end
        else
            assert(curr_map ~= next_map)
            expected_key_values[new_key] = new_value
            expected_size = expected_size + 1
        end

        assert(next_map:size() == expected_size)

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(next_map:has(key) == true)
                assert(next_map:get(key) == expected_key_values[key])
            else
                assert(next_map:has(key) == false)
                assert(next_map:get(key) == nil)
            end
        end

        curr_map = next_map
    end
end

for _ = 1, N do
    local curr_map = immut.map()

    local expected_key_values = {} ---@type table<any, any>
    local expected_size = 0 ---@type integer

    for _ = 1, INSERT_COUNT do
        local new_key = get_random_key_or_value()
        local new_value = get_random_key_or_value()

        curr_map = curr_map:insert(new_key, new_value)

        if expected_key_values[new_key] == nil then
            expected_size = expected_size + 1
        end

        expected_key_values[new_key] = new_value
    end

    for _ = 1, REMOVE_COUNT do
        local rem_key = get_random_key_or_value()

        local next_map = curr_map:remove(rem_key)

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(curr_map:has(key) == true)
                assert(curr_map:get(key) == expected_key_values[key])
            else
                assert(curr_map:has(key) == false)
                assert(curr_map:get(key) == nil)
            end
        end

        if expected_key_values[rem_key] ~= nil then
            assert(curr_map ~= next_map)

            expected_key_values[rem_key] = nil
            expected_size = expected_size - 1
        else
            assert(curr_map == next_map)
        end

        assert(next_map:size() == expected_size)
        assert(next_map:empty() == (expected_size == 0))

        for _, key in ipairs(POSSIBLE_KEYS_OR_VALUES) do
            if expected_key_values[key] ~= nil then
                assert(next_map:has(key) == true)
                assert(next_map:get(key) == expected_key_values[key])
            else
                assert(next_map:has(key) == false)
                assert(next_map:get(key) == nil)
            end
        end

        curr_map = next_map
    end
end
