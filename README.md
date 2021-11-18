# ConvertX
An all in one Roblox instance converter plugin. *This plugin is not yet completed and is still in development.*

## Building the Plugin
You can build the rbxlx file using the [Rojo](https://rojo.space/) VSCode plugin or CLI:

|      VSCode      |               CLI               |
| :--------------: | :-----------------------------: |
| ```rojo build``` | ```rojo build -o build.rbxlx``` |

Once you build the rbxlx file, open it and save the ConvertX folder in ServerStorage as a local plugin. *The rbxlx file includes a test gui to convert in StarterGui.*

## Documentation
This documentation was made so you can debug and test functions used in the plguin. *"modules" refers to ServerStorage.ConvertX.modules.*

- modules.converter
  - <span class="hljs-keyword">\<Dictonary></span> BuildProperties(<span class="hljs-keyword">\<Instance></span> instance)
    - Returns a dictonary of every property of the instance and its formatted value. If the value is the same as one created with Instance.new, then the property will not be returned in the dictonary.<br/>
    *Note that the ClassName property will not be returned formatted and the Parent property will not be returned at all.*
  - <span class="hljs-keyword">\<Dictonary></span> BuildInstance(<span class="hljs-keyword">\<Instance></span> instance, <span class="hljs-keyword">\<Boolean?></span> with_descendants, <span class="hljs-keyword">\<Dictonary></span>, name_list)
    - If the with_descendants argument is true which by default it is, then it returns the instance as a dictonary including its descendants in the children key. If not, then it will just return the instance as a dictonary. The name_list argument is only used internally to add suffixes to names.
  - <span class="hljs-keyword">\<String></span> Convert(<span class="hljs-keyword">\<Instance></span> instance, <span class="hljs-keyword">\<Dictonary></span> options)
    - Returns an instance into a working Lua script formatted with options.
- modules.parser
  - <span class="hljs-keyword">\<String></span> Parse(<span class="hljs-keyword">\<Any></span> value)
    - Returns the value of any type converted to a string.

```lua
-- using this code in the built rbxmx file should output the instance as a dictonary
local converter = require(game.ServerStorage.ConvertX.modules.converter)

print(converter.BuildInstance(game.StarterGui.test_gui))
```