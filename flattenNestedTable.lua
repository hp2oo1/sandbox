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
        table.insert(output.Value, flattened[name])
    end

    return output
end
