local function ResetSavedVariables()
    return {
        wordsToReplaceString = "",
        wordsToReplaceWithOverridesTable = {},
        defaultWordReplacement = "*",
        shouldReplaceByExactWordMatch = false
    }
end

OPF.ResetSavedVariables = ResetSavedVariables
