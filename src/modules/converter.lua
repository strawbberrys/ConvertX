local parser = require(script.Parent.parser)
local property_parser = require(script.Parent.DumpParser)

local converter = {}

do
    local cached_properties, cached_default_values = {}, {}

    function converter.BuildProperties(instance)
        local _properties = {}
        local property_list, default_value_list = cached_properties[instance.ClassName], cached_default_values[instance.ClassName]

        if (not property_list or not default_value_list) then
            if (not property_list) then
                property_list = {}

                for index, property in ipairs(property_parser:GetPropertyList(instance.ClassName)) do
                    table.insert(property_list, property)
                end

                cached_properties[instance.ClassName] = property_list
            end

            if (not default_value_list) then
                default_value_list = {}

                local object = Instance.new(instance.ClassName)

                for index, property in ipairs(property_list) do
                    default_value_list[property] = object[property]
                end

                cached_default_values[instance.ClassName] = default_value_list
            end
        end

        for index, property in ipairs(property_list) do
            local value = instance[property]

            if (property ~= "Parent" and default_value_list[property] ~= value) then
                _properties[property] = (property == "ClassName" and value) or parser.Parse(value)
            end
        end

        return _properties
    end

    function converter.BuildInstance(instance, with_descendants)
        local _instance = {}

        for index, object in ipairs(instance:GetChildren()) do
            
        end

        return _instance
    end
end

return converter