local os_name = vim.fn.has("win32") == 1 and "windows" or "linux"
local M = {}

return setmetatable(M, {
    __index = function(_, k)
        return require("platform." .. os_name .. "." .. k)
    end,
})
