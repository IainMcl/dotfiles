return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim"
	},

	config = function()
		require("telescope").setup({})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
		vim.keymap.set("n", "<leader>p", builtin.git_files, {})
		vim.keymap.set("n", "<leader>pws", function()
			local word = vim.fm.expand("<cword")
			builtin.grep_string({search = word})
		end)
		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fm.expand("<cWORD")
			builtin.grep_string({search = word})
		end)
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_strin({search = vim.fn.input("Grep > ")})
		end)
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
	end
}
