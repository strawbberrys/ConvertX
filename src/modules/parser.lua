local parser = {}

do
    local types = {
        BrickColor = "BrickColor.new(%f, %f, %f)",
        CFrame = "CFrame.new(%e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e)",
        Color3 = "Color3.fromRGB(%d, %d, %d)",
        ColorSequence = "ColorSequence.new({%s})",
        ColorSequenceKeypoint = "ColorSequenceKeypoint.new(%f, %s)",
        NumberSequence = "NumberSequence.new({%s})",
        NumberSequenceKeypoint = "NumberSequenceKeypoint.new(%f, %f, %f)",
        PhysicalProperties = "PhysicalProperties.new(%f, %f, %f, %f, %f)",
        Rect = "Rect.new(%f, %f, %f, %f)",
        string = "\"%s\"",
        UDim = "UDim.new(%f, %d)",
        UDim2 = "UDim2.new(%f, %d, %f, %d)",
        Vector2 = "Vector2.new(%e, %e)",
        Vector3 = "Vector3.new(%e, %e, %e)"
    }

    function parser.Parse(userdata)
        local userdata_type = typeof(userdata)

        -- using elseif here so i dont have to create lots of functions and use them everytime
        if (userdata_type == "BrickColor") then
            return types[userdata_type]:format(userdata.r, userdata.g, userdata.b)
        elseif (userdata_type == "CFrame") then
             return types[userdata_type]:format(userdata:GetComponents())
        elseif (userdata_type == "ColorSequence" or userdata_type == "NumberSequence") then
            local parsed_sequence = ""

            local sequence_keypoint_type = types[userdata_type .. "Keypoint"]
            local total_keypoint_amount = #userdata.Keypoints

            -- using an else instead of ternary here so i dont have to check every time if its a color sequence or number sequence
            if (userdata_type == "ColorSequence") then
                for index, keypoint in ipairs(userdata.Keypoints) do
                    local parsed_keypoint = sequence_keypoint_type:format(keypoint.Time, parser.Parse(keypoint.Value))

                    parsed_sequence ..= parsed_keypoint .. (index == total_keypoint_amount and "" or ", ")
                end
            else
                for index, keypoint in ipairs(userdata.Keypoints) do
                    local parsed_keypoint = sequence_keypoint_type:format(keypoint.Time, keypoint.Value, keypoint.Envelope)

                    parsed_sequence ..= parsed_keypoint .. (index == total_keypoint_amount and "" or ", ")
                end
            end

            return parsed_sequence
        elseif (userdata_type == "PhysicalProperties") then
            return types[userdata_type]:format(userdata.Density, userdata.Friction, userdata.Elasticity, userdata.FrictionWeight, userdata.ElasticityWeight)
        elseif (userdata_type == "Rect") then
            return types[userdata_type]:format(userdata.Max.X, userdata.Max.Y, userdata.Min.X, userdata.Min.Y)
        elseif (userdata_type == "UDim") then
            return types[userdata_type]:format(parser.TrimNumber(userdata.Scale), userdata.Offset)
        elseif (userdata_type == "UDim2") then
            return types[userdata_type]:format(parser.TrimNumber(userdata.X.Scale), userdata.X.Offset, parser.TrimNumber(userdata.Y.Scale), userdata.Y.Offset)
        elseif (userdata_type == "Vector2") then
            return types[userdata_type]:format(userdata.X, userdata.Y)
        elseif (userdata_type == "Vector3") then
            return types[userdata_type]:format(userdata.X, userdata.Y, userdata.Z)
        end
    end
    
    function parser.TrimNumber(number, amount)
        return number - number % (amount or 0.001)
    end

    parser.types = types
end

return parser