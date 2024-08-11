-- Function to update the words to replace UI text area with highlighted text when searching
local function UpdateTextArea()
    local textArea = _G["WordsToReplaceTextArea"]
    local searchLabel = _G["WordsToReplaceSearchLabel"]
    local searchBox = _G["WordsToReplaceSearchBox"]

    -- re-intialize the global search results table so we remove all previous search results
    OPF.searchResults = {}
    -- reset the index if something new is being typed into search box or we will lost track
    OPF.currentIndex = 0

    local searchResults = searchBox:GetText() or ""

    -- if there is something typed in the search box, highlight the text
    if searchResults ~= "" then
        local updatedTextWithHighlights = OPF.WTR.HighlightText(searchResults)
        if (updatedTextWithHighlights ~= nil) then
            textArea:SetText(updatedTextWithHighlights)
        end

        searchLabel:Hide()
    else
        searchLabel:Show()
    end
end

OPF.WTR.UpdateTextArea = UpdateTextArea
