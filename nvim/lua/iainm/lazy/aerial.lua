return {
	"stevearc/aerial.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({})
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tv",
			"<cmd>AerialToggle<cr>",
			{ desc = "[T]ree [V]iew", noremap = true, silent = true }
		)
	end,
}
