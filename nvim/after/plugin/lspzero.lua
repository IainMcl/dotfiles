-- Uses Mason under the hood. :Mason to see all available options
-- If a file is opened that an lsp isn't isnalled for a prompt will appear
-- suggesting that one is installed.

local lsp = require('lsp-zero').preset({})

-- lsp.on_attach(function(client, bufnr)
--   lsp.default_keymaps({buffer = bufnr})
--   lsp.buffer_autoformat()
-- end)


lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})

  vim.keymap.set({'n', 'x'}, 'gq', function()
    vim.lsp.buf.format({async = false, timeout_ms = 100})
  end)
end)

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

lsp.setup()
