local M = {}

---@param tab integer?
---@return integer tab
M.resolve = function(tab)
    if not tab or tab == 0 then
        return vim.api.nvim_get_current_tabpage()
    end
    return tab
end

---@param listed boolean
---@param scratch boolean
---@param config vim.api.keyset.tabpage_config
---@return integer tab
---@return integer buf
M.new_empty = function(listed, scratch, config)
    local buf = vim.api.nvim_create_buf(listed, scratch)
    local tab = vim.api.nvim_open_tabpage(buf, false, config)
    return tab, buf
end


---@param tab integer?
---@return integer count
M.nonfloating_count = function(tab)
    local count = 0
    local is_floating = require("util.win").is_floating
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab or 0)) do
        if not is_floating(w) then
            count = count + 1
        end
    end
    return count
end

---@param tab integer?
---@return integer count
M.floating_count = function(tab)
    local count = 0
    local is_floating = require("util.win").is_floating
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab or 0)) do
        if is_floating(w) then
            count = count + 1
        end
    end
    return count
end

---@param tab integer?
---@return integer[]
M.list_nonfloating = function(tab)
    local result = {}
    local is_floating = require("util.win").is_floating
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab or 0)) do
        if not is_floating(w) then
            table.insert(result, w)
        end
    end
    return result
end

---@param tab integer?
---@return integer[]
M.list_floating = function(tab)
    local result = {}
    local is_floating = require("util.win").is_floating
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab or 0)) do
        if is_floating(w) then
            table.insert(result, w)
        end
    end
    return result
end

---@param tab integer?
---@return integer
M.get_first_nonfloating = function(tab)
    local is_floating = require("util.win").is_floating
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab or 0)) do
        if not is_floating(w) then
            return w
        end
    end
    -- shouldn't happen
    error("no win found get_first_nonfloating")
end

return M
