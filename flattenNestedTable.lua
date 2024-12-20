local function isTable(value)
    return type(value) == 'table'
end

local function flatten(nestedTable)
    local flattened = {}
    local columnNames = {}

    local function processEntry(entry, parentPrefix, isParentArray)
        local currentPrefix = parentPrefix or ''

        if not isTable(entry) then
            -- Entry is not a table, leave it unchanged
            table.insert(flattened, entry)
            return
        end

        if entry.Name and isParentArray then
            -- Process dictionary only if its parent is an array
            for i, name in ipairs(entry.Name) do
                local columnName = currentPrefix ~= '' and (currentPrefix .. '_' .. name) or name

                local value = entry.Value[i]
                if isTable(value) and value.Name and value.Value then
                    -- Recursively flatten nested dictionaries
                    processEntry(value, columnName, false)
                else
                    if not flattened[columnName] then
                        flattened[columnName] = {}
                        table.insert(columnNames, columnName)
                    end
                    table.insert(flattened[columnName], value)
                end
            end
        elseif isTable(entry) then
            -- Entry is an array, process nested dictionaries
            for _, value in ipairs(entry) do
                processEntry(value, currentPrefix, true)
            end
        else
            -- If neither, leave it unchanged
            table.insert(flattened, entry)
        end
    end

    if nestedTable.Name and nestedTable.Value then
        -- Leave nestedTable unchanged as it is a dictionary
        table.insert(flattened, nestedTable)
    else
        -- Process nestedTable as an array of entries
        for _, entry in ipairs(nestedTable.Value) do
            processEntry(entry, nil, true)
        end
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
        { Name = { 'missCoupon', 'couponBarrier1' }, Value = { 2, { Name = { 'barrierLevel', 'barrierLevelOverhedge' }, Value = { 0.9, 0 } } }},
        { 0.1, { Name = { 'nested1', 'nested2' }, Value = { 0.2, 0.3 } }, 0.4 } -- Example of an array with nested dictionary
    }
}

local schedule_output = flatten(schedule_input)

-- Print the result for verification
io.write('Name = { ')
for _, name in ipairs(schedule_output.Name) do
    io.write("'" .. name .. "', ")
end
io.write('}
')
io.write('Value = {
')
for _, row in ipairs(schedule_output.Value) do
    io.write('  { Value = { ')
    for _, value in ipairs(row.Value) do
        io.write(value .. ', ')
    end
    io.write('} },
')
end
io.write('}
')
