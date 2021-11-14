local selection = game:GetService("Selection")
local test_service = game:GetService("TestService")

local toolbar = plugin:CreateToolbar("ConvertX")
local convert_button = toolbar:CreateButton("Convert", "Converts an instance to a Lua script", "rbxassetid://7981754017")

local converter = require(script.Parent.modules.converter)

local function convert_selection()
    local start_time = os.clock()

    for index, selection in ipairs(selection:Get()) do
        converter:Convert(selection)
    end

    test_service:Message("✔️ Converted in " .. os.clock() - start_time .. " seconds!")
end

convert_button.Click:Connect(convert_selection)