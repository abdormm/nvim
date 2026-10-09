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
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function (...)
                -- to load fzf-lua which will register its ui_select
                require("fzf-lua")
                -- call it again after fzf-lua has registered its function
                vim.ui.select(...)
            end
        end,
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
            local opts = {
                fzf_colors = true,
                winopts = {
                    ---@diagnostic disable-next-line: missing-fields
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
                        ["ctrl-d"] = "",
                        ["ctrl-q"] = "select-all+accept",
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
                ui_select = function(ui_opts, items)
                    local is_codeaction = ui_opts.kind == "codeaction"
                    local has_preview = ui_opts.preview_item ~= nil or is_codeaction
                    local height_percent = is_codeaction and 0.8 or 0.4
                    local get_height = function()
                        local max_height = vim.o.lines - vim.o.cmdheight
                        local paddings = 4 -- for the 3 borders and the prompt
                        local compact_height = #items + paddings
                        local full_height = math.floor(max_height * height_percent)
                        local height = compact_height
                        if compact_height > full_height then
                            height = height_percent
                        end
                        return height
                    end
                    -- TODO: handle when VimResized
                    local on_create = function()
                        local fzfwin = FzfLua.win.__SELF()
                        local old_fn = fzfwin.toggle_preview
                        fzfwin.toggle_preview = function(self)
                            if self.preview_hidden then
                                self._o.winopts.height = height_percent
                            else
                                self._o.winopts.height = get_height()
                            end
                            old_fn(self)
                        end
                    end

                    return {
                        winopts = {
                            row = 0.5,
                            col = 0.5,
                            width = 0.4,
                            height = get_height(),
                            preview = {
                                hidden = true,
                                title = false,
                            },
                            on_create = has_preview and on_create or nil,
                        },
                    }
                end,
            }
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
