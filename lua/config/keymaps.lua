local set, del = vim.keymap.set, vim.keymap.del

if vim.g.neovide then
    local function report_scale_factor()
        if vim.g.neovide_scale_factor == 1 then
            vim.api.nvim_echo({ { "scale_factor = 1", "Function" } }, false, {})
        end
    end
    set("n", "<M-Down>", function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end)
    set("n", "<C-=>", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
        report_scale_factor()
    end)
    set("n", "<C-->", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
        report_scale_factor()
    end)
    set("n", "<M-Up>", function()
        if vim.g.neovide_opacity ~= 1 then
            vim.g.neovide_opacity = 1
        else
            vim.g.neovide_opacity = 0.8
        end
    end)
end

-- progress toggling
set("n", "<Leader>p", function()
    if not vim.g.no_lsp_progress then
        -- clear the progress before disabling it
        local opts = {
            kind = "progress",
            percent = 100,
            status = "success",
            source = "config.keymaps.no_lsp_progress"
        }
        vim.api.nvim_echo({ { "Disabling Lsp progress" } }, false, opts)
    end
    vim.g.no_lsp_progress = not vim.g.no_lsp_progress
end)

-- remove lsp defaults
del({ "n", "x" }, "gra")
del("n", "gri")
del("n", "grn")
del("n", "grr")
del("n", "grt")
del("n", "grx")

-- picker
set("n", "<Leader><Leader>", function()
    require("util.picker").files()
end)
set("n", "<Leader>sn", function()
    require("util.picker").files { cwd = vim.env.nvimconfig }
end)
set("n", "<Leader>st", function()
    require("util.picker").builtin()
end)
set("n", "<Leader>sr", function()
    require("util.picker").resume()
end)
set("n", "<Leader>sg", function()
    require("util.picker").live_grep()
end)
set("n", "<Leader>sk", function()
    require("util.picker").keymaps()
end)
set("n", "<Leader>sh", function()
    require("util.picker").help_tags()
end)
set("n", "<Leader>sH", function()
    require("util.picker").highlights()
end)
set("n", "<Leader>sb", function()
    require("util.picker").buffers()
end)
set("n", "<Leader>sl", function()
    require("util.picker").blines()
end)
set("n", "<Leader>sD", function()
    require("util.picker").diagnostics_document()
end)
set("n", "<Leader>sd", function()
    require("util.picker").diagnostics_workspace()
end)
set("n", "<Leader>s.", function()
    require("util.picker").oldfiles()
end)
set("n", "<C-CR>", function()
    require("util.picker").spell_suggest()
end)

-- movement
-- NOTE: useful when used with relative number.
-- [count]<M-k> moves the lines up such that they are above the line with
--              relnum equal to [count].
-- [count]<M-j> moves the lines down such that they are below the line with
--              relnum equal to [count].
-- when moving up in visual make sure that the cursor is on the first line of
-- the selection to be able to use this method.
-- when moving down in visual make sure that the cursor is on the last line of
-- the selection to be able to use this method.
-- credit: "https://github.com/LazyVim/LazyVim/commit/b4eb4e1f4a4024229fe40782fdb12683c1c69634"
set("i", "<M-k>", "<Esc>:move .-2<CR>==gi")
set("i", "<M-j>", "<Esc>:move .+1<CR>==gi")
set("n", "<M-k>", "<Cmd>execute ':move .-' . (v:count1 + 1)<CR>==")
set("n", "<M-j>", "<Cmd>execute ':move .+' . v:count1<CR>==")
set("v", "<M-k>", [[
:<C-u>silent execute "'<,'>move '<-" . (v:count1 + 1)<CR>:silent normal gv=<CR>gv]])
set("v", "<M-j>", [[
:<C-u>silent execute "'<,'>move '>+" . v:count1<CR>:silent normal gv=<CR>gv]])

-- copying
set({ "i", "n" }, "<M-K>", "<Cmd>copy .-1<CR>")
set({ "i", "n" }, "<M-J>", "<Cmd>copy .<CR>")
set("v", "<M-K>", ":copy '<-1<CR>gv")
set("v", "<M-J>", ":copy '><CR>gv")

-- terminal
set("t", "<M-v>", "<C-\\><C-N>pi")

-- navigation
-- this is done to get around the case where you just made a change
-- g; will jump to that change (not changing the cursor position) so
-- effectively in this case to jump the previous one you will have to do g;
-- twice.
set("n", "<C-;>", "<Cmd>silent! normal g;g,g;<CR>")
set("n", "<C-,>", "<Cmd>silent! normal g,g;g,<CR>")
