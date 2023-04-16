
vim.opt.spell = false
-- Map spell toggle to <leader>s
function toggle_spell()
    vim.opt.spell = not(vim.opt.spell:get())
end
vim.api.nvim_set_keymap('n', '<leader>s', ':lua toggle_spell()<CR>', {noremap = true})
-- Spelling alias to auto select top suggestion
-- No idea why this needs the extra <CR>
vim.api.nvim_set_keymap("n", "<leader>z", "z=1<CR><CR>", {noremap = true})
