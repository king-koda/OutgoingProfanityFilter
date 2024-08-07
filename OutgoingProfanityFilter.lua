local OutgoingProfanityFilter, NS = ...
OPF = {}
OPF.currentIndex = 0

-- Create a frame to handle events
local eventFrame = CreateFrame("Frame")

-- Register the ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")

UIPanelWindows["OPFConfigFrame"] = {area = "center", whileDead = true}
UIPanelWindows["WordsToReplaceUI"] = {area = "center", whileDead = true}
UIPanelWindows["DefaultWordReplacementUI"] = {area = "center", whileDead = true}
UIPanelWindows["WordReplacementOverridesUI"] = {
    area = "center",
    whileDead = true
}

local function InitializeAddon()
    local OPFConfigFrame = _G["OPFConfigFrame"]
    local TextArea = _G["OPFConfigWordsToReplaceTextArea"]
    local WordsToReplaceUI = _G["WordsToReplaceUI"]
    local DefaultWordReplacementUI = _G["DefaultWordReplacementUI"]
    local WordReplacementOverridesUI = _G["WordReplacementOverridesUI"]

    -- Initialize saved variables
    OPFData = OPFData or {}

    local replacementString = NS.RP.replacementString
    local wordsToReplaceOverrides = NS.RP.wordsToReplaceOverrides
    local wordsToReplaceTable = OPFData["wordsToReplaceTable"] or {}
    local wordsToReplaceString = OPFData["wordsToReplaceString"] or ""

    -- preserve reference to original function
    local _ShowUIPanel = ShowUIPanel;

    function ShowUIPanel(frame, ...)
        local frameName = frame:GetName()
        -- override the OnHide script for WordsToReplaceUI to show the OPFConfigFrame, 
        -- to allow escape to navigate backwards, as well as close the UI entirely when on OPFConfigFrame
        if (frameName == "WordsToReplaceUI" or frameName ==
            "DefaultWordReplacementUI" or frameName ==
            "WordReplacementOverridesUI") then
            _ShowUIPanel(frame, ...)
            frame:SetScript("OnHide", function()
                ShowUIPanel(OPFConfigFrame)
            end)
        else
            _ShowUIPanel(frame, ...)
        end
    end

    -- preserve reference to original function
    local _SendChatMessage = SendChatMessage;

    -- local function replaceWordsWithOverrides(modifiedMessage)
    --     for match, replacementStringOverride in pairs(wordsToReplaceOverrides) do
    --         -- replace word with a unique override
    --         modifiedMessage = modifiedMessage:gsub(match,
    --                                                replacementStringOverride)
    --     end

    --     return modifiedMessage
    -- end

    local function replaceWords(modifiedMessage)
        for index, match in ipairs(wordsToReplaceTable) do
            local escapedMatch = match:gsub("%-", "%%-")
            local result = string.find(modifiedMessage, escapedMatch)
            if (result ~= nil) then
                -- replace word with a universal override
                modifiedMessage = modifiedMessage:gsub(escapedMatch,
                                                       replacementString)
            end
        end
        return modifiedMessage
    end

    -- override the original function
    function SendChatMessage(message, ...)
        -- set message to lowercase for easier comparison, and disallow bypassing via capitalization
        local modifiedMessage = string.lower(message)

        -- apply the overrides first before the catch all
        -- modifiedMessage = replaceWordsWithOverrides(modifiedMessage)
        -- apply replacementString to all wordsToReplace
        modifiedMessage = replaceWords(modifiedMessage)

        -- call original function with the newly modified message
        _SendChatMessage(modifiedMessage, ...);
    end

    -- Function to show the main frame
    function ShowOPFConfigFrame() ShowUIPanel(OPFConfigFrame) end

    -- Functions to show the individual frames
    function ShowWordsToReplaceUI()
        -- populate the text area with the current wordsToReplaceString
        TextArea:SetText(wordsToReplaceString or "")
        TextArea:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tileSize = 400,
            insets = {left = -10, right = -10, top = -10, bottom = -400}
        })
        ShowUIPanel(WordsToReplaceUI)
    end

    function ShowDefaultWordReplacementUI()
        ShowUIPanel(DefaultWordReplacementUI)
    end

    function ShowWordReplacementOverridesUI()
        ShowUIPanel(WordReplacementOverridesUI)
    end

    -- Register the /opf command
    SLASH_OPF1 = "/opf"
    SlashCmdList["OPF"] = ShowOPFConfigFrame

end

-- Event handler function
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "OutgoingProfanityFilter" then
        -- Unregister the event, as it is no longer needed
        self:UnregisterEvent("ADDON_LOADED")
        -- Initialize the addon
        InitializeAddon()
    end
end)
