local command = vim.api.nvim_create_user_command

command("Config", "cd $nvimconfig", {})
