function flatten(input)
    local output = { Name = input.Name, Value = {} }
    
    local function recursiveFlatten(tbl, prefix)
        for _, v in ipairs(tbl) do
            local newPrefix = prefix and (prefix .. '_' .. v.Name[2]) or v.Name[2]
            if v.Value and type(v.Value[1]) == 'table' then
                recursiveFlatten(v.Value, newPrefix)
            else
                table.insert(output.Value, { Value = { newPrefix, table.unpack(v.Value) } })
            end
        end
    end

    recursiveFlatten(input.Value, nil)
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
