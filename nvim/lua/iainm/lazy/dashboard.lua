return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					-- {
					-- 	desc = " Apps",
					-- 	group = "DiagnosticHint",
					-- 	action = function ()
                    --         -- Telescope all dirs in ~/src 
                    --         require("telescope.builtin").file_browser({
                    --             cwd = os.getenv("HOME") .. "/src"
                    --         })
					-- 	end,
					-- 	key = "a",
					-- },
					{
						desc = " dotfiles",
						group = "Number",
						action = function ()
                            vim.cmd('Telescope find_files cwd=' .. os.getenv("HOME") .. "/dotfiles")
						end,
						key = "d",
					},
				},
				footer = {
                    "",

                },
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
