local function GetOverrideRowsStartingWithCharacter(character)
    -- set the current focused character overrides
    OPF.WRO.currentCharacter = character

    -- get content frame that the rows will be appended to
    local parentFrame = _G["WordReplacementOverridesContent"]

    -- get scroll frame to handle auto scrolling
    local scrollFrame = _G["WordReplacementOverridesScrollFrame"]

    local currentCharacterTextFrame =
        _G["WordReplacementOverridesUICurrentCharacterText"]

    -- Clear existing children
    OPF.HideFrameChildren(parentFrame)

    local seen = {}

    for word, override in pairs(OPFData["wordsToReplaceWithOverridesTable"]) do
        -- if seen already, return early
        if (seen[word]) then return end

        if (character == '++') then
            local hasCharacter = false
            for index, paginationIndex in ipairs(OPF.WRO.paginationIndexes) do
                -- only loop if we are not at ++ character
                if (paginationIndex ~= '++') then
                    -- if the word belongs to another character, skip it
                    if string.sub(word, 1, 1) == paginationIndex then
                        hasCharacter = true
                    end
                end
            end

            -- if the word doesn't belong to another character, generate it for the ++ character
            if (hasCharacter == false) then
                OPF.WRO.GenerateOverrideRow(parentFrame,
                                            OPF.WRO.frameNumberIndex, word,
                                            override, character)
                OPF.WRO.frameNumberIndex = OPF.WRO.frameNumberIndex + 1
            end
        elseif string.sub(word, 1, 1) == character then
            OPF.WRO.GenerateOverrideRow(parentFrame, OPF.WRO.frameNumberIndex,
                                        word, override, character)
            OPF.WRO.frameNumberIndex = OPF.WRO.frameNumberIndex + 1
        end

        seen[word] = true

    end

    if (character == '++') then
        currentCharacterTextFrame:SetText(
            "Currently displaying words starting with any non-listed characters")
        return
    else
        currentCharacterTextFrame:SetText(
            "Currently displaying words starting with '" ..
                OPF.WRO.currentCharacter .. "'")
    end
    -- reset scroll bar to top when changing characters being searched by
    scrollFrame.ScrollBar:SetValue(0)
end

OPF.WRO.GetOverrideRowsStartingWithCharacter =
    GetOverrideRowsStartingWithCharacter
