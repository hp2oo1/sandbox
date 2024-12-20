function flattenToOutput(nestedTable)
    local flattened = {}
    local columnNames = {}

    local function recurse(currentTable, prefix, row)
        for key, value in pairs(currentTable) do
            local newKey = prefix and (prefix .. "_" .. key) or key

            if type(value) == "table" then
                recurse(value, newKey, row)
            else
                if not flattened[newKey] then
                    flattened[newKey] = {}
                    table.insert(columnNames, newKey)
                end
                flattened[newKey][row] = value
            end
        end
    end

    for i, entry in ipairs(nestedTable) do
        recurse(entry, nil, i) -- Start flattening each entry in the array
    end

    local output = { Name = columnNames, Value = {} }
    local rowCount = #nestedTable

    for i = 1, rowCount do
        local row = {}
        for _, name in ipairs(columnNames) do
            table.insert(row, flattened[name][i])
        end
        table.insert(output.Value, row)
    end

    return output
end
