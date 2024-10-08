-- Function to highlight search results and get their positions
local function HighlightText(searchResults, feature)
    local text
    if feature == "WTR" then
        text = OPFData["wordsToReplaceString"] or ""
    elseif feature == "SMO" then
        text = OPFData["allowedWordsWhileMutedString"] or ""
    else
        print("Invalid feature specified to Highlight Text.")
        return
    end

    -- exit early if there is no words to replace configured
    if (text == "") then return nil end

    -- TODO: escape search results ?? possibly not, can allow people to use regex ?

    -- TODO: improve below
    local searchPattern = string.gsub(string.lower(searchResults),
                                      "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
    local start = 1

    -- TODO: escape text ??

    -- TODO: fix this bad code
    while true do
        local s, e = string.find(text, searchPattern, start)
        if not s then break end
        local value = string.sub(text, s, e)
        table.insert(OPF[feature].searchResults, {s = s, e = e, v = value})
        start = e + 1
    end

    -- add nil value to symbolise the end of the results for resetting the scrolling index
    table.insert(OPF[feature].searchResults, {s = 0, e = 0, v = nil})

    -- highlight the search results in blue 
    local highlightedText = string.gsub(text, searchPattern, "|cff0000ff%1|r")

    return highlightedText
end

OPF.HighlightText = HighlightText
