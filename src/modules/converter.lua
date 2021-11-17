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

    function converter.BuildInstance(instance, with_descendants)
        local _instance = converter.BuildProperties(instance)

        if (with_descendants) then
            local instance_children = instance:GetChildren()

            if (#instance_children ~= 0) then
                _instance.children = {}

                for index, object in ipairs(instance_children) do
                    local object_children = object:GetChildren()

                    _instance.children[object.Name] = converter.BuildProperties(object)

                    if (#object_children ~= 0) then
                        _instance.children[object.Name].children = {}

                        for _index, _object in ipairs(object_children) do
                            _instance.children[object.Name].children[_object.Name] = converter.BuildProperties(_object)
                        end
                    end
                end
            end
        end

        return _instance
    end
end

return converter