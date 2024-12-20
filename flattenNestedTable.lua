function flattenToOutput(nestedTable)
    local flattened = {}
    local columnNames = {}

    local function recurse(currentTable, prefix)
        for key, value in pairs(currentTable) do
            local newKey = prefix and (prefix .. "_" .. key) or key

            if type(value) == "table" then
                recurse(value, newKey)
            else
                if not flattened[newKey] then
                    flattened[newKey] = {}
                    table.insert(columnNames, newKey)
                end
                table.insert(flattened[newKey], value)
            end
        end
    end

    for _, entry in ipairs(nestedTable) do
        recurse(entry, nil) -- Start flattening each entry in the array
    end

    local output = { Name = columnNames, Value = {} }

    for _, name in ipairs(columnNames) do
        table.insert(output.Value, { Value = flattened[name] })
    end

    return output
end

-- Example usage
local schedule_input = {
    Value = {
        { Name = { 'missCoupon', 'couponBarrier1' }, Value = { 0, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.7, 0 } } }},
        { Name = { 'missCoupon', 'couponBarrier1' }, Value = { 1, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.8, 0 } } }},
        { Name = { 'missCoupon', 'couponBarrier1' }, Value = { 2, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.9, 0 } } }}
    }
}

local schedule_output = {
    Name = { 'missCoupon', 'couponBarrier1_barrierLevel', 'couponBarrier1_barrierLevelOverhedge' },
    Value = {
        { Value = { 'missCoupon', nil, 0, 1, 2 }}, 
        { Value = { 'couponBarrier1_barrierLevel', nil, 0.7, 0.8, 0.9 }}, 
        { Value = { 'couponBarrier1_barrierLevelOverhedge', nil, 0, 0, 0 }} 
    }
}

-- Print the result for verification
io.write("Name = { ")
for _, name in ipairs(schedule_output.Name) do
    io.write("'" .. name .. "', ")
end
io.write("}\n")
io.write("Value = {\n")
for _, row in ipairs(schedule_output.Value) do
    io.write("  { Value = { ")
    for _, value in ipairs(row.Value) do
        io.write(value .. ", ")
    end
    io.write("} },\n")
end
io.write("}\n")
