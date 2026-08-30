local default_runtime

if vim.fn.has("win32") == 1 then
    default_runtime = {}
else
    default_runtime = {
        name = "JavaSE-26",
        path = "/usr/lib/jvm/default-runtime/",
    }
end

---@type vim.lsp.Config
return {
    cmd = { "jdtls" },
    root_dir = require("util.lsp").cwd_root_dir,
    init_options = {
        -- bundles = vim.fn.glob("~/tools/java/sts4/extension/jars/*.jar", false, true),
        -- bundles = {}
    },
    ---@type lspconfig.settings.jdtls
    settings = {
        redhat = { telemetry = { enabled = false } },
        java = {
            format = {
                enabled = true,
                comments = {
                    enabled = true,
                },
                onType = {
                    enabled = true,
                },
            },
            configuration = {
                runtimes = {
                    default_runtime,
                },
            }
        }
    },
}
