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

local function ReplaceWordsByPartialMatch(message)
    local replacement = OPFData["defaultWordReplacement"]

    for word, replacementOverride in pairs(
                                         OPFData["wordsToReplaceWithOverridesTable"]) do
        local escapedWord = OPF.EscapeText(word)

        -- do a quick check to see if the word is in the message before doing a replace
        local wordShouldBeReplaced = message:find(escapedWord)
        if (wordShouldBeReplaced) then
            -- replacementOverride will never be nil from check above
            -- if the override is a space, then replace with nothing
            if (replacementOverride == " ") then
                replacement = ""
            elseif (replacementOverride == OPF.NIL) then
                -- use default replacement
            else
                -- use the replacement override 
                replacement = OPFData["wordsToReplaceWithOverridesTable"][word]
            end

            -- replace word with a universal override
            message = message:gsub(escapedWord, replacement)
        end
    end
    return message
end

local function ReplaceWordsByExactMatch(message)
    local words = GetWordsFromMessage(message)
    local replacement = OPFData["defaultWordReplacement"]

    for word in words do
        local escapedMessageWord = OPF.EscapeText(word)

        local isNonSpecial = escapedMessageWord:match("^[%w_]+$") ~= nil
        if (isNonSpecial) then
            -- treat words differently to match on the whole word
            escapedMessageWord = "%f[%a]" .. escapedMessageWord .. "%f[%A]"
        end

        -- check if the word in the message exists in the list of words to replace
        local wordShouldBeReplaced =
            OPFData["wordsToReplaceWithOverridesTable"][word] ~= nil

        if (wordShouldBeReplaced) then
            local replacementOverride =
                OPFData["wordsToReplaceWithOverridesTable"][word]

            -- replacementOverride will never be nil from check above
            if (replacementOverride == " ") then
                replacement = ""
            elseif (replacementOverride ~= OPF.NIL) then
                -- if the override is OPF.NIL, then use the default replacement, otherwise use the override
                replacement = OPFData["wordsToReplaceWithOverridesTable"][word]
            end

            message = message:gsub(escapedMessageWord, replacement)
        end

    end
    return message
end

local function ReplaceWords(modifiedMessage)
    if (OPFData["shouldSelfMute"]) then return "" end

    if (OPFData["shouldReplaceByExactWordMatch"]) then
        modifiedMessage = ReplaceWordsByExactMatch(modifiedMessage)
    else
        modifiedMessage = ReplaceWordsByPartialMatch(modifiedMessage)
    end

    return modifiedMessage
end

OPF.ReplaceWords = ReplaceWords
OPF.GetWordsFromMessage = GetWordsFromMessage
