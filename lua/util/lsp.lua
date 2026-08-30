local M = {}

---@param on_dir fun(dir: string)
M.cwd_root_dir = function(_, on_dir)
    on_dir(vim.fn.getcwd())
end

---comment
---@param config vim.lsp.ClientConfig
---@return lsp.WorkspaceFolder[]?
M.get_workspace_folders = function(config)
    if config.workspace_folders then
        return #config.workspace_folders > 0 and config.workspace_folders or nil
    end
    if config.root_dir then
        return {
            {
                name = config.root_dir,
                uri = vim.uri_from_fname(config.root_dir),
            },
        }
    end
end

---@param new_folders lsp.WorkspaceFolder[]?
---@param old_folders lsp.WorkspaceFolder[]?
---@return lsp.WorkspaceFolder[]
local function diff(new_folders, old_folders)
    if not new_folders or #new_folders == 0 then
        return {}
    end
    if not old_folders or #old_folders == 0 then
        return new_folders
    end
    local result = {}
    for _, new_folder in ipairs(new_folders) do
        local found = false
        for _, old_folder in ipairs(old_folders) do
            if new_folder.uri == old_folder.uri then
                found = true
                break
            end
        end
        if not found then
            result[#result + 1] = new_folder
        end
    end
    return result
end

---@param new_folders lsp.WorkspaceFolder[]?
---@param old_folders lsp.WorkspaceFolder[]?
---@return boolean
local function has_diff(new_folders, old_folders)
    if not new_folders or #new_folders == 0 then
        return false
    end
    if not old_folders or #old_folders == 0 then
        return true
    end
    for _, new_folder in ipairs(new_folders) do
        local found = false
        for _, old_folder in ipairs(old_folders) do
            if new_folder.uri == old_folder.uri then
                found = true
                break
            end
        end
        if not found then
            return true
        end
    end
    return false
end

---@param client vim.lsp.Client
---@param config vim.lsp.ClientConfig
---@return boolean
M.reuse_client_enhanced = function(client, config)
    if client.name ~= config.name or client:is_stopped() then
        return false
    end
    local config_folders = M.get_workspace_folders(config)

    if client:supports_method("workspace/didChangeWorkspaceFolders") then
        local added = diff(config_folders, client.workspace_folders)
        if #added == 0 then return true end
        local params = {
            event = {
                added = added,
                removed = {},
            }
        }
        client:notify("workspace/didChangeWorkspaceFolders", params)
        for _, folder in ipairs(added) do
            client.workspace_folders[#client.workspace_folders+1] = folder
        end
        return true
    end

    -- Reuse if both client and config was configured with no workspace folders
    if not config_folders then
        return not M.get_workspace_folders(client.config)
    end
    return not has_diff(config_folders, client.workspace_folders)
end

return M
