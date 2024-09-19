local function copy_file_path_to_clipboard()
	-- :echo expand('%:~:.')
	local file_path = vim.fn.expand("%:~:.")
	vim.fn.setreg("+", file_path)
	print("Copied to clipboard: " .. file_path)
end

vim.keymap.set(
	"n",
	"<leader>gf",
	copy_file_path_to_clipboard,
	{ desc = "[G]et [F]ile path", noremap = true, silent = true }
)
