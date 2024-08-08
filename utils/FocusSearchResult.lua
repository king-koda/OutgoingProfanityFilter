-- Function to focus the next or previous search result
local function FocusSearchResult(direction)
    local textArea = _G["WordsToReplaceTextArea"]
    local scrollFrame = _G["WordsToReplaceScrollFrame"]

    if #OPF.searchResults == 0 then
        print("No search results found.")
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

    -- end of the search results, reset scroll and cursor
    if (pos.v == nil) then
        textArea:SetCursorPosition(0)
        scrollFrame.ScrollBar:SetValue(0)
        return
    end

    -- Validate the result positions
    if pos.s < 1 or pos.e > #currentText or pos.s > pos.e then
        print("Invalid search result positions.")
        return
    end

    -- Get the font height
    local font, fontHeight, fontWidth, fontFlags = textArea:GetFont()

    -- Set the cursor position to the start of the search result
    textArea:SetCursorPosition(pos.s - 1)

    local lines = textArea:GetHeight() / fontHeight
    local charsPerLine = #currentText / lines
    local currentLine = pos.s / charsPerLine

    local scrollMin, scrollMax = scrollFrame.ScrollBar:GetMinMaxValues()

    -- Scroll to the highlighted text
    local newScroll = ((math.floor(currentLine) - 6.5) / lines) * scrollMax

    scrollFrame.ScrollBar:SetValue(newScroll)
end

OPF.WTR.FocusSearchResult = FocusSearchResult
