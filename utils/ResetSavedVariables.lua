local function ResetSavedVariables()
    return {
        wordsToReplaceString = "",
        wordsToReplaceWithOverridesTable = {},
        defaultWordReplacement = "*"
    }
end

OPF.ResetSavedVariables = ResetSavedVariables
