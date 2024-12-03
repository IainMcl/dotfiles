return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
			local gitsigns = require("gitsigns")
			vim.keymap.set("n", "<leader>hg", gitsigns.preview_hunk, { desc = "[H]unk [G]et - Preview hunk" })
			vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [S]tage" })
			vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset" })
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"tpope/vim-rhubarb",
		-- 	config = function()
		-- 		local function gbrowse_and_copy()
		-- 			local mode = vim.fn.mode()
		-- 			if mode == "v" or mode == "V" or mode == "\22" then
		-- 				vim.cmd("'<,'>GBrowse")
		-- 			else
		-- 				vim.cmd("GBrowse!")
		-- 			end
		-- 			local clipboard_content = vim.fn.getreg('"')
		-- 			vim.fn.setreg("+", clipboard_content)
		-- 			print("Copied to clipboard: " .. clipboard_content)
		-- 		end
		--
		-- 		vim.api.nvim_create_user_command("GBrowseAndCopy", gbrowse_and_copy, { range = true, nargs = "*" })
		-- 		vim.keymap.set(
		-- 			"n",
		-- 			"<leader>gb",
		-- 			gbrowse_and_copy,
		-- 			{ noremap = true, silent = true, desc = "Browse and copy [G]it [B]rowse" }
		-- 		)
		-- 		vim.keymap.set(
		-- 			"v",
		-- 			"<leader>gb",
		-- 			gbrowse_and_copy,
		-- 			{ noremap = true, silent = true, desc = "Browse and copy [G]it [B]rowse" }
		-- 		)
		-- 	end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
