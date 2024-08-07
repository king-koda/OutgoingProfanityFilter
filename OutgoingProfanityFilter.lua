local OutgoingProfanityFilter, NS = ...

OPF = {}
OPF.currentIndex = 0
OPF.searchResults = {}

UIPanelWindows["OPFConfigFrame"] = {area = "center", whileDead = true}
UIPanelWindows["WordsToReplaceUI"] = {area = "center", whileDead = true}
UIPanelWindows["DefaultWordReplacementUI"] = {area = "center", whileDead = true}
UIPanelWindows["WordReplacementOverridesUI"] = {
    area = "center",
    whileDead = true
}

local function InitializeAddon()
    -- Initialize saved variables
    OPFData = OPFData or {
        ["wordsToReplaceTable"] = {},
        ["wordsToReplaceString"] = "",
        ["defaultWordReplacementString"] = "",
        ["wordReplacementOverrides"] = {}
    }

    local OPFConfigFrame = _G["OPFConfigFrame"]
    local WordsToReplaceTextArea = _G["WordsToReplaceTextArea"]
    local DefaultWordReplacementTextArea = _G["DefaultWordReplacementTextArea"]
    local WordsToReplaceUI = _G["WordsToReplaceUI"]
    local DefaultWordReplacementUI = _G["DefaultWordReplacementUI"]
    local WordReplacementOverridesUI = _G["WordReplacementOverridesUI"]

    local wordsToReplaceTable = OPFData["wordsToReplaceTable"]
    local wordsToReplaceString = OPFData["wordsToReplaceString"]
    local defaultWordReplacementString = OPFData["defaultWordReplacementString"]
    local wordReplacementOverrides = OPFData["wordReplacementOverrides"]

    -- preserve reference to original function
    local _ShowUIPanel = ShowUIPanel;

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

    local function replaceWordsWithOverrides(modifiedMessage)
        for match, replacementStringOverride in pairs(wordReplacementOverrides) do
            -- replace word with a unique override
            modifiedMessage = modifiedMessage:gsub(match,
                                                   replacementStringOverride)
        end

        return modifiedMessage
    end

    local function replaceWords(modifiedMessage)
        for index, match in ipairs(wordsToReplaceTable) do
            local escapedMatch = match:gsub("%-", "%%-")
            local result = string.find(modifiedMessage, escapedMatch)
            if (result ~= nil) then
                -- replace word with a universal override
                modifiedMessage = modifiedMessage:gsub(escapedMatch,
                                                       defaultWordReplacementString)
            end
        end
        return modifiedMessage
    end

    -- override the original function
    function SendChatMessage(message, ...)
        -- set message to lowercase for easier comparison, and disallow bypassing via capitalization
        local modifiedMessage = string.lower(message)

        -- apply the overrides first before the catch all
        modifiedMessage = replaceWordsWithOverrides(modifiedMessage)
        -- apply defaultReplacementString to all wordsToReplace
        modifiedMessage = replaceWords(modifiedMessage)

        -- call original function with the newly modified message
        _SendChatMessage(modifiedMessage, ...);
    end

    -- Function to show the main frame
    function ShowOPFConfigFrame() ShowUIPanel(OPFConfigFrame) end

    -- Functions to show the individual frames
    function ShowWordsToReplaceUI()
        -- populate the text area with the current wordsToReplaceString
        WordsToReplaceTextArea:SetText(wordsToReplaceString or "")
        WordsToReplaceTextArea:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tileSize = 400,
            insets = {left = -10, right = -10, top = -10, bottom = -400}
        })
        ShowUIPanel(WordsToReplaceUI)
    end

    function ShowDefaultWordReplacementUI()
        DefaultWordReplacementTextArea:SetText(
            defaultWordReplacementString or "")
        ShowUIPanel(DefaultWordReplacementUI)
    end

    local function createWordReplacementLine(parent, index, nonEditableText,
                                             editableText)
        local line = CreateFrame("Frame",
                                 "WordReplacementOverridesLine" .. index, parent)
        line:SetSize(340, 30)
        line:SetPoint("TOPLEFT", parent, 10, -10 - (index - 1) * 35)

        local nonEditable = line:CreateFontString(
                                "WordReplacementOverridesLine" .. index ..
                                    "NonEditable", "ARTWORK", "GameFontNormal")
        nonEditable:SetSize(160, 30)
        nonEditable:SetPoint("LEFT")
        nonEditable:SetText(nonEditableText)

        local editable = CreateFrame("EditBox",
                                     "WordReplacementOverridesLine" .. index ..
                                         "Editable", line, "InputBoxTemplate")
        editable:SetSize(160, 30)
        editable:SetPoint("LEFT", nonEditable, "RIGHT", 10, 0)
        editable:SetText(editableText)

        return line
    end

    local function isTableEmpty(t)
        for _ in pairs(t) do return false end
        return true
    end

    function ShowWordReplacementOverridesUI()
        local wss = _G["WordReplacementOverridesContent"]

        -- local isEmpty = isTableEmpty(wordReplacementOverrides)
        -- if (isEmpty == false) then
        -- local numberedIndex = 1

        print(#wordsToReplaceTable)

        for index, match in ipairs(wordsToReplaceTable) do

            if (wordReplacementOverrides[match] == nil) then
                wordReplacementOverrides[match] = ""
            end

            createWordReplacementLine(wss, index, match,
                                      wordReplacementOverrides[match])
        end
        -- for index, value in pairs(wordReplacementOverrides) do
        --     createWordReplacementLine(wss, numberedIndex, index, value)
        --     numberedIndex = numberedIndex + 1
        -- end
        -- else

        -- end

        ShowUIPanel(WordReplacementOverridesUI)

    end

    -- Register the /opf command
    SLASH_OPF1 = "/opf"
    SlashCmdList["OPF"] = ShowOPFConfigFrame

    -- local function SaveData()
    --     OPFData["wordReplacementOverrides"] = {"example1", "example2", "example3"}
    --     print("Data saved to OPFData['wordReplacementOverrides']")
    -- end

    -- -- Call SaveData and LoadData for testing
    -- SaveData()

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
