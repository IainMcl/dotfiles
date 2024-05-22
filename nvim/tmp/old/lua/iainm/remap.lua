local noremap = {noremap = true}
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

keymap('n', '<A-j>', ':m +1<CR>', {noremap=true, desc="Move line down"})
keymap('n', '<A-k>', ':m -2<CR>', {noremap=true, desc="Move line up"})

keymap("n", "<leader>=", ":vertical resize +10<CR>", {noremap=true, desc="Vertical size"})
keymap("n", "<leader>+", ":resize +10<CR>", {noremap=true, desc="Horizontal size"})
keymap("n", "<leader>-", ":vertical resize -10<CR>", {noremap=true, desc="Vertical size"})
keymap("n", "<leader>_", ":resize -10<CR>", {noremap = true, desc="Horizontal size"})

--[[ keymap("n", "<C-.>", "<CMD>lua vim.lsp.buf.hover()<CR>", noremap) ]]
vim.api.nvim_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap=true, desc="[G]o [Hover] show definition"})
vim.api.nvim_set_keymap("n", "<leader>h", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap=true, desc="[H]over actions"})
--[[ keymap("n", "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>", noremap) ]]
--[[ keymap("n", "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>", {xnoremap=true}) ]]

vim.cmd[[highlight ColorColumn ctermbg=0 guibg=lightgrey]]

