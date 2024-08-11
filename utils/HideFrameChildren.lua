local function HideFrameChildren(frame)
    -- Iterate through all children of the frame
    for i, child in ipairs({frame:GetChildren()}) do
        -- Hide each child frame
        child:Hide()
    end
end

OPF.HideFrameChildren = HideFrameChildren
