local function EscapeText(text)
    local special_chars = {
        "%%", "%(", "%)", "%.", "%+", "%-", "%*", "%?", "%[", "%^", "%$"
    }
    -- TODO: double check this works as good as it should
    for _, char in ipairs(special_chars) do
        text = text:gsub(char, "%%" .. char:sub(2))
    end
    return text
end

OPF.EscapeText = EscapeText
