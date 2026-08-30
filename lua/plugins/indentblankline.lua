---@type LazyPluginSpec
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@type ibl.config
    opts = {
        indent = {
            char = "│",
        },
        scope = {
            show_start = false,
            show_end = false,
        },
        -- exclude = {
        --     filetypes = {
        --     },
        -- },
    },
}
