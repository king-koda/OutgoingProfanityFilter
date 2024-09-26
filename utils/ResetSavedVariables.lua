local function ResetSavedVariables()
    return {
        wordsToReplaceString = "",
        wordsToReplaceWithOverridesTable = {},
        defaultWordReplacement = "*",
        shouldReplaceByExactWordMatch = false,
        shouldSelfMute = false,
        shouldSelfMuteInInstance = false
    }
end

OPF.ResetSavedVariables = ResetSavedVariables
