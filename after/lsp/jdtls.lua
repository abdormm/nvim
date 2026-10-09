local default_runtime

if vim.fn.has("win32") == 1 then
    default_runtime = {}
else
    default_runtime = {
        name = "JavaSE-27",
        path = "/usr/lib/jvm/default-runtime",
    }
end

local root_markers1 = {
    "mvnw",
    "gradlew",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
}
local root_markers2 = {
    "build.xml",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "src/",
}

---@type vim.lsp.Config
return {
    cmd = { "jdtls" },
    root_markers = { root_markers1, root_markers2 },
    ---@type lspconfig.settings.jdtls
    settings = {
        redhat = { telemetry = { enabled = false } },
        java = {
            project = {
                sourcePaths = { "src" },
            },
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
            },
        },
    },
}
