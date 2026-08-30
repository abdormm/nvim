---@type LazyPluginSpec[]
return {
    { "kungfusheep/mfd.nvim" },
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_float_style = "dim"
            vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
        end,
    },
    {
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_enable_italic = true
            vim.g.everforest_background = "hard"
            vim.g.everforest_float_style = "dim"
            vim.g.everforest_diagnostic_virtual_text = "colored"
        end,
    },
}
