vim.diagnostic.config {
    severity_sort = true,
    signs = {
        text = {
            -- [vim.diagnostic.severity.ERROR] = "",
            -- [vim.diagnostic.severity.WARN] = "",
            -- [vim.diagnostic.severity.INFO] = "",
            -- [vim.diagnostic.severity.HINT] = "󰌵",
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
        },
    },
    virtual_text = {
        prefix = "▪",
    },
}

-- TODO: investigate using the handler directly instead of relying on LspProgress
-- autocmd
-- vim.lsp.handlers["$/progress"] = function (...)
--     print(vim.inspect({...}))
-- end
vim.lsp.config("*", { reuse_client = require("util.lsp").reuse_client_enhanced })

vim.lsp.enable {
    "lua_ls",
    "basedpyright",
    "clangd",
    "jdtls",
    "vtsls",
    "jsonls",
    "yamlls",
    "lemminx",
    "qmlls",
}

vim.treesitter.language.register("bash", "sh")
