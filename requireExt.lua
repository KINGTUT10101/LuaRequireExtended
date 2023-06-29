--[[
    REQUIRE EXTENDED:
    - Ex: local out1, out2 = require ("libs.myFile", input1, input2, input3)
    - This module overrides global function for loading files (require)
    - It allows users to send parameters to required files through varargs
    - It also allows required files to return multiple values
    - It should be mostly backwards compatible with the old version of require
    - NOTE: This function changes how package.loaded stores output data,
        so this may break programs that rely on that (although they're quite rare)
        (package.loaded will now store outputs in an array)
    - NOTE: The error messages may be different than with the original require function
    - It's recommended that you load this file first thing in your program
]]


require = function (filename, ...)
    -- File hasn't been loaded yet
    if package.loaded[filename] == nil then
        local outputs -- Holds the values returned by the file
        local filepath = string.gsub(filename, "%.", "/")

        -- Split package.path into individual paths
        local paths = {}
        for path in package.path:gmatch("[^;]+") do
            table.insert(paths, path)
        end
        table.insert(paths, filename .. "/init.lua")

        -- Iterate over each path and check if the module file exists
        -- IDK if this actually works for files on other paths since I never use this feature
        local func
        for _, path in ipairs(paths) do
            local testFilepath = path:gsub("%?", filepath) -- Replace "?" with the module path
            func = loadfile (testFilepath)

            if func ~= nil then
                break
            end
        end

        if func == nil then
            error ("Module '" .. filename .. "' not found.")
        end

        outputs = {func (...)} -- Gets the outputs
        
        if #package.loaded[filename] == 0 then
            package.loaded[filename] = {true} -- Saves the returned values to the global table
            return true -- Returns true if the required file had no outputs (matching the behavior of the original function)
        else
            package.loaded[filename] = outputs -- Saves the returned values to the global table
            return unpack (outputs) -- Returns the values outputted by the required file
        end

    -- File was loaded with the original require
    elseif type (package.loaded[filename]) ~= "table" then
        package.loaded[filename] = {package.loaded[filename]}
        return unpack (package.loaded[filename])

    -- File was successfully loaded in the past
    else
        return unpack (package.loaded[filename])
    end
end