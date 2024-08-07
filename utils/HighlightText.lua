-- Function to highlight search results and get their positions
function OutgoingProfanityFilterHighlightText(text, search)
    OPF.searchResults = {}
    if search == "" then return "" end

    local searchPattern = string.gsub(string.lower(search),
                                      "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
    local start = 1

    while true do
        local s, e = string.find(text, searchPattern, start)
        if not s then break end
        local value = string.sub(text, s, e)
        table.insert(OPF.searchResults, {s = s, e = e, v = value})
        start = e + 1
    end

    -- add nil value to symbolise the end of the results for resetting the scrolling index
    table.insert(OPF.searchResults, {s = 0, e = 0, v = nil})

    local highlightedText = string.gsub(text, searchPattern, "|cff0000ff%1|r")
    return highlightedText
end
