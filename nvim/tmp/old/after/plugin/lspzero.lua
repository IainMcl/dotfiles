-- Uses Mason under the hood. :Mason to see all available options
-- If a file is opened that an lsp isn't isnalled for a prompt will appear
-- suggesting that one is installed.

local lsp = require('lsp-zero').preset({})

-- lsp.on_attach(function(client, bufnr)
--   lsp.default_keymaps({buffer = bufnr})
--   lsp.buffer_autoformat()
-- end)

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
cmp.setup({
    mapping = {
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
    },
})

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    vim.keymap.set({ 'n', 'x' }, 'gq', function()
        vim.lsp.buf.format({ async = false, timeout_ms = 100 })
    end, {desc="[G]et [Q]uality, Format code"})
end)

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp.setup()
