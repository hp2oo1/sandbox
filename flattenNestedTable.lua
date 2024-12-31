function convert_list_to_dict(input)
    local result = { Name = {}, Value = {} }

    -- Initialize result Name
    for _, dict in ipairs(input.Value) do
        result.Name = dict.Name
        break
    end

    -- Initialize Value as list of lists
    for i = 1, #result.Name do
        result.Value[i] = { Value = {}}
    end

    -- Populate result with combined values
    for _, dict in ipairs(input.Value) do
        for i, v in ipairs(dict.Value) do
            table.insert(result.Value[i].Value, v)
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
