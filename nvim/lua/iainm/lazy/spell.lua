vim.opt.spell = true
-- Map spell toggle to <leader>s
function toggle_spell()
	vim.opt.spell = not (vim.opt.spell:get())
end
vim.api.nvim_set_keymap(
	"n",
	"<leader>ss",
	":lua toggle_spell()<CR>",
	{ noremap = true, desc = "Toggle [S]pell checking" }
)
-- Spelling alias to auto select top suggestion
-- No idea why this needs the extra <CR>
vim.api.nvim_set_keymap("n", "<leader>z", "z=1<CR><CR>", { noremap = true, desc = "Add word to dictionary" })
return {}
-- return {
-- 	config = function()
-- 		-- Toggle spell checking
-- 		vim.api.nvim_set_keymap("n", "<leader>ts", ":set spell!<CR>", { noremap = true, silent = true })
--
-- 		-- Set spell language to English
-- 		vim.api.nvim_set_keymap("n", "<leader>se", ":set spelllang=en<CR>", { noremap = true, silent = true })
-- 	end,
-- }
