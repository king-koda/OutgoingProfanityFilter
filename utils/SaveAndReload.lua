-- function for saving and reloading the addon after inserting new words to replace
local function WordsToReplaceSaveAndReload()
    local textArea = _G["WordsToReplaceTextArea"]
    -- table to track if value in parsed string has already been encountered
    local seen = {}

    local text = textArea:GetText()
    -- Remove newlines
    text = string.gsub(text, "\n", "")
    -- Remove spaces
    text = string.gsub(text, "%s", "")

    -- text = OPF.EscapeText(text)

    if (text == "") then
        OPFData["wordsToReplaceWithOverridesTable"] = {}
        OPFData["wordsToReplaceString"] = ""
        ReloadUI()
    end

    local wordsToReplaceTable = {}
    for word in string.gmatch(text, "([^,]+)") do
        -- if seen already, skip
        if not (seen[word]) then
            table.insert(wordsToReplaceTable, word)

            -- if the word is not already in the overrides table, add it with a nil value
            if (OPFData["wordsToReplaceWithOverridesTable"][word] == nil) then
                OPFData["wordsToReplaceWithOverridesTable"][word] = OPF.NIL
            end

            seen[word] = true
        end
    end

    OPFData["wordsToReplaceString"] = table.concat(wordsToReplaceTable, ",")

    ReloadUI()
end

-- function for saving and reloading the addon after inserting the default word replacement
local function DefaultWordReplacementSaveAndReload()
    local textArea = _G["DefaultWordReplacementTextArea"]

    local text = textArea:GetText()

    -- Remove newlines
    text = string.gsub(text, "\n", "")

    OPFData["defaultWordReplacement"] = text

    ReloadUI()
end

-- function for saving and reloading the addon after inserting the word replacement overrides
local function WordReplacementOverridesSaveAndReload()
    local wordReplacementOverridesContent =
        _G["WordReplacementOverridesContent"]
    local wordReplacementOverridesLines =
        wordReplacementOverridesContent:GetNumChildren();

    for i = 1, wordReplacementOverridesLines do

        local word =
            _G["WordReplacementOverridesLine" .. i .. "NonEditable"]:GetText()
        local override =
            _G["WordReplacementOverridesLine" .. i .. "Editable"]:GetText()

        -- set empty string overrides back to nil
        if (override == "") then override = OPF.NIL end

        OPFData.wordsToReplaceWithOverridesTable[word] = override
    end

    ReloadUI()
end

OPF.WTR.SaveAndReload = WordsToReplaceSaveAndReload
OPF.DWR.SaveAndReload = DefaultWordReplacementSaveAndReload
OPF.WRO.SaveAndReload = WordReplacementOverridesSaveAndReload
