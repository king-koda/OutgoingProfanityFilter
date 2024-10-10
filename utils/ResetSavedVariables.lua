local function ResetSavedVariables()
    return {
        wordsToReplaceString = "",
        wordsToReplaceWithOverridesTable = {},
        defaultWordReplacement = "*",
        shouldReplaceByExactWordMatch = false,
        shouldSelfMute = false,
        allowedWordsWhileMutedString = "",
        allowedWordsWhileMutedTable = {},
        allowedChannelsWhileMuted = {
            GUILD = false,
            OFFICER = false,
            PARTY = false,
            PARTY_LEADER = false,
            WHISPER = false,
            BN_WHISPER = false,
            SAY = false,
            YELL = false
        }
    }
end

OPF.ResetSavedVariables = ResetSavedVariables
