---@type vim.lsp.Config
return {
    ---@type lspconfig.settings.jsonls
    settings = {
        json = {
            schemas = {
                {
                    -- used for luals
                    fileMatch = { ".luarc.json" },
                    url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
                },
                {
                    -- used for basedpyright
                    fileMatch = { "pyrightconfig.json" },
                    url = "https://raw.githubusercontent.com/DetachHead/basedpyright/refs/heads/main/packages/vscode-pyright/schemas/pyrightconfig.schema.json",
                },
            },
            validate = { enable = true },
            format = { enable = true },
        },
    },
}
