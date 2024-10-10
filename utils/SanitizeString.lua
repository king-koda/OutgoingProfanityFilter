local function SanitizeString(textArea)
    local text = textArea:GetText()

    -- Pattern to match the color-coded text
    local colorCodePattern = "|cff0000ff(.-)|r"
    -- remove the color coding artifacts from search/highlighting before parsing the text
    text = string.gsub(text, colorCodePattern, "%1")

    -- Remove newlines
    text = string.gsub(text, "\n", "")
    -- Remove spaces
    text = string.gsub(text, "%s", "")

    return text
end

OPF.SanitizeString = SanitizeString
