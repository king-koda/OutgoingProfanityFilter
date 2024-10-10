-- removes words that are no longer in the text area from the overrides table
local function PruneExistingTable(text, tableToBePruned)
    for word, override in pairs(tableToBePruned) do
        local escapedWord = OPF.EscapeText(word)
        if not (string.find(text, "%f[%a]" .. escapedWord .. "%f[%A]")) then
            tableToBePruned[word] = nil
        end
    end
end

OPF.PruneExistingTable = PruneExistingTable
