-- function for saving and reloading the addon after inserting new words to replace
function WordsToReplaceSaveAndReload()
    local textArea = _G["WordsToReplaceTextArea"]
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

-- function for saving and reloading the addon after inserting the default word replacement
function DefaultWordReplacementSaveAndReload()
    local textArea = _G["DefaultWordReplacementTextArea"]

    local text = textArea:GetText()

    -- Remove newlines
    text = string.gsub(text, "\n", "")

    OPFData["defaultWordReplacementString"] = text

    ReloadUI()
end

-- function for saving and reloading the addon after inserting the word replacement overrides
function WordReplacementOverridesSaveAndReload()
    local wordReplacementOverridesContent =
        _G["WordReplacementOverridesContent"]
    local wordReplacementOverridesLines =
        wordReplacementOverridesContent:GetNumChildren();

    for i = 1, wordReplacementOverridesLines do

        local index =
            _G["WordReplacementOverridesLine" .. i .. "NonEditable"]:GetText()
        local value =
            _G["WordReplacementOverridesLine" .. i .. "Editable"]:GetText()
        OPFData.wordReplacementOverrides[index] = value
    end

    ReloadUI()
end
