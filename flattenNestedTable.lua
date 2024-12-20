function flattenToOutput(nestedTable)
    local flattened = {}
    local columnNames = {}

    local function processEntry(entry)
        for _, column in ipairs(entry.Name) do
            if not flattened[column] then
                flattened[column] = {}
                table.insert(columnNames, column)
            end
        end

        for i, value in ipairs(entry.Value) do
            if type(value) == "table" and value.Name and value.Value then
                processEntry(value) -- Process nested structures
            else
                local column = entry.Name[i]
                if column then
                    table.insert(flattened[column], value)
                end
            end
        end
    end

    for _, entry in ipairs(nestedTable.Value) do
        processEntry(entry)
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

local schedule_output = flattenToOutput(schedule_input)

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
