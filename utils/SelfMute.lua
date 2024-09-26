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

local function SetSelfMuteInInstanceCheckButtonState(state)
    local selfMuteInInstanceCheckBox = _G["OPFToggleSelfMuteInInstance"]

    -- if already self-muting and player is in an instance, disable the checkbox to prevent unmuting
    if (OPFData["shouldSelfMuteInInstance"] and IsInInstance()) then
        selfMuteInInstanceCheckBox:Disable()
    else
        -- otherwise set state to enabled to ensure correct state otherwise
        selfMuteInInstanceCheckBox:Enable()
    end

    -- setting down here to make sure state is enabled/disabled first
    selfMuteInInstanceCheckBox:SetChecked(state)
end

local function ToggleSelfMute(shouldVerbose)
    -- prevent self-mute toggling when in an instance, and throw a warning message in the chat
    if (OPFData["shouldSelfMute"] and IsInInstance()) then
        print("ERROR: You cannot remove self-mute in an instance.")
        SetSelfMuteCheckButtonState(true)
        return
    end

    -- save the new state
    OPFData["shouldSelfMute"] = not OPFData["shouldSelfMute"]

    local state = OPFData["shouldSelfMute"]
    SetSelfMuteCheckButtonState(state)

    if (shouldVerbose) then
        print('WARNING: Self Mute is now ' ..
                  (OPFData['shouldSelfMute'] and 'enabled' or 'disabled'))
    end
end

local function ToggleSelfMuteInInstance(shouldVerbose)
    -- prevent self-mute toggling when in an instance, and throw a warning message in the chat
    if (OPFData["shouldSelfMuteInInstance"] and IsInInstance()) then
        print("ERROR: You cannot remove self-mute in an instance.")
        SetSelfMuteInInstanceCheckButtonState(true)
        return
    end

    -- save the new state
    OPFData["shouldSelfMuteInInstance"] =
        not OPFData["shouldSelfMuteInInstance"]

    local state = OPFData["shouldSelfMuteInInstance"]
    SetSelfMuteInInstanceCheckButtonState(state)

    if (shouldVerbose) then
        print('WARNING: Self Mute in Instance is now ' ..
                  (OPFData['shouldSelfMuteInInstance'] and 'enabled' or
                      'disabled'))
    end
end

OPF.ToggleSelfMute = ToggleSelfMute
OPF.ToggleSelfMuteInInstance = ToggleSelfMuteInInstance
OPF.SetSelfMuteCheckButtonState = SetSelfMuteCheckButtonState
OPF.SetSelfMuteInInstanceCheckButtonState =
    SetSelfMuteInInstanceCheckButtonState
