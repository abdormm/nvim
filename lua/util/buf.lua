local M = {}

---@param buf integer?
---@return integer
M.resolve = function(buf)
    if not buf or buf == 0 then
        return vim.api.nvim_get_current_buf()
    end
    return buf
end

---@param buf integer?
---@return boolean
M.is_terminal = function(buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf or 0 })
    return buftype == "terminal"
end

---@param dir string
---@param buf integer?
---@return boolean
M.is_in_dir = function(dir, buf)
    local name = vim.api.nvim_buf_get_name(buf or 0)
    return vim.fs.relpath(dir, name) ~= nil
end

return M
