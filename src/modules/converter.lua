local parser = require(script.Parent.parser)
local property_parser = require(script.Parent.DumpParser)

local converter = {}

do
    function converter.Convert(instance, convert_single)
        local converted = ""

        for index, object in ipairs(instance:GetDescendants()) do
            
        end
    end
end

return converter