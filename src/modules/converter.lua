local parser = require(script.Parent.parser)
local property_parser = require(script.Parent.DumpParser)

local converter = {}

do
    local cached_properties, cached_default_values = {}, {}

    local function table_count(table, value)
        local amount = 0

        for index, _value in pairs(table) do
            if (_value == value) then
                amount += 1
            end
        end

        return amount
    end

    function converter.BuildProperties(instance)
        local _properties = {}
        local property_list, default_value_list = cached_properties[instance.ClassName], cached_default_values[instance.ClassName]

        if (not property_list or not default_value_list) then
            if (not property_list) then
                property_list = {"ClassName"}

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

            if (property == "ClassName" or property ~= "Parent" and default_value_list[property] ~= value) then
                _properties[property] = (property == "ClassName" and value) or parser.Parse(value)
            end
        end

        return _properties
    end

    function converter.BuildInstance(instance, with_descendants, name_list)
        -- gonna need to add name fixing here so when theres multiple instances with the same name it adds a number suffix to them
        local _instance = converter.BuildProperties(instance)

        if (with_descendants ~= false) then
            local instance_children = instance:GetChildren()

            if (#instance_children ~= 0) then
                local seen_names = name_list or {}

                _instance.children = {}

                for index, object in ipairs(instance_children) do
                    local fixed_name = object.Name

                    if (table.find(seen_names, object.Name)) then
                        fixed_name ..= "_" .. table_count(seen_names, object.Name) + 1
                    end

                    table.insert(seen_names, object.Name)

                    _instance.children[fixed_name] = converter.BuildInstance(object, true, seen_names)
                end
            end
        end

        return _instance
    end

    function converter.Convert(instance, options)
    
    end
end

return converter