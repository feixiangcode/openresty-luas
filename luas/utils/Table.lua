local Table = {}

function Table.in_array(v, t)
    if type(t) ~= 'table' then
        return false
    end
    local rt = false
    for _, val in pairs(t) do
        if val == v then
            rt = true
            break
        end
    end
    return rt
end

function Table.keys(t)
    local keys = {}
    for k, v in pairs(t) do
        keys[#keys + 1] = k 
    end 
    return keys
end

function Table.values(t)
    local values = {}
    for k, v in pairs(t) do
        values[#values + 1] = v 
    end 
    return values
end

function Table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function Table.map(t, fn)
    local n = {}
    for k, v in pairs(t) do
        n[k] = fn(v, k)
    end
    return n
end

function Table.walk(t, fn)
    for k,v in pairs(t) do
        fn(v, k)
    end
end

function Table.filter(t, fn)
    local n = {}
    for k, v in pairs(t) do
        if fn(v, k) then
            n[k] = v
        end
    end
    return n
end

function Table.length(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end


return Table