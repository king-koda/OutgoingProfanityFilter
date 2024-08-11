local function ToggleMatchingType()
    local partialMatchCheckBox = _G["OPFToggleExactMatchCheckBox"]
    local exactMatchCheckBox = _G["OPFTogglePartialMatchCheckBox"]
    OPFData["shouldReplaceByExactWordMatch"] =
        not OPFData["shouldReplaceByExactWordMatch"]

    OPF.SetCheckButtonStates()
end

local function SetCheckButtonStates()
    local partialMatchCheckBox = _G["OPFToggleExactMatchCheckBox"]
    local exactMatchCheckBox = _G["OPFTogglePartialMatchCheckBox"]
    local state = OPF.GetShouldReplaceByExactMatchButtonState()
    print('state', state)
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
OPF.SetCheckButtonStates = SetCheckButtonStates
