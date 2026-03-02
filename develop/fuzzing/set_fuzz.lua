local immut = require 'immut'

local N = 10

local INSERT_COUNT = math.random(5, 15)
local REMOVE_COUNT = math.random(10, 20)

---@type any[]
local POSSIBLE_KEYS = {}

---@return any
---@nodiscard
local function get_random_key()
    return POSSIBLE_KEYS[math.random(1, #POSSIBLE_KEYS)]
end

local function update_possible_keys()
    for _ = 1, math.random(5, 15) do
        local r = math.random(1, 4)

        if r == 1 then
            POSSIBLE_KEYS[#POSSIBLE_KEYS + 1] = math.random(1, 10)
        elseif r == 2 then
            POSSIBLE_KEYS[#POSSIBLE_KEYS + 1] = string.char(math.random(97, 122))
        elseif r == 3 then
            POSSIBLE_KEYS[#POSSIBLE_KEYS + 1] = math.random() < 0.5
        elseif r == 4 then
            POSSIBLE_KEYS[#POSSIBLE_KEYS + 1] = math.random() * 100
        else
            error 'unreachable'
        end
    end
end

for _ = 1, N do
    update_possible_keys()

    local curr_set = immut.set()

    local expected_keys = {} ---@type table<any, boolean>
    local expected_size = 0 ---@type integer

    for _ = 1, INSERT_COUNT do
        local new_key = get_random_key()

        local next_set = curr_set:insert(new_key)

        for _, key in ipairs(POSSIBLE_KEYS) do
            if expected_keys[key] then
                assert(curr_set:has(key) == true)
            else
                assert(curr_set:has(key) == false)
            end
        end

        if expected_keys[new_key] ~= nil then
            assert(curr_set == next_set)
        else
            assert(curr_set ~= next_set)
            expected_keys[new_key] = true
            expected_size = expected_size + 1
        end

        assert(next_set:size() == expected_size)

        for _, key in ipairs(POSSIBLE_KEYS) do
            if expected_keys[key] ~= nil then
                assert(next_set:has(key) == true)
            else
                assert(next_set:has(key) == false)
            end
        end

        curr_set = next_set
    end
end

for _ = 1, N do
    local curr_set = immut.set()

    local expected_keys = {} ---@type table<any, boolean>
    local expected_size = 0 ---@type integer

    for _ = 1, INSERT_COUNT do
        local new_key = get_random_key()

        curr_set = curr_set:insert(new_key)

        if expected_keys[new_key] == nil then
            expected_size = expected_size + 1
        end

        expected_keys[new_key] = true
    end

    for _ = 1, REMOVE_COUNT do
        local rem_key = get_random_key()

        local next_set = curr_set:remove(rem_key)

        for _, key in ipairs(POSSIBLE_KEYS) do
            if expected_keys[key] ~= nil then
                assert(curr_set:has(key) == true)
            else
                assert(curr_set:has(key) == false)
            end
        end

        if expected_keys[rem_key] ~= nil then
            assert(curr_set ~= next_set)

            expected_keys[rem_key] = nil
            expected_size = expected_size - 1
        else
            assert(curr_set == next_set)
        end

        assert(next_set:size() == expected_size)
        assert(next_set:empty() == (expected_size == 0))

        for _, key in ipairs(POSSIBLE_KEYS) do
            if expected_keys[key] ~= nil then
                assert(next_set:has(key) == true)
            else
                assert(next_set:has(key) == false)
            end
        end

        curr_set = next_set
    end
end
