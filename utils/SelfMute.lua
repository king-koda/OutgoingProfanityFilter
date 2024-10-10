local function SetSelfMuteCheckButtonState(state)
    local selfMuteCheckBox = _G["OPFToggleSelfMute"]
    -- setting down here to make sure state is enabled/disabled first
    selfMuteCheckBox:SetChecked(state)
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

local function IsChannelAllowed(channel)
    return OPFData["allowedChannelsWhileMuted"][channel]
end

local function ToggleChannelState(channel)
    if (OPFData["shouldSelfMute"] and IsInInstance()) then
        print(
            "ERROR: You cannot change self mute options in an instance with self mute enabled.")
        return OPFData["allowedChannelsWhileMuted"][channel]
    end

    if (OPFData["allowedChannelsWhileMuted"][channel] ~= nil) then
        OPFData["allowedChannelsWhileMuted"][channel] =
            not OPFData["allowedChannelsWhileMuted"][channel]
        return OPFData["allowedChannelsWhileMuted"][channel]
    end
end

OPF.ToggleSelfMute = ToggleSelfMute
OPF.SetSelfMuteCheckButtonState = SetSelfMuteCheckButtonState
OPF.IsChannelAllowed = IsChannelAllowed
OPF.ToggleChannelState = ToggleChannelState
