local function ResetSavedVariables()
    return {
        wordsToReplaceString = "",
        wordsToReplaceWithOverridesTable = {},
        defaultWordReplacement = "*",
        shouldReplaceByExactWordMatch = false,
        shouldSelfMute = false
    }
end

OPF.ResetSavedVariables = ResetSavedVariables
