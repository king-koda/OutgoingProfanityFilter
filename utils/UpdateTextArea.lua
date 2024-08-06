-- local OutgoingProfanityFilter, OPF = ...
-- Function to update the text area with highlighted text when searching
function OutgoingProfanityFilterUpdateTextArea()
    local textArea = _G["OPFConfigWordsToReplaceTextArea"]
    local searchLabel = _G["OPFConfigFrameWordsToReplaceSearchLabel"]
    local searchBox = _G["OPFConfigWordsToReplaceSearchBox"]

    local wordsToReplaceString = OPFData["wordsToReplaceString"] or ""
    local search = searchBox:GetText() or ""

    if (wordsToReplaceString ~= "") then
        local highlightedText = OutgoingProfanityFilterHighlightText(
                                    wordsToReplaceString, search)
        textArea:SetText(highlightedText)
    end

    if search ~= "" then
        searchLabel:Hide()
    else
        searchLabel:Show()
    end
end

-- OPF["WTR"]["UpdateTextArea"] = UpdateTextArea;
