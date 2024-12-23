function flatten(input)
    local output = { Name = input.Name, Value = {} }
    local temp = {}

    local function recursiveFlatten(tbl, prefix)
        for _, v in ipairs(tbl) do
            if type(v) == 'table' then
                local newPrefix = prefix and (prefix .. '_' .. v.Name[2]) or v.Name[2]
                
                if v.Value and type(v.Value[1]) == 'table' then
                    recursiveFlatten(v.Value, newPrefix)
                else
                    temp[newPrefix] = temp[newPrefix] or {}
                    for _, val in ipairs(v.Value) do
                        table.insert(temp[newPrefix], val)
                    end
                end
            else
                temp[prefix] = temp[prefix] or {}
                table.insert(temp[prefix], v)
            end
        end
    end

    recursiveFlatten(input.Value, nil)

    for key, values in pairs(temp) do
        table.insert(output.Value, { Value = { key, nil, table.unpack(values) } })
    end

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
