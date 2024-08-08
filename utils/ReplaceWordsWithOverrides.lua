local function ReplaceWordsWithOverrides(modifiedMessage)
    for word, override in pairs(OPFData["wordsToReplaceWithOverridesTable"]) do
        if (override ~= OPF.NIL) then
            local escapedWord = OPF.EscapeText(word)

            -- treat a space as an empty string
            if (override == " ") then override = "" end

            -- replace word with a unique override
            modifiedMessage = modifiedMessage:gsub(escapedWord, override)
        end
    end

    return modifiedMessage
end

OPF.ReplaceWordsWithOverrides = ReplaceWordsWithOverrides
