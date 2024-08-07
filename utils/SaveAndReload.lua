-- function for saving and reloading the addon after inserting new words to replace
function OutgoingProfanityFilterSaveAndReload()
    local textArea = _G["OPFConfigWordsToReplaceTextArea"]
    -- table to track if value in parsed string has already been encountered
    local seen = {}

    local text = textArea:GetText()
    -- Remove newlines
    text = string.gsub(text, "\n", "")
    -- Remove spaces
    text = string.gsub(text, "%s", "")

    local wordsToReplaceTable = {}
    for value in string.gmatch(text, "([^,]+)") do
        if not seen[value] then
            table.insert(wordsToReplaceTable, value)
            seen[value] = true
        end
    end

    OPFData["wordsToReplaceTable"] = wordsToReplaceTable
    OPFData["wordsToReplaceString"] = table.concat(wordsToReplaceTable, ",")

    ReloadUI()
end
