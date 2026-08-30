---@type LazyPluginSpec
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    ---@type neotree.Config
    opts = {
        open_files_using_relative_paths = true,
        enable_diagnostics = true,
        default_component_configs = {
            diagnostics = {
                symbols = {
                    -- error = "",
                    -- warn = "",
                    -- info = "",
                    -- hint = "󰌵",
                    error = "E",
                    warn = "W",
                    info = "I",
                    hint = "H",
                },
            },
        },
        event_handlers = {
            {
                event = "neo_tree_window_after_open",
                handler = function(ev)
                    local opts = { win = ev.winid }
                    vim.api.nvim_set_option_value("winbar", "%#NeoTreeNormal#", opts)
                    vim.api.nvim_set_option_value("fillchars", "eob: ", opts)
                end,
            },
        },
        window = {
            mappings = {
                ["zo"] = "expand_all_subnodes",
                ["zO"] = "expand_all_nodes",
                ["zc"] = "close_all_subnodes",
                ["zC"] = "close_all_nodes",
                ["|"] = "close_window",
                ["<C-\\>"] = "close_window",
                ["z"] = "noop",
            },
        },
        filesystem = {
            window = {
                mappings = {
                    ["gx"] = "ui_open",
                },
            },
        },
        commands = {
            ui_open = function(state)
                ---@diagnostic disable-next-line: undefined-field
                local node = state.tree:get_node()
                vim.ui.open(node.path)
            end,
            ui_open_visual = function(_, selected_nodes)
                for _, node in ipairs(selected_nodes) do
                    ---@diagnostic disable-next-line: undefined-field
                    vim.ui.open(node.path)
                end
            end,
        },
    },
    keys = {
        { "<C-N>", "<Cmd>Neotree toggle action=show<CR>" },
        { "<C-\\>", "<Cmd>Neotree reveal_force_cwd<CR>" },
        { "|", "<Cmd>Neotree toggle action=focus<CR>" },
    },
}
