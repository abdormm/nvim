local M = {}

---@param win integer?
---@return integer
M.resolve = function(win)
    if not win or win == 0 then
        return vim.api.nvim_get_current_win()
    end
    return win
end

---@param listed boolean
---@param scratch boolean
---@param config vim.api.keyset.win_config
---@return integer win
---@return integer buf
M.new_empty = function(listed, scratch, config)
    local buf = vim.api.nvim_create_buf(listed, scratch)
    local win = vim.api.nvim_open_win(buf, false, config)
    return win, buf
end

---Checks if a window is a floating window.
---@param win integer?
---@return boolean
M.is_floating = function(win)
    return vim.api.nvim_win_get_config(win or 0).relative ~= ""
end

---Checks if a window is the last non-floating window in its tab.
---@param win integer?
---@return boolean
M.is_last = function(win)
    local tab = vim.api.nvim_win_get_tabpage(win or 0)
    local nonfloating_count = require("util.tab").nonfloating_count(tab)
    return nonfloating_count == 1 and not M.is_floating(win)
end

return M
