-- The module uses the address of the table as a key inside tables stored within package.loaded
-- This is done to distinguish require values from requireExt values
local masterKey = {}

require = function (filename, ...)
    -- File hasn't been loaded yet
    if package.loaded[filename] == nil then
        local outputs -- Holds the values returned by the file
        local success = false -- Will be set to true of the function can find the file

        -- Iterate over package.loaders and attempt to find a proper module loader
        for i = 1, #package.loaders do
            local result = package.loaders[i] (filename)

            if type (result) == "function" then
                outputs = {result (filename, ...)} -- Loads the file and stores the outputs
                success = true
                break
            end 
        end

        if success == false then
            error ("Module '" .. filename .. "' not found.")
        end
        
        if #outputs == nil then
            package.loaded[filename] = {true} -- Saves the returned values to the global table
            package.loaded[filename][masterKey] = true -- Sets the master key
            return true -- Returns true if the required file had no outputs (matching the behavior of the original function)
        else
            package.loaded[filename] = outputs -- Saves the returned values to the global table
            package.loaded[filename][masterKey] = true -- Sets the master key
            return unpack (outputs) -- Returns the values outputted by the required file
        end

    -- File was loaded with the original require
    elseif type (package.loaded[filename]) ~= "table" or package.loaded[filename][masterKey] ~= true then
        package.loaded[filename] = {package.loaded[filename]} -- Moves the value into a table
        package.loaded[filename][masterKey] = true -- Sets the master key
        return unpack (package.loaded[filename])

    -- File was successfully loaded in the past
    else
        return unpack (package.loaded[filename])
    end
end