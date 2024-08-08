local function EscapeText(text)
    local special_chars = {
        "%%", "%(", "%)", "%.", "%+", "%-", "%*", "%?", "%[", "%^", "%$"
    }
    for _, char in ipairs(special_chars) do
        text = text:gsub(char, "%%" .. char:sub(2))
    end
    return text
end

OPF.EscapeText = EscapeText
