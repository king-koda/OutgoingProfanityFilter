-- function for saving and reloading the addon after inserting new words to replace
function OutgoingProfanityFilterSaveAndReload()
    local textArea = _G["OPFConfigWordsToReplaceTextArea"]
    local editorFrame = _G["OPFConfigFrame"]

    local text = textArea:GetText()
    -- Remove newlines
    text = string.gsub(text, "\n", "")
    -- Remove spaces
    text = string.gsub(text, "%s", "")

    local wordsToReplaceTable = {}
    for value in string.gmatch(text, "([^,]+)") do
        table.insert(wordsToReplaceTable, value)
    end

    OPFData["wordsToReplaceTable"] = wordsToReplaceTable
    OPFData["wordsToReplaceString"] = text

    editorFrame:Hide()
    print("Text saved!")
    ReloadUI()
end
