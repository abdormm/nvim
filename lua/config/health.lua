local M = {}


M.check = function()
    vim.health.start("installed tools")
    if vim.fn.has("win32") == 1 then
        vim.health.start("windows related checks")
        vim.health.info("why")
    end
end

require("vim.health.health")
return M
