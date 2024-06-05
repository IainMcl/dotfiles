return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		require("telescope").setup({})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Search in all [P]roject [F]iles" })
		vim.keymap.set("n", "<leader>p", builtin.git_files, { desc = "Search [P]roject git files" })
		-- vim.keymap.set("n", "<leader>pws", function()
		-- 	local word = vim.fm.expand("<cword")
		-- 	builtin.grep_string({ search = word })
		-- end)
		-- vim.keymap.set("n", "<leader>pWs", function()
		-- 	local word = vim.fm.expand("<cWORD")
		-- 	builtin.grep_string({ search = word })
		-- end)
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set(
			"n",
			"<leader>sw",
			require("telescope.builtin").grep_string,
			{ desc = "[S]earch current [W]ord" }
		)
		vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set(
			"n",
			"<leader>sb",
			require("telescope.builtin").buffers,
			{ desc = "[S]earch [B]uffers Find existing buffers" }
		)
		vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sm", require("telescope.builtin").marks, { desc = "[S]earch [M]arks" })
		vim.keymap.set("n", "<leader>so", require("telescope.builtin").oldfiles, { desc = "[S]earch [O]ld files" })
	end,
}
