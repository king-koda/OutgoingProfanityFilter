-- Function to update the words to replace UI text area with highlighted text when searching
local function UpdateTextArea(feature)
    local textArea, searchBox
    if feature == "WTR" then
        textArea = _G["WordsToReplaceTextArea"]
        searchBox = _G["WordsToReplaceSearchBox"]
    elseif feature == "SMO" then
        textArea = _G["SelfMuteOptionsTextArea"]
        searchBox = _G["SelfMuteOptionsSearchBox"]
    end

    -- re-intialize the global search results table so we remove all previous search results
    OPF[feature].searchResults = {}
    -- reset the index if something new is being typed into search box or we will lost track
    OPF[feature].currentIndex = 0

    local searchResults = searchBox:GetText() or ""

    -- if there is something typed in the search box, highlight the text
    if searchResults ~= "" then
        local updatedTextWithHighlights =
            OPF.HighlightText(searchResults, feature)
        if (updatedTextWithHighlights ~= nil) then
            textArea:SetText(updatedTextWithHighlights)
        end
    else
        textArea:SetText(OPF.SanitizeString(textArea))
    end
end

OPF.UpdateTextArea = UpdateTextArea
