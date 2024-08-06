-- Function to update the text area with highlighted text when searching
function OutgoingProfanityFilterUpdateTextArea()
    local textArea = _G["OPFConfigWordsToReplaceTextArea"]
    local searchLabel = _G["OPFConfigFrameWordsToReplaceSearchLabel"]
    local searchBox = _G["OPFConfigWordsToReplaceSearchBox"]

    local wordsToReplaceString = OPFData["wordsToReplaceString"] or ""
    local search = searchBox:GetText() or ""

    if (wordsToReplaceString ~= "") then
        local updatedTextWithHighlights =
            OutgoingProfanityFilterHighlightText(wordsToReplaceString, search)
        if (updatedTextWithHighlights ~= "") then
            textArea:SetText(updatedTextWithHighlights)
        end
    end

    if search ~= "" then
        searchLabel:Hide()
    else
        searchLabel:Show()
    end
end
