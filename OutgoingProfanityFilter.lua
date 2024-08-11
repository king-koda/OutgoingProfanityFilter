local OutgoingProfanityFilter, NS = ...

local function InitializeAddon()
    UIPanelWindows["OPFConfigFrame"] = {area = "center", whileDead = true}
    UIPanelWindows["WordsToReplaceUI"] = {area = "center", whileDead = true}
    UIPanelWindows["DefaultWordReplacementUI"] = {
        area = "center",
        whileDead = true
    }
    UIPanelWindows["WordReplacementOverridesUI"] = {
        area = "center",
        whileDead = true
    }

    StaticPopupDialogs["CONFIRM_OPF_RESET"] = {
        text = "Are you sure you want to reset all the addons settings to defaults?",
        button1 = "YES",
        button2 = "NO",
        OnAccept = function() OPFData = OPF.ResetSavedVariables() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        area = "center"
    }

    StaticPopupDialogs["CONFIRM_SELF_MUTE"] = {
        text = "Are you sure you want to self-mute? This option can not be disabled whilst in an instance (for the sake of self-preservation)",
        button1 = "YES",
        button2 = "NO",
        OnAccept = function()
            -- proceed with toggling on warning acceptance
            OPF.ToggleSelfMute()
        end,
        OnCancel = function()
            -- reset button state on cancel
            OPF.SetSelfMuteCheckButtonState(OPFData["shouldSelfMute"])
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        area = "center"
    }

    -- Initialize saved variables
    OPFData = OPFData or OPF.ResetSavedVariables()

    local OPFConfigFrame = _G["OPFConfigFrame"]

    -- preserve reference to original function
    -- local _ShowUIPanel = ShowUIPanel;
    -- TODO: come back to this later, as it's not working causing blizz ui red flags
    -- function ShowUIPanel(frame, ...)
    --     local frameName = frame:GetName()
    --     -- override the OnHide script for WordsToReplaceUI to show the OPFConfigFrame, 
    --     -- to allow escape to navigate backwards, as well as close the UI entirely when on OPFConfigFrame
    --     if (frameName == "WordsToReplaceUI" or frameName ==
    --         "DefaultWordReplacementUI" or frameName ==
    --         "WordReplacementOverridesUI") then
    --         _ShowUIPanel(frame, ...)
    --         frame:SetScript("OnHide",
    --                         function() _ShowUIPanel(OPFConfigFrame) end)
    --     else
    --         _ShowUIPanel(frame, ...)
    --     end
    -- end

    -- preserve reference to original function
    local _SendChatMessage = SendChatMessage;

    -- override the original function
    function SendChatMessage(message, ...)
        -- set message to lowercase for easier comparison, and disallow bypassing via capitalization
        local modifiedMessage = string.lower(message)

        if (pcall(function()
            modifiedMessage = OPF.ReplaceWords(modifiedMessage)
        end)) then
            _SendChatMessage(modifiedMessage, ...)
        else
            print(
                'ERROR: Outgoing Profanity Filter had an issue replacing the words in the previous sentence, please report this to the addon author on GitHub with your list of words or the culprit word, and the sentence it failed on.')
            _SendChatMessage(message, ...)
        end
    end

    -- Function to show the main frame
    local function ShowConfigFrame()
        -- set checkbox states on UI open
        OPF.SetReplaceByMatchCheckButtonStates()
        OPF.SetSelfMuteCheckButtonState(OPFData["shouldSelfMute"])
        ShowUIPanel(OPFConfigFrame)
    end

    -- Functions to show the individual frames
    local function ShowWordsToReplaceUI()
        local ui = _G["WordsToReplaceUI"]
        local textArea = _G["WordsToReplaceTextArea"]
        local scrollFrame = _G["WordsToReplaceScrollFrame"]
        -- populate the text area with the current OPFData["wordsToReplaceString"]
        textArea:SetText(OPFData["wordsToReplaceString"] or "")
        textArea:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tileSize = 400,
            insets = {left = -10, right = -10, top = -10, bottom = -400}
        })

        -- reset scrollbar position when opening words to replace UI
        scrollFrame.ScrollBar:SetValue(0)

        ShowUIPanel(ui)
    end

    local function ShowDefaultWordReplacementUI()
        local ui = _G["DefaultWordReplacementUI"]

        local DefaultWordReplacementTextArea =
            _G["DefaultWordReplacementTextArea"]

        DefaultWordReplacementTextArea:SetText(
            OPFData["defaultWordReplacement"] or "")
        ShowUIPanel(ui)
    end

    local function ShowWordReplacementOverridesUI()
        local ui = _G["WordReplacementOverridesUI"]

        OPF.WRO.CreatePaginationButtons()
        OPF.WRO.GetOverrideRowsStartingWithCharacter('a')
        ShowUIPanel(ui)
    end

    -- Register the /opf command
    SLASH_OPF1 = "/opf"
    SlashCmdList["OPF"] = ShowConfigFrame

    -- Register the /opfsm command
    SLASH_OPFSM1 = "/opfsm"
    SlashCmdList["OPFSM"] = function() OPF.ToggleSelfMute(true) end

    -- add necessary functions to OPF global
    OPF.ShowConfigFrame = ShowConfigFrame
    OPF.ShowDefaultWordReplacementUI = ShowDefaultWordReplacementUI
    OPF.ShowWordsToReplaceUI = ShowWordsToReplaceUI
    OPF.ShowWordReplacementOverridesUI = ShowWordReplacementOverridesUI
end

-- Create a frame to handle events
local eventFrame = CreateFrame("Frame")

-- Register the ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")

-- Event handler function
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "OutgoingProfanityFilter" then
        -- Unregister the event, as it is no longer needed
        self:UnregisterEvent("ADDON_LOADED")
        -- Initialize the addon
        InitializeAddon()
    end
end)
