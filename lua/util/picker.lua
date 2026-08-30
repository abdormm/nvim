if not vim.g.picker then
    vim.g.picker = vim.fn.has("win32") == 1 and "telescope.builtin" or "fzf-lua"
end

local M = {}

return setmetatable(M, {
    __index = function(_, k)
        return require(vim.g.picker)[k]
    end,
})
