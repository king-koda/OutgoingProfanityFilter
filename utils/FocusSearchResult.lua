-- local OutgoingProfanityFilter, OPF = ...

-- TODO: need to pass in currentIndex and track it externally so that it gets persisted across changes
-- Function to focus the next or previous search result
 function OutgoingProfanityFilterFocusSearchResult(direction)
    local textArea = _G["OPFConfigWordsToReplaceTextArea"]
    local scrollFrame = _G["OPFConfigWordsToReplaceScrollFrame"]

    if #OPF.searchResults == 0 then
        print("No search results found")
        return
    end

    OPF.currentIndex = OPF.currentIndex + direction
    if OPF.currentIndex > #OPF.searchResults then
        OPF.currentIndex = 1
    elseif OPF.currentIndex < 1 then
        OPF.currentIndex = #OPF.searchResults
    end

    local pos = OPF.searchResults[OPF.currentIndex]
    textArea:HighlightText(pos.s - 1, pos.e) -- Highlight text
    textArea:SetCursorPosition(pos.s - 1) -- Set cursor position
    textArea:SetFocus()

    -- Scroll to the highlighted text
    local scrollMin, scrollMax = scrollFrame.ScrollBar:GetMinMaxValues()
    local newScroll = (pos.s - 1) / #textArea:GetText() * scrollMax
    scrollFrame.ScrollBar:SetValue(newScroll)
end

-- OPF["WTR"]["FocusSearchResult"] = FocusSearchResult;