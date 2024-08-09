local function ToggleShouldReplaceByExactWordMatch()
    OPFData["shouldReplaceByExactWordMatch"] =
        not OPFData["shouldReplaceByExactWordMatch"]
end

local function GetExactMatchButtonState()
    return OPFData["shouldReplaceByExactWordMatch"]
end

OPF.ToggleExactMatching = ToggleShouldReplaceByExactWordMatch
OPF.GetExactMatchButtonState = GetExactMatchButtonState
