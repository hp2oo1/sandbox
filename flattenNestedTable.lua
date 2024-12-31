function convert_list_to_dict(input)
    local result = {}
    
    -- Initialize result with empty tables for each key
    for _, dict in ipairs(input.Value) do
        for key, value in pairs(dict) do
            if result[key] == nil then
                if type(value[1]) == 'table' then
                    result[key] = {}
                    for i = 1, #value do
                        result[key][i] = {}
                    end
                else
                    result[key] = value
                end
            end
        end
        break
    end

    -- Populate result with combined values
    for _, dict in ipairs(input.Value) do
        for key, value in pairs(dict) do
            if type(value[1]) == 'table' then
                for i = 1, #value do
                    table.insert(result[key][i], value[i])
                end
            end
        end
    end

    return result
end

-- Sample input
A = {
    Value = {
        {Name = {'n1', 'n2'}, Value = {'v1', 'v2'}},
        {Name = {'n1', 'n2'}, Value = {'v3', 'v4'}}
    }
}

-- Convert
A = convert_list_to_dict(A)

-- Print result
for k, v in pairs(A) do
    io.write(k .. ' = ')
    if type(v[1]) == 'table' then
        io.write('{')
        for i, sublist in ipairs(v) do
            io.write('{')
            io.write(table.concat(sublist, ', '))
            io.write('}')
            if i < #v then io.write(', ') end
        end
        io.write('}')
    else
        io.write('{' .. table.concat(v, ', ') .. '}')
    end
    io.write('\n')
end
