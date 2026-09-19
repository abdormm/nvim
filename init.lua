require("config.settings")
require("config.autocmds")
require("config.keymaps")
require("config.commands")
require("config.tools")
require("config.lazy")

require("vim._core.ui2").enable { enable = false }

vim.cmd.colorscheme(vim.g.initial_theme)
