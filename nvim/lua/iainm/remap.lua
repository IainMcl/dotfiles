local noremap = {noremap = true}
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

keymap('n', '<A-j>', ':m +1<CR>', noremap)
keymap('n', '<A-k>', ':m -2<CR>', noremap)

keymap("n", "<leader>=", ":vertical resize +5<CR>", noremap)
keymap("n", "<leader>+", ":resize +5<CR>", noremap)
keymap("n", "<leader>-", ":vertical resize -5<CR>", noremap)
keymap("n", "<leader>_", ":resize -5<CR>", noremap)


vim.cmd[[highlight ColorColumn ctermbg=0 guibg=lightgrey]]
