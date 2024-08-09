local function GetWordsFromMessage(message)
    -- replace all spaces with commas
    local filteredMessage = string.gsub(message, "[%s]", ",")

    -- replace square brackets, parentheses, and curly braces with nothing to get the word inside
    filteredMessage = string.gsub(filteredMessage, "%[(%a+)%]", "%1")
    filteredMessage = string.gsub(filteredMessage, "%((%a+)%)", "%1")
    filteredMessage = string.gsub(filteredMessage, "%{(%a+)%}", "%1")

    -- replace all question marks, exclamation marks and fullstops at the end of words with commas 
    filteredMessage = string.gsub(filteredMessage, "(%a+)([?!.])", "%1,")

    -- get list of words separated via comma
    local wordsFromFilteredMessage = string.gmatch(filteredMessage, "([^,]+)")
    return wordsFromFilteredMessage
end

local function ReplaceWords(modifiedMessage)
    local words = GetWordsFromMessage(modifiedMessage)

    for word in words do
        local escapedWord = OPF.EscapeText(word)

        -- if the word is listed in the table of words to replace, replace it
        local wordShouldBeReplaced =
            OPFData["wordsToReplaceWithOverridesTable"][word] ~= nil

        if (wordShouldBeReplaced) then
            local replacement = OPFData["defaultWordReplacement"]
            local override = OPFData["wordsToReplaceWithOverridesTable"][word]
            if (override == " ") then
                replacement = ""
            elseif (override ~= OPF.NIL) then
                replacement = OPFData["wordsToReplaceWithOverridesTable"][word]
            end

            if (OPFData["shouldReplaceByExactWordMatch"]) then
                local isNonSpecial = escapedWord:match("^[%w_]+$") ~= nil
                if (isNonSpecial) then
                    -- treat words differently to match on the whole word rather than just partial
                    escapedWord = "%f[%a]" .. escapedWord .. "%f[%A]"
                end
            end

            modifiedMessage = modifiedMessage:gsub(escapedWord, replacement)
        end
    end
    return modifiedMessage
end

OPF.ReplaceWords = ReplaceWords
