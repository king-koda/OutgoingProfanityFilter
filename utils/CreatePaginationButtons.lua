local function CreatePaginationButtons()
    local ui = _G["WordReplacementOverridesUI"]
    local scrollFrame = _G["WordReplacementOverridesScrollFrame"]

    -- indexes to paginate by
    OPF.WRO.paginationIndexes = {
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
        'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '++'
    }

    local startingX = -160
    local startingY = 18

    for index, value in ipairs(OPF.WRO.paginationIndexes) do
        -- start a new row when we reach 't'
        if (value == 't') then
            startingY = startingY + 20
            startingX = -52
        end

        local paginationButton = CreateFrame("Button",
                                             "WordReplacementOverridesUIPaginationButton" ..
                                                 value, ui,
                                             "UIPanelButtonTemplate")

        paginationButton:SetText(value)
        paginationButton:SetSize(20, 16)
        paginationButton:SetPoint("BOTTOM", scrollFrame, "BOTTOM", startingX,
                                  -startingY)
        paginationButton:SetScript("OnClick", function()
            OPF.WRO.GetOverrideRowsStartingWithCharacter(value)
        end)

        -- increment the x position for each button
        startingX = startingX + 20
    end

end

OPF.WRO.CreatePaginationButtons = CreatePaginationButtons
