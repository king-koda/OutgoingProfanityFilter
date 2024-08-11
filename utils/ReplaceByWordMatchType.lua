local function ToggleMatchingType()
    -- save the new state
    OPFData["shouldReplaceByExactWordMatch"] =
        not OPFData["shouldReplaceByExactWordMatch"]

    -- set the new button states
    OPF.SetReplaceByMatchCheckButtonStates()
end

local function SetReplaceByMatchCheckButtonStates()
    local partialMatchCheckBox = _G["OPFToggleExactMatchCheckBox"]
    local exactMatchCheckBox = _G["OPFTogglePartialMatchCheckBox"]
    local state = OPF.GetShouldReplaceByExactMatchButtonState()

    -- if partial matching is enabled, disable exact matching and vice versa
    if (state == false) then
        partialMatchCheckBox:SetChecked(true)
        exactMatchCheckBox:SetChecked(false)
    else
        partialMatchCheckBox:SetChecked(false)
        exactMatchCheckBox:SetChecked(true)
    end
end

local function GetShouldReplaceByExactMatchButtonState()
    if (OPFData["shouldReplaceByExactWordMatch"] ~= nil) then
        return OPFData["shouldReplaceByExactWordMatch"]
    end

    -- if the value is nil for some reason, set it to false
    OPFData["shouldReplaceByExactWordMatch"] = false
    return false
end

OPF.ToggleMatchingType = ToggleMatchingType
OPF.GetShouldReplaceByExactMatchButtonState =
    GetShouldReplaceByExactMatchButtonState
OPF.SetReplaceByMatchCheckButtonStates = SetReplaceByMatchCheckButtonStates
