---@type LazyPluginSpec
return {
    "saghen/blink.cmp",
    lazy = false,
    branch = "v1",
    build = "cargo build --release",
    ---@type blink.cmp.Config
    opts = {
        fuzzy = {
            prebuilt_binaries = { download = false },
            frecency = { enabled = true },
        },
        cmdline = {
            enabled = false,
        },
        term = {
            enabled = false,
        },
        keymap = {
            preset = "enter",
        },
        completion = {
            list = {
                selection = {
                    auto_insert = false,
                    preselect = true,
                },
            },
            menu = {
                border = "none",
            },
            accept = {
                dot_repeat = true,
                auto_brackets = {
                    enabled = true,
                },
            },
        },
        appearance = {
            nerd_font_variant = "normal",
        },
        sources = {
            providers = {
                path = {
                    opts = {
                        get_cwd = function() return vim.fn.getcwd() end,
                    },
                },
                -- lsp = {
                --     transform_items = function (ctx, items)
                --         for _, item in ipairs(items) do
                --             local keyword = ctx.get_keyword()
                --             if item.filterText == "" then
                --                 item.filterText = keyword .. item.label
                --             end
                --         end
                --         return items
                --     end,
                -- }
            },
        },
    },
}
