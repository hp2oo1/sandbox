function flatten(input)
    local output = { Name = input.Name, Value = {} }
    local flattened = { Name = {}, Value = {} }

    local function recursiveFlatten(tbl, prefix)
        for _, v in ipairs(tbl) do
            if type(v) == 'table' and v.Name and v.Value then
                local namePart = table.concat(v.Name, '_')
                local newPrefix = prefix and (prefix .. '_' .. namePart) or namePart
                
                if type(v.Value) == 'table' and #v.Value > 0 and type(v.Value[1]) == 'table' then
                    recursiveFlatten(v.Value, newPrefix)
                else
                    table.insert(flattened.Name, newPrefix)
                    if type(v.Value) == 'table' then
                        table.insert(flattened.Value, table.unpack(v.Value))
                    else
                        table.insert(flattened.Value, v.Value)
                    end
                end
            else
                table.insert(flattened.Name, prefix)
                table.insert(flattened.Value, v)
            end
        end
    end

    if type(input.Value) == 'table' and #input.Value > 0 and type(input.Value[1]) == 'table' then
        recursiveFlatten(input.Value, table.concat(input.Name, '_'))
    else
        output.Value = input.Value
        return output
    end

    output.Value = { flattened, 0 }
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
for _, v in ipairs(sample_output.Value.Name) do
    print(v)
end
for _, v in ipairs(sample_output.Value.Value) do
    print(v)
end
