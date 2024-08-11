local function ToggleShouldReplaceByExactWordMatch()
    if(OPFData["shouldReplaceByExactWordMatch"] ~= nil) then
        OPFData["shouldReplaceByExactWordMatch"] =
            not OPFData["shouldReplaceByExactWordMatch"]
    end
end

-- local function GetExactMatchButtonState()
--     if(OPFData["shouldReplaceByExactWordMatch"] ~= nil) then
--         return OPFData["shouldReplaceByExactWordMatch"]
--     end
--     return false
-- end

OPF.ToggleExactMatching = ToggleShouldReplaceByExactWordMatch
--OPF.GetExactMatchButtonState = GetExactMatchButtonState
