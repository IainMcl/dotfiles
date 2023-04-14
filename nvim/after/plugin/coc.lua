vim.cmd([[ command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile') ]])
vim.api.nvim_set_keymap('n', '<leader>p', ':Prettier<CR>', {noremap = true})
