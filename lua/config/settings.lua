local o, g, env = vim.o, vim.g, vim.env

if g.neovide then
    g.neovide_padding_top = 10
    g.neovide_cursor_trail_size = 0.9
    g.neovide_cursor_animation_length = 0.2
    g.neovide_cursor_short_animation_length = 0.08
    g.neovide_floating_shadow = false
    g.neovide_hide_mouse_when_typing = true
end

g.initial_theme = "mfd-flir-fusion"
g.mapleader = " "
g.maplocalleader = " "

o.cdhome = false -- to match windows behavior
o.exrc = true

o.number = true
o.relativenumber = true
o.wrap = false

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4

o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"

o.clipboard = "unnamed,unnamedplus"
o.winborder = "rounded"
o.signcolumn = "yes:1"

o.laststatus = 3
o.showtabline = 0

o.winbar = "%= %f%( %r%m%) "
o.statusline = " %<%f %h%m%r %= %l,%c%V | %P | %n "

o.list = true
o.listchars = "trail:-,nbsp:+,tab:<->"

-- env
env.nvimdata = vim.fn.stdpath("data")
env.nvimconfig = vim.fn.stdpath("config")
