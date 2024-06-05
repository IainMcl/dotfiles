return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	opts = {
		menu = {
			width = 120,
		},
	},
	config = function()
		vim.keymap.set("n", "<leader>ha", function()
			require("harpoon.mark").add_file()
			local filename = vim.fn.expand("%:t")
			vim.notify("Harpoon - " .. filename)
		end)
		vim.keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
		vim.keymap.set("n", "<leader>h1", function()
			require("harpoon.ui").nav_file(1)
		end)
		vim.keymap.set("n", "<leader>h2", function()
			require("harpoon.ui").nav_file(2)
		end)
		vim.keymap.set("n", "<leader>h3", function()
			require("harpoon.ui").nav_file(3)
		end)
		vim.keymap.set("n", "<leader>h4", function()
			require("harpoon.ui").nav_file(4)
		end)
		vim.keymap.set("n", "<leader>h5", function()
			require("harpoon.ui").nav_file(5)
		end)
		vim.keymap.set("n", "<leader>h6", function()
			require("harpoon.ui").nav_file(6)
		end)
		vim.keymap.set("n", "<leader>h7", function()
			require("harpoon.ui").nav_file(7)
		end)
		vim.keymap.set("n", "<leader>h8", function()
			require("harpoon.ui").nav_file(8)
		end)
		vim.keymap.set("n", "<leader>h9", function()
			require("harpoon.ui").nav_file(9)
		end)
	end,
}
