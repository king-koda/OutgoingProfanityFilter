local function ToggleShouldReplaceByExactWordMatch()
    OPFData["shouldReplaceByExactWordMatch"] =
        not OPFData["shouldReplaceByExactWordMatch"]
end

OPF.ToggleExactMatching = ToggleShouldReplaceByExactWordMatch
