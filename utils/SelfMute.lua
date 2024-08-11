local function SetSelfMuteCheckButtonState(state)
    local selfMuteCheckBox = _G["OPFToggleSelfMute"]

    -- if already self-muting and player is in an instance, disable the checkbox to prevent unmuting
    if (OPFData["shouldSelfMute"] and IsInInstance()) then
        selfMuteCheckBox:Disable()
    else
        -- otherwise set state to enabled to ensure correct state otherwise
        selfMuteCheckBox:Enable()
    end

    -- setting down here to make sure state is enabled/disabled first
    selfMuteCheckBox:SetChecked(state)
end

local function ToggleSelfMute()
    -- prevent self-mute toggling when in an instance, and throw a warning message in the chat
    if (OPFData["shouldSelfMute"] and IsInInstance()) then
        print("WARNING: You cannot remove self-mute in an instance.")
        SetSelfMuteCheckButtonState(true)
        return
    end

    -- save the new state
    OPFData["shouldSelfMute"] = not OPFData["shouldSelfMute"]

    local state = OPFData["shouldSelfMute"]
    SetSelfMuteCheckButtonState(state)
end

OPF.ToggleSelfMute = ToggleSelfMute
OPF.SetSelfMuteCheckButtonState = SetSelfMuteCheckButtonState
