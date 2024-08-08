local function GenerateOverrideRow(parent, index, word, override, character)
    if (OPF.WRO.currentCharacterFrames[character] == nil) then
        OPF.WRO.currentCharacterFrames[character] = {}
    end

    -- if a frame for that character/word combination doesn't already exist, make one
    if (OPF.WRO.currentCharacterFrames[character][word] == nil) then
        local line = CreateFrame("Frame",
                                 "WordReplacementOverridesLine" .. index, parent)
        line:SetSize(340, 30)
        line:SetPoint("TOPLEFT", parent, 10, -10 - (index - 1) * 35)

        local nonEditable = line:CreateFontString(
                                "WordReplacementOverridesLine" .. index ..
                                    "NonEditable", "ARTWORK", "GameFontNormal")
        nonEditable:SetSize(160, 30)
        nonEditable:SetPoint("LEFT")
        nonEditable:SetText(word)

        local editable = CreateFrame("EditBox",
                                     "WordReplacementOverridesLine" .. index ..
                                         "Editable", line, "InputBoxTemplate")
        editable:SetSize(160, 30)
        editable:SetPoint("LEFT", nonEditable, "RIGHT", 10, 0)
        editable:SetAutoFocus(false)

        -- only set the text if it's not nil
        if (override ~= OPF.NIL) then editable:SetText(override) end

        -- add each generated line to the currentCharacterFrames table for the given character index
        OPF.WRO.currentCharacterFrames[character][word] = line
        return
    end

    -- if the frame already exists, show it
    OPF.WRO.currentCharacterFrames[character][word]:Show()
end

OPF.WRO.GenerateOverrideRow = GenerateOverrideRow
