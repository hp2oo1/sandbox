function flatten(input)
    local output = { Name = input.Name, Value = {} }
    local flattened = {}

    local function recursiveFlatten(tbl, prefix)
        for _, v in ipairs(tbl) do
            if type(v) == 'table' and v.Name and v.Value then
                local namePart = table.concat(v.Name, '_')
                local newPrefix = prefix and (prefix .. '_' .. namePart) or namePart
                
                if type(v.Value) == 'table' and #v.Value > 0 and type(v.Value[1]) == 'table' then
                    recursiveFlatten(v.Value, newPrefix)
                else
                    if not flattened[newPrefix] then
                        flattened[newPrefix] = {}
                    end
                    if type(v.Value) == 'table' then
                        for _, val in ipairs(v.Value) do
                            table.insert(flattened[newPrefix], val)
                        end
                    else
                        table.insert(flattened[newPrefix], v.Value)
                    end
                end
            else
                flattened[prefix] = flattened[prefix] or {}
                table.insert(flattened[prefix], v)
            end
        end
    end

    if type(input.Value) == 'table' and #input.Value > 0 and type(input.Value[1]) == 'table' then
        recursiveFlatten(input.Value, table.concat(input.Name, '_'))
    else
        output.Value = input.Value
        return output
    end

    local dict = {}
    for key, values in pairs(flattened) do
        table.insert(dict, { key, nil, table.unpack(values) })
    end

    local final_value = next(dict) and 0 or nil
    output.Value = { dict, final_value }
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
    print(table.concat(v, ', '))
end
