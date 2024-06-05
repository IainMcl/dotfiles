return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = function(_, opts)
		-- Other blank line configuration here
		return require("indent-rainbowline").make_opts(opts)
	end,
	dependencies = {
		"TheGLander/indent-rainbowline.nvim",
	},
}
