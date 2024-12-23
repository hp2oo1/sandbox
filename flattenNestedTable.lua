function flatten(input)
    local output = { Name = input.Name, Value = {} }
    local flattened = {}

    local function recursiveFlatten(tbl, prefix)
        for _, v in ipairs(tbl) do
            if type(v) == 'table' then
                local namePart = table.concat(v.Name, '_')
                local newPrefix = prefix and (prefix .. '_' .. namePart) or namePart
                
                if v.Value and type(v.Value[1]) == 'table' then
                    recursiveFlatten(v.Value, newPrefix)
                else
                    if not flattened[newPrefix] then
                        flattened[newPrefix] = {}
                    end
                    for _, val in ipairs(v.Value) do
                        table.insert(flattened[newPrefix], val)
                    end
                end
            else
                table.insert(flattened[prefix], v)
            end
        end
    end

    recursiveFlatten(input.Value, input.Name[2])

    local dict = {}
    for key, values in pairs(flattened) do
        table.insert(dict, { Value = { key, nil, table.unpack(values) } })
    end

    output.Value = { { Name = { input.Name[2] }, Value = dict }, 0 }
    return output
end

-- Example Usage
local sample_input = {
    Name = { 'schedule', 'physicalRedemptionLimit' },
    Value = {
        {
            Name = { 'missCoupon', 'couponBarrier1' }, Value = { 0, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.7, 0 }}}},
        {
            Name = { 'missCoupon', 'couponBarrier1' }, Value = { 1, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.8, 0 }}}},
        {
            Name = { 'missCoupon', 'couponBarrier1' }, Value = { 2, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.9, 0 }}}}
    }
}

local sample_output = flatten(sample_input)
for _, v in ipairs(sample_output.Value) do
    print(table.concat(v.Value, ', '))
end
