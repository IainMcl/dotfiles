return {
	config = function()
		-- Toggle spell checking
		vim.api.nvim_set_keymap("n", "<leader>ts", ":set spell!<CR>", { noremap = true, silent = true })

		-- Set spell language to English
		vim.api.nvim_set_keymap("n", "<leader>se", ":set spelllang=en<CR>", { noremap = true, silent = true })
	end,
}
