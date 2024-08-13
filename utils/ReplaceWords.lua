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

local function replaceSubstring(message, startIndex, endIndex, replacement)
    -- Slice the string into three parts
    local before = message:sub(1, startIndex - 1)
    local after = message:sub(endIndex + 1)

    -- Concatenate the parts with the replacement
    message = before .. replacement .. after

    return message
end

local function ReplaceWordsByPartialMatch(message)
    local replacement = OPFData["defaultWordReplacement"]

    for word, replacementOverride in pairs(
                                         OPFData["wordsToReplaceWithOverridesTable"]) do
        local escapedWord = OPF.EscapeText(string.lower(word))

        -- do a quick check to see if the word is in the message before doing a replace
        local wordShouldBeReplaced = string.lower(message):find(escapedWord)

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

            -- tracks which match we are currently replacing
            local currentMatchIndex = 1
            -- loop through all the matches for the word in the message, and replace them one by one using their indexes
            for match in string.gmatch(string.lower(message), escapedWord) do
                local startIndex, endIndex =
                    string.lower(message):find(escapedWord, currentMatchIndex)
                if (startIndex and endIndex) then
                    message = replaceSubstring(message, startIndex, endIndex,
                                               replacement)
                    currentMatchIndex = currentMatchIndex + 1
                end
            end
        end
    end
    return message
end

local function ReplaceWordsByExactMatch(message)
    local words = GetWordsFromMessage(message)
    local replacement = OPFData["defaultWordReplacement"]

    for word in words do
        local escapedMessageWord = OPF.EscapeText(string.lower(word))

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
