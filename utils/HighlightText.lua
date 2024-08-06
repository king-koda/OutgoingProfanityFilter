-- local OutgoingProfanityFilter, OPF = ...
    
-- Function to highlight search results and get their positions
     function OutgoingProfanityFilterHighlightText(text, search)
        OPF.searchResults = {}
        if search == "" then return text end

        local searchPattern = string.gsub(search, "[%^%$%(%)%%%.%[%]%*%+%-%?]",
                                          "%%%1")
        local start = 1

        while true do
            local s, e = string.find(text, searchPattern, start)
            if not s then break end
            table.insert(OPF.searchResults, {s = s, e = e})
            start = e + 1
        end

        local highlightedText = string.gsub(text, searchPattern,
                                            "|cffffd700%1|r")
        return highlightedText
    end

-- OPF["WTR"]["HighlightText"] = HighlightText;