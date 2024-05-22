require('nvim-tree').setup({
    diagnostics = {
        enable = true,
        show_on_dirs = true
    },
    auto_reload_on_write = true,
    sort_by = 'name',
    view = {
        width = 35,
    }
})
vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', {noremap = true, desc="[T]oggle nvim tree"})


