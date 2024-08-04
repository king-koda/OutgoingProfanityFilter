local OutgoingProfanityFilter, NS = ...
local category, layout

-- Create a frame to handle events
local eventFrame = CreateFrame("Frame")

-- Register the ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")

local function InitializeAddon()
	-- Initialize saved variables
	MyTextEditorData = MyTextEditorData or {["wordsToReplace"]=""}

	local replacementString = NS.ReplacementPreferences.replacementString
	local wordsToReplaceOverrides = NS.ReplacementPreferences.wordsToReplaceOverrides
	local wordsToReplace = MyTextEditorData["wordsToReplace"]

	print('hello')
	print(wordsToReplace)
	-- preserve reference to original function
	local _SendChatMessage = SendChatMessage;

	local function replaceWordsWithOverrides(modifiedMessage)
		for match, replacementStringOverride in pairs(wordsToReplaceOverrides) do
			-- replace word with a unique override
			modifiedMessage = modifiedMessage:gsub(match, replacementStringOverride)
		end

		return modifiedMessage
	end

	local function replaceWords(modifiedMessage)
		for match in string.gmatch(wordsToReplace, "([^,]+)") do
		-- for index, match in pairs(wordsToReplace) do
			-- replace word with a universal override
			modifiedMessage = modifiedMessage:gsub(match, replacementString)
		end
		return modifiedMessage
	end

	-- override the original function
	function SendChatMessage(message, ...)
		-- set message to lowercase for easier comparison, and disallow bypassing via capitalization
		local modifiedMessage = string.lower(message)

		-- apply the overrides first before the catch all
		modifiedMessage = replaceWordsWithOverrides(modifiedMessage)

		-- apply replacementString to all wordsToReplace
		modifiedMessage = replaceWords(modifiedMessage)

		-- call original function with the newly modified message
		_SendChatMessage(modifiedMessage, ...);
	end



	-- Create a frame for the text editor
	local editorFrame = CreateFrame("Frame", "MyTextEditorFrame", UIParent, "BasicFrameTemplateWithInset")
	editorFrame:SetSize(400, 300)
	editorFrame:SetPoint("CENTER")
	editorFrame:Hide()

	-- Create a title for the editor frame
	local title = editorFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	title:SetPoint("TOP", editorFrame, "TOP", 0, -5)
	title:SetText("Outgoing Profanity Filter Config")  -- Set the title text

	-- Create a search bar
	local searchBox = CreateFrame("EditBox", "MySearchBox", editorFrame, "InputBoxTemplate")
	searchBox:SetSize(335, 20)
	searchBox:SetPoint("TOPRIGHT", editorFrame, "TOPRIGHT", -50, -30) -- Align search bar to the right with some padding
	searchBox:SetAutoFocus(false)
	searchBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

	-- Create a "Search:" label
	local searchLabel = editorFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	searchLabel:SetPoint("LEFT", searchBox, "LEFT", 0, 0) -- Position label to the left of the search bar
	searchLabel:SetText("Search...")

	-- Create a scroll frame for the text area
	local scrollFrame = CreateFrame("ScrollFrame", "MyTextEditorScrollFrame", editorFrame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetSize(380, 200)  -- Adjust the size of the scrollable area
	scrollFrame:SetPoint("TOP", editorFrame, "TOP", 0, -60)


	-- Create a text area inside the frame
	local textArea = CreateFrame("EditBox", "MyTextEditorTextArea", scrollFrame)
	textArea:SetMultiLine(true)
	textArea:SetSize(360, 800)
	textArea:SetPoint("TOP", scrollFrame, "TOP", 0, -60)
	textArea:SetFontObject("ChatFontNormal")
	textArea:SetAutoFocus(true)
	-- textArea:SetTextInsets(5, 5, 5, 5)  -- Add padding inside the text area
	textArea:SetScript("OnEscapePressed", function() editorFrame:Hide() end)
	scrollFrame:SetScrollChild(textArea)  -- Set the scroll child

	-- Adjust the scroll bar to be within the scroll frame
	scrollFrame.ScrollBar:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -25, -20)
	scrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -25, 20)

	-- Create a save button
	local saveButton = CreateFrame("Button", "MyTextEditorSaveButton", editorFrame, "UIPanelButtonTemplate")
	saveButton:SetSize(140, 22)
	saveButton:SetText("Save and Reload")
	saveButton:SetPoint("BOTTOM", editorFrame, "BOTTOM", 0, 10)
	saveButton:SetScript("OnClick", function()
		MyTextEditorData["wordsToReplace"] = textArea:GetText()
		editorFrame:Hide()
		print("Text saved!")
		ReloadUI()
	end)

	-- Function to highlight search results and get their positions
	local searchResults = {}
	local currentIndex = 0

	local function HighlightText(text, search)
		searchResults = {}
		if search == "" then
			return text
		end

		local searchPattern = string.gsub(search, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
		local start = 1

		while true do
			local s, e = string.find(text, searchPattern, start)
			if not s then break end
			table.insert(searchResults, {s = s, e = e})
			start = e + 1
		end

		local highlightedText = string.gsub(text, searchPattern, "|cffffd700%1|r")
		return highlightedText
	end

	-- Function to update the text area with highlighted search results
	local function UpdateTextArea()
		local text = MyTextEditorData["wordsToReplace"] or ""
		local search = searchBox:GetText() or ""
		local highlightedText = HighlightText(text, search)
		textArea:SetText(highlightedText)

		if search ~= "" then
			searchLabel:Hide()
		else
			searchLabel:Show()
		end
	end

-- Function to focus the next or previous search result
local function FocusSearchResult(direction)
    if #searchResults == 0 then
        print("No search results found")
        return
    end

    currentIndex = currentIndex + direction
    if currentIndex > #searchResults then
        currentIndex = 1
    elseif currentIndex < 1 then
        currentIndex = #searchResults
    end

    local pos = searchResults[currentIndex]
    textArea:HighlightText(pos.s - 1, pos.e) -- Highlight text

    -- Scroll to the highlighted text
    local text = textArea:GetText()
    local lines = {strsplit("\n", text)}
    local lineNumber = 1
    local offset = 0

    for i = 1, #lines do
        local lineLength = #lines[i] + 1 -- Include the newline character
        if pos.s <= offset + lineLength then
            lineNumber = i
            break
        end
        offset = offset + lineLength
    end

    textArea:SetCursorPosition(pos.s - offset) -- Set cursor position
    textArea:SetFocus()

    local scrollMin, scrollMax = scrollFrame.ScrollBar:GetMinMaxValues()
    local newScroll = (lineNumber - 1) / #lines * scrollMax
    scrollFrame.ScrollBar:SetValue(newScroll)
end

	-- Register key bindings for arrow keys
	-- textArea:SetScript("OnKeyDown", function(self, key)
	-- 	if key == "UP" then
	-- 		FocusSearchResult(-1)
	-- 	elseif key == "DOWN" then
	-- 		FocusSearchResult(1)
	-- 	end
	-- end)

		-- Create left and right arrow buttons next to the search bar
	local leftButton = CreateFrame("Button", "MyLeftButton", editorFrame, "UIPanelButtonTemplate")
	leftButton:SetSize(20, 20)
	leftButton:SetText("<")
	leftButton:SetPoint("RIGHT", searchBox, "RIGHT", 20, 0)
	leftButton:SetScript("OnClick", function()
		FocusSearchResult(-1)
	end)

	local rightButton = CreateFrame("Button", "MyRightButton", editorFrame, "UIPanelButtonTemplate")
	rightButton:SetSize(20, 20)
	rightButton:SetText(">")
	rightButton:SetPoint("RIGHT", searchBox, "RIGHT", 40, 0)
	rightButton:SetScript("OnClick", function()
		FocusSearchResult(1)
	end)

	-- Function to show tooltip
	local function ShowTooltip(button, text)
		button:SetScript("OnEnter", function()
			GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
			GameTooltip:SetText(text, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
	end

	-- Function to hide tooltip
	local function HideTooltip(button)
		button:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end

	-- Apply tooltips to buttons
	ShowTooltip(leftButton, "Previous Search Result")
	HideTooltip(leftButton)

	ShowTooltip(rightButton, "Next Search Result")
	HideTooltip(rightButton)


	-- Register slash command to open the editor
	SLASH_MYTEXTEDITOR1 = "/opf"
	SlashCmdList["MYTEXTEDITOR"] = function()
		editorFrame:Show()
		textArea:SetText(MyTextEditorData["wordsToReplace"] or "")
		textArea:SetFocus()
	end

	-- Register the OnTextChanged script for the search box
searchBox:SetScript("OnTextChanged", function()
    UpdateTextArea()
end)
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