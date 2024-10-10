local function InitializeNewSavedVariables()
    if (OPFData["wordsToReplaceString"] == nil) then
        OPFData["wordsToReplaceString"] = ""
    end
    if (OPFData["wordsToReplaceWithOverridesTable"] == nil) then
        OPFData["wordsToReplaceWithOverridesTable"] = {}
    end
    if (OPFData["defaultWordReplacement"] == nil) then
        OPFData["defaultWordReplacement"] = "*"
    end
    if (OPFData["shouldReplaceByExactWordMatch"] == nil) then
        OPFData["shouldReplaceByExactWordMatch"] = false
    end
    if (OPFData["shouldSelfMute"] == nil) then
        OPFData["shouldSelfMute"] = false
    end
    if (OPFData["allowedWordsWhileMutedString"] == nil) then
        OPFData["allowedWordsWhileMutedString"] = ""
    end
    if (OPFData["allowedWordsWhileMutedTable"] == nil) then
        OPFData["allowedWordsWhileMutedTable"] = {}
    end
    if (OPFData["allowedChannelsWhileMuted"] == nil) then
        OPFData["allowedChannelsWhileMuted"] = {
            GUILD = false,
            OFFICER = false,
            PARTY = false,
            PARTY_LEADER = false,
            WHISPER = false,
            BN_WHISPER = false,
            SAY = false,
            YELL = false
        }
    end
end

OPF.InitializeNewSavedVariables = InitializeNewSavedVariables
