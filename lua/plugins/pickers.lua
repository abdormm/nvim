local function neotree_reveal(filename)
    require("neo-tree.command").execute {
        reveal_force_cwd = true,
        reveal_file = filename,
    }
end

---@type LazyPluginSpec[]
return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = true,
        cmd = "FzfLua",
        config = function()

            local function fzf_reveal(selected, opts)
                local fzf = require("fzf-lua.path")
                local info = fzf.entry_to_file(selected[1], opts, opts._uri)
                pcall(neotree_reveal, info.path)
            end

            local function fzf_copy_highlight(selected)
                if not selected or not selected[1] then return end
                local highlight = selected[1]:match("^%S+")
                vim.fn.setreg("+", highlight)
                vim.fn.setreg("*", highlight)
            end

            ---@type fzf-lua.Config|{}
            ---@diagnostic disable: missing-fields
            local opts = {
                fzf_colors = true,
                winopts = {
                    preview = { winopts = { cursorline = false } },
                    backdrop = 100,
                    on_create = function()
                        -- see :h terminal-input
                        vim.keymap.set("t", "<C-\\>", "<C-\\><C-\\>", { buf = 0 })
                    end,
                },
                keymap = {
                    builtin = {
                        true,
                        ["<C-/>"] = "toggle-help",
                        ["<M-p>"] = "toggle-preview",
                        ["<C-u>"] = "unix-line-discard",
                        ["<C-d>"] = "",
                    },
                    fzf = {
                        true,
                        ["ctrl-u"] = "unix-line-discard",
                        ["ctrl-d"] = "",
                    },
                },
                actions = {
                    files = {
                        true,
                        ["ctrl-\\"] = fzf_reveal,
                    },
                },
                highlights = {
                    actions = {
                        ["enter"] = fzf_copy_highlight,
                    },
                },
                diagnostics = {
                    "ivy",
                    winopts = { preview = { winopts = { cursorline = false } } },
                    cwd_only = true,
                },
                files = {
                    cwd_prompt = false,
                },
            }
            ---@diagnostic enable: missing-fields
            require("fzf-lua").setup(opts)
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = vim.fn.has("win32") == 1 and "mingw32-make" or "make",
            },
        },
        lazy = true,
        cmd = "Telescope",
        config = function()

            local function telescope_reveal(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if entry then
                    local filename = entry.filename or entry[1]
                    pcall(neotree_reveal, vim.fs.joinpath(entry.cwd, filename))
                end
            end

            local function telescope_copy_highlight(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if entry then vim.fn.setreg("+", entry.value) end
            end

            local enhanced_files_mappings = {
                i = {
                    ["<C-\\>"] = telescope_reveal,
                },
                n = {
                    ["<C-\\>"] = telescope_reveal,
                },
            }

            local defaults_mappings = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<Esc>"] = "close",
                ["<S-Up>"] = "preview_scrolling_up",
                ["<S-Down>"] = "preview_scrolling_down",
            }
            local debug_previewer = function(opts)
                print(vim.inspect(opts))
                return require("extras.telescope.previewer").previewer:new()
            end
            local opts = {
                defaults = {
                    -- file_previewer = debug_previewer,
                    -- qflist_previewer = debug_previewer,
                    -- grep_previewer = debug_previewer,
                    mappings = {
                        i = defaults_mappings,
                        n = defaults_mappings,
                    },
                },
                pickers = {
                    highlights = {
                        mappings = {
                            i = {
                                ["<CR>"] = telescope_copy_highlight,
                            },
                            n = {
                                ["<CR>"] = telescope_copy_highlight,
                            },
                        },
                    },
                    oldfiles = {
                        -- needed to ensure all pathes in the picker are absolute
                        -- so that telescope_reveal will work correctly
                        cwd = "/",
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }

            local file_pickers = {
                "find_files",
                "live_grep",
                "oldfiles",
                "lsp_definitions",
                "lsp_implementations",
                "lsp_references",
                "lsp_incoming_calls",
                "lsp_outgoing_calls",
            }

            for _, picker in ipairs(file_pickers) do
                opts.pickers[picker] = opts.pickers[picker] or {}
                opts.pickers[picker].mappings = enhanced_files_mappings
            end

            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension("fzf")
            local builtin = require("telescope.builtin")

            -- added for compatibility with fzf lua
            -- note that any custom config add for the new names won't be applied
            -- see $nvim_data/lazy/telescope.nvim/lua/telescope/builtin/init.lua:723
            builtin.files = builtin.find_files
            builtin.blines = builtin.current_buffer_fuzzy_find
        end,
    },
}
