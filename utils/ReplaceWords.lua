local function ReplaceWords(modifiedMessage)
    -- TODO: if not as performant, could consider breaking the message apart and seeing if those words exist in the OPFData["wordsToReplaceString"] 
    -- and only replacing if they do, rather than iterating through the entire OPFData["wordsToReplaceWithOverridesTable"]
    for word, override in pairs(OPFData["wordsToReplaceWithOverridesTable"]) do
        local escapedWord = OPF.EscapeText(word)

        -- do a quick check to see if the word is in the message before doing a replace
        local result = string.find(modifiedMessage, escapedWord)
        if (result ~= nil) then
            -- replace word with a universal override
            modifiedMessage = modifiedMessage:gsub(escapedWord,
                                                   OPFData["defaultWordReplacement"])
        end
    end
    return modifiedMessage
end

OPF.ReplaceWords = ReplaceWords
