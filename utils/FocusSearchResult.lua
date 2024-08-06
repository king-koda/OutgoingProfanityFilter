-- Function to focus the next or previous search result
function OutgoingProfanityFilterFocusSearchResult(direction)
    local textArea = _G["OPFConfigWordsToReplaceTextArea"]
    local scrollFrame = _G["OPFConfigWordsToReplaceScrollFrame"]

    if #OPF.searchResults == 0 then
        print("No search results found")
        return
    end

    -- Update the current index based on the direction
    OPF.currentIndex = OPF.currentIndex + direction
    if OPF.currentIndex > #OPF.searchResults then
        OPF.currentIndex = 1
    elseif OPF.currentIndex < 1 then
        OPF.currentIndex = #OPF.searchResults
    end

    local pos = OPF.searchResults[OPF.currentIndex]
    local currentText = textArea:GetText()

    -- Validate the result positions
    if pos.s < 1 or pos.e > #currentText or pos.s > pos.e then
        print("Invalid search result positions")
        return
    end

    -- Highlight the search result
    textArea:HighlightText(pos.s - 1, pos.e)
    -- Set the cursor position to the start of the search result
    textArea:SetCursorPosition(pos.s - 1)

    -- Scroll to the highlighted text
    local scrollMin, scrollMax = scrollFrame.ScrollBar:GetMinMaxValues()
    local newScroll = (pos.s - 1) / #currentText * scrollMax
    scrollFrame.ScrollBar:SetValue(newScroll)
end
