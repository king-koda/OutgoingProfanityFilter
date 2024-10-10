-- function for saving and reloading the addon after inserting new words to replace
local function WordsToReplaceSave()
    local textArea = _G["WordsToReplaceTextArea"]

    local text = OPF.SanitizeString(textArea)

    if (text == "") then
        OPFData["wordsToReplaceWithOverridesTable"] = {}
        OPFData["wordsToReplaceString"] = ""
    end

    -- removes words that are no longer in the text area
    OPF.PruneExistingTable(text, OPFData["wordsToReplaceWithOverridesTable"])

    local function OnMatch(word)
        -- if the word is not already in the overrides table, add it with a nil value
        if (OPFData["wordsToReplaceWithOverridesTable"][word] == nil) then
            OPFData["wordsToReplaceWithOverridesTable"][word] = OPF.NIL
        end
    end

    local newTable = OPF.StringToArrayWithDedupe(text, OnMatch)

    OPFData["wordsToReplaceString"] = table.concat(newTable, ",")
end

-- function for saving and reloading the addon after inserting the allowed words while muted
local function SelfMuteOptionsSave()
    local textArea = _G["SelfMuteOptionsTextArea"]

    local text = OPF.SanitizeString(textArea)

    if (text == "") then
        OPFData["allowedWordsWhileMutedTable"] = {}
        OPFData["allowedWordsWhileMutedString"] = ""
    end

    -- removes words that are no longer in the text area
    OPF.PruneExistingTable(text, OPFData["allowedWordsWhileMutedTable"])

    local function OnMatch(word)
        -- if the word is not already in the overrides table, add it with a nil value
        if (OPFData["allowedWordsWhileMutedTable"][word] == nil) then
            OPFData["allowedWordsWhileMutedTable"][word] = OPF.NIL
        end
    end

    local newTable = OPF.StringToArrayWithDedupe(text, OnMatch)

    OPFData["allowedWordsWhileMutedString"] = table.concat(newTable, ",")
end

-- function for saving and reloading the addon after inserting the default word replacement
local function DefaultWordReplacementSave()
    local textArea = _G["DefaultWordReplacementTextArea"]

    local text = textArea:GetText()

    -- Remove newlines
    text = string.gsub(text, "\n", "")

    OPFData["defaultWordReplacement"] = text
end

-- function for saving and reloading the addon after inserting the word replacement overrides
local function WordReplacementOverridesSave()
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
end

OPF.WTR.Save = WordsToReplaceSave
OPF.DWR.Save = DefaultWordReplacementSave
OPF.WRO.Save = WordReplacementOverridesSave
OPF.SMO.Save = SelfMuteOptionsSave
