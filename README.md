# Lua: Require Extended

This is a small module that replaces the *require* function in Lua. It extends its behavior and allows you to load a file with inputs and receive multiple outputs.

### Example:
`local output1, output2 = require ("libs.myFile", input1, input2, input3)`

### Inside the Required File:
To access the input values inside a required file, use the same method you'd use for a function with varargs. To return multiple values from a required file, simply return multiple values (easy, right?).
```lua
-- (Inside libs/myFile.lua)
local param1, param2, param3 = ...

-- *** Do something within the file ***

return "foo", "bar"
```

### Including the Module:
Simply download this [file](https://github.com/KINGTUT10101/LuaRequireExtended/blob/main/requireExt.lua "file") and require it at the top of your program like so:

`require ("requireExt")`

### Notes:
- This module overrides the global function for loading files. Thus, it's recommended that you load it as early as possible in your program.
- It should be mostly backward compatible with the original require function, so you can simply drop this into your program with no worries.
- However, it does change how output values are stored in the global variable *package.loaded*. Instead, output values will be stored in an array. (ex: If *libs.myFile* returns *42*, then *package.loaded["libs.myFile"]* will contain *{42}* instead of just *42*)
- Like the original require function, each file is only loaded once, after which its output values can be found inside *package.loaded*. This means that you only need to provide input values to a required file once. After that, you can load the file elsewhere without having to provide the inputs again.

### Potential Uses:
- Initialize a module with data.

`local mapManager = require ("mapManager", blankMap")`
- Provide settings to a library.

`local useSlices = false; local menuMaster = require ("menuMaster", useSlices)`
- Use an input value to determine which parts of your library to load (can be helpful if you want to maintain different versions of the library without loading them all into memory or separating them into different libraries).

`local version = "Android"; local playerCon = require ("playerController", version)`
- Providing a value and a custom message when a library is loaded.

`local screenHandler, message = require ("classes.screenHandler")`

### Final Thoughts:
Admittedly, some might argue that this module is redundant and might encourage people to create messier code. To that, I must agree. Generally, there are many other ways to accomplish the potential uses I described. However, I've uploaded it here in case someone still finds this useful for their personal programming style. After all, I think it's important to offer alternative methods.
