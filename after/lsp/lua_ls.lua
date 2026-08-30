---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    -- root_dir = require("util.lsp").cwd_root_dir,
    ---@type lspconfig.settings.lua_ls
    settings = {
        Lua = {
            codeLens = { enable = true },
            hint = { enable = true, semicolon = "Disable" },
            format = {
                enable = true,
                defaultConfig = {
                    quote_style = "double",
                    call_arg_parentheses = "remove_table_only",
                    align_call_args = "true",
                    align_continuous_rect_table_field = "false",
                    trailing_table_separator = "smart",
                    align_array_table = "false",
                    max_line_length = "88",
                },
            },
            -- runtime = {
            --     version = "LuaJIT",
            --     path = {
            --         "lua/?.lua",
            --         "lua/?/init.lua",
            --     },
            -- },
            -- workspace = {
            --     library = {
            --         vim.env.VIMRUNTIME,
            --     },
            -- },
        },
    },
}
