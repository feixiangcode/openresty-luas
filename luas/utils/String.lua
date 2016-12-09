local String = {}

local _TRIM_CHARS = " \t\n\r"

function String.ltrim(input, chars)
    chars = chars or _TRIM_CHARS
    local pattern = "^[" .. chars .. "]+"
    return string_gsub(input, pattern, "") 
end

function String.rtrim(input, chars)
    chars = chars or _TRIM_CHARS
    local pattern = "[" .. chars .. "]+$"
    return string_gsub(input, pattern, "") 
end

function String.trim(input, chars)
    chars = chars or _TRIM_CHARS
    local pattern = "^[" .. chars .. "]+"
    input = string_gsub(input, pattern, "") 
    pattern = "[" .. chars .. "]+$"
    return string_gsub(input, pattern, "") 
end


function String.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter == "") then return false end 
    local pos,arr = 1, {}
    for st, sp in function() return string.find(input, delimiter, pos, true) end do
        local str = string.sub(input, pos, st - 1)
        if str ~= "" then
            table.insert(arr, str)
        end 
        pos = sp + 1 
    end 
    if pos <= string.len(input) then
        table.insert(arr, string.sub(input, pos))
    end 
    return arr
end

return String