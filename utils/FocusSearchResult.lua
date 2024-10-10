-- Function to focus the next or previous search result
local function FocusSearchResult(direction, feature)
    local textArea, scrollFrame
    if feature == "WTR" then
        textArea = _G["WordsToReplaceTextArea"]
        scrollFrame = _G["WordsToReplaceScrollFrame"]
    elseif feature == "SMO" then
        textArea = _G["SelfMuteOptionsTextArea"]
        scrollFrame = _G["SelfMuteOptionsScrollFrame"]
    else
        print("Invalid feature specified to Focus Search Result.")
        return
    end

    if #OPF[feature].searchResults == 0 then
        print("No search results found.")
        return
    end

    -- Update the current index based on the direction
    OPF[feature].currentIndex = OPF[feature].currentIndex + direction
    if OPF[feature].currentIndex > #OPF[feature].searchResults then
        OPF[feature].currentIndex = 1
    elseif OPF[feature].currentIndex < 1 then
        OPF[feature].currentIndex = #OPF[feature].searchResults
    end

    local pos = OPF[feature].searchResults[OPF[feature].currentIndex]
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

OPF.FocusSearchResult = FocusSearchResult
