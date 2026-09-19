local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("ColorScheme", {
    group = augroup("config.colorscheme", { clear = true }),
    callback = function()
        local hl = vim.api.nvim_set_hl
        hl(0, "FloatBorder", { link = "Normal" })
        hl(0, "FloatTitle", { link = "Normal" })
        hl(0, "NormalFloat", { link = "Normal" })
        hl(0, "WinBar", { update = true, bg = "bg" })
        hl(0, "WinBarNC", { update = true, bg = "bg" })
    end,
})

autocmd("LspProgress", {
    group = augroup("config.lsp.progress", { clear = true }),
    callback = function(ev)
        if vim.g.no_lsp_progress then return end
        local value = ev.data.params.value
        if value.percentage then
            value.percentage = math.min(value.percentage, 100)
            value.percentage = math.max(value.percentage, 0)
        end
        --- TODO: research if multiple concurrent lsp client can use the same token.
        vim.api.nvim_echo({ { value.message or "done" } }, false, {
            id = "lsp." .. ev.data.params.token,
            kind = "progress",
            source = "vim.lsp",
            title = value.title,
            status = value.kind ~= "end" and "running" or "success",
            percent = value.percentage,
        })
    end,
})

---@param ev vim.api.keyset.create_autocmd.callback_args
local function on_lsp_attach(ev)
    local set = vim.keymap.set
    local opts = { buf = ev.buf }
    set("n", "gd", function() require("util.picker").lsp_definitions() end, opts)
    set("n", "gr", function() require("util.picker").lsp_references() end, opts)
    set("n", "gI", function() require("util.picker").lsp_implementations() end, opts)
    set({ "n", "x" }, "<M-CR>", function() vim.lsp.buf.code_action() end, opts)
    set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
end

autocmd("LspAttach", {
    group = augroup("config.lsp.attach", { clear = true }),
    callback = on_lsp_attach,
})

local enable_treesitter = {
    bash = true,
    sh = true,
    c = true,
    cpp = true,
    html = true,
    java = true,
    javascript = true,
    json = true,
    latex = true,
    python = true,
    typescript = true,
    xml = true,
}

autocmd("FileType", {
    group = augroup("config.treesitter", { clear = true }),
    callback = function(ev)
        local ft = ev.match
        if enable_treesitter[ft] then
            vim.treesitter.start()
        end
    end,
})
