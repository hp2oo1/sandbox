function flatten(input)
    local result = {}

    local function recursiveFlatten(nameList, valueList, prefix)
        local prefix = prefix or {}

        for i, v in ipairs(valueList) do
            if type(v) == "table" and v.Name and v.Value then
                local newPrefix = {}
                for i, p in ipairs(prefix) do
                    newPrefix[i] = p
                end
                for _, n in ipairs(v.Name) do
                    table.insert(newPrefix, n)
                end
                recursiveFlatten(v.Name, v.Value, newPrefix)
            else
                local flatEntry = {}
                for _, p in ipairs(prefix) do
                    table.insert(flatEntry, p)
                end
                table.insert(flatEntry, nameList[i])
                table.insert(flatEntry, v)
                table.insert(result, flatEntry)
            end
        end
    end

    for i, v in ipairs(input.Value) do
        if type(v) == "table" then
            recursiveFlatten(input.Name, v, {})
        else
            table.insert(result, { input.Name[i], v })
        end
    end

    return { Name = input.Name, Value = result }
end

-- Example usage
local sample_input = {
    Name = { 'schedule', 'physicalRedemptionLimit' },
    Value = {
        {
            { Name = { 'missCoupon', 'couponBarrier1' }, Value = { 0, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.7, 0 }}}},
            { Name = { 'missCoupon', 'couponBarrier1' }, Value = { 1, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.8, 0 }}}},
            { Name = { 'missCoupon', 'couponBarrier1' }, Value = { 2, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.9, 0 }}}}
        },
        0
    }
}

local flat = flatten(sample_input)
for _, v in ipairs(flat.Value) do
    print(table.concat(v, ", "))
end
