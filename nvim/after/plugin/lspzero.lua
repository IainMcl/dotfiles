-- Uses Mason under the hood. :Mason to see all available options
-- If a file is opened that an lsp isn't isnalled for a prompt will appear
-- suggesting that one is installed.
local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.setup()
