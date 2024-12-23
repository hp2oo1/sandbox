function flatten(input)
    local result = {}

    local function recursiveFlatten(tbl, prefix)
        local prefix = prefix or {}
        local hasNestedTable = false

        for _, v in ipairs(tbl) do
            if type(v) == "table" and v.Name and v.Value then
                hasNestedTable = true
                local newPrefix = {}
                for i, p in ipairs(prefix) do
                    newPrefix[i] = p
                end
                for _, n in ipairs(v.Name) do
                    table.insert(newPrefix, n)
                end
                recursiveFlatten(v.Value, newPrefix)
            else
                if not hasNestedTable then
                    local flatEntry = { Value = {} }
                    for _, p in ipairs(prefix) do
                        table.insert(flatEntry.Value, p)
                    end
                    table.insert(flatEntry.Value, nil)
                    for _, val in ipairs(tbl) do
                        table.insert(flatEntry.Value, val)
                    end
                    table.insert(result, flatEntry)
                end
            end
        end
    end

    recursiveFlatten(input.Value, input.Name)
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
