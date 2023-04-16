local status_ok, toggleterm = pcall(require, "toggleterm")

if not status_ok then
    return
end

toggleterm.setup({
     size = 20,
    -- open_mapping = [[<C-\>]],
    open_mapping = [[<C-\>]],
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = 'curved',
        winblend = 0
    }
})

function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
    print("toggle lazygit")
    lazygit:toggle()
end

vim.api.nvim_set_keymap('n', '<leader>lg' ,':lua _LAZYGIT_TOGGLE() <CR>', {noremap = true})
