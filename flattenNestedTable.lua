function flatten(input)
    local result = {}

    local function recursiveFlatten(nameList, valueList, prefix)
        local prefix = prefix or {}

        for i, v in ipairs(valueList) do
            if type(v) == "table" then
                if v.Name and v.Value then
                    local newPrefix = {}
                    for i, p in ipairs(prefix) do
                        newPrefix[i] = p
                    end
                    for _, n in ipairs(v.Name) do
                        table.insert(newPrefix, n)
                    end
                    recursiveFlatten(v.Name, v.Value, newPrefix)
                else
                    recursiveFlatten(nameList, v, prefix)
                end
            else
                local flatEntry = { Value = {} }
                for _, p in ipairs(prefix) do
                    table.insert(flatEntry.Value, p)
                end
                table.insert(flatEntry.Value, nameList[i])
                table.insert(flatEntry.Value, v)
                table.insert(result, flatEntry)
            end
        end
    end

    for i, v in ipairs(input.Value) do
        if type(v) == "table" then
            recursiveFlatten(input.Name, v, {})
        else
            local flatEntry = { Value = { input.Name[i], v } }
            table.insert(result, flatEntry)
        end
    end

    return { Name = result[1].Value, Value = result }
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
    print(table.concat(v.Value, ", "))
end
