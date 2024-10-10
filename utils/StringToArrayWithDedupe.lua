local function StringToArrayWithDedupe(text, OnMatch)
    local newTable = {}
    local newWords = string.gmatch(text, "([^,]+)")
    -- table to track if value in parsed string has already been encountered
    local seen = {}
    for word in newWords do
        -- if seen already, skip
        if not (seen[word]) then
            table.insert(newTable, word)
            if (OnMatch) then OnMatch(word) end
            seen[word] = true
        end
    end

    return newTable
end

OPF.StringToArrayWithDedupe = StringToArrayWithDedupe
