require("iainm.set")
require("iainm.remap")
require("iainm.packer")

    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
