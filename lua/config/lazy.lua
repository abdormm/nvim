local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
    if vim.v.shell_error ~= 0 then
        local msg = {
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
        }
        vim.api.nvim_echo(msg, true, {})
        vim.fn.getchar()
        return
    end
end
vim.opt.rtp:prepend(lazypath)

---@type LazyConfig
local opts = {
    spec = "plugins",
    change_detection = {
        enabled = false,
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,
        rtp = {
            reset = true,
            disabled_plugins = {
                "netrwPlugin",
                -- "gzip",
                -- "matchit",
                -- "matchparen",
                -- "tarPlugin",
                -- "tohtml",
                -- "tutor",
                -- "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded",
        backdrop = 100,
    },
    install = {
        colorscheme = { vim.g.initial_theme, "catppuccin" },
    }
}
require("lazy").setup(opts)
