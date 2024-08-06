local OutgoingProfanityFilter, NS = ...
local category, layout

-- Create a frame to handle events
local eventFrame = CreateFrame("Frame")

OPF = {}

-- Register the ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")

OPF.currentIndex = 0

local function InitializeAddon()
    -- Initialize saved variables
    OPFData = OPFData or {}

    local replacementString = NS.RP.replacementString
    local wordsToReplaceOverrides = NS.RP.wordsToReplaceOverrides
    local wordsToReplaceTable = OPFData["wordsToReplaceTable"] or {}
    local wordsToReplaceString = OPFData["wordsToReplaceString"] or ""

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

    -- Register the slash command
    SLASH_OPF1 = "/opf"

    -- Function to show the configuration window
    local function ShowConfigWindow()
        local configFrame = _G["OPFConfigFrame"]

        -- Assuming you have a frame named "OPFConfigFrame"
        if configFrame then
            configFrame:Show()
        else
            print("Configuration window not found.")
        end
    end

    -- Define the command handler function
    SlashCmdList["OPF"] = function(msg)
        local textArea = _G["OPFConfigWordsToReplaceTextArea"]

        -- Open the configuration window
        textArea:SetText(wordsToReplaceString or "")

        ShowConfigWindow()
    end

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
