local function EscapeText(text)
    -- TODO: this seems to work better than the above
    local matches = {
        ["^"] = "%^",
        ["$"] = "%$",
        ["("] = "%(",
        [")"] = "%)",
        ["%"] = "%%",
        ["."] = "%.",
        ["["] = "%[",
        ["]"] = "%]",
        ["*"] = "%*",
        ["+"] = "%+",
        ["-"] = "%-",
        ["?"] = "%?"
    }

    return text:gsub(".", matches)
end

OPF.EscapeText = EscapeText
