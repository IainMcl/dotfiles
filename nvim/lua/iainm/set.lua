-- vim.opt.guicursor = ""

vim.opt.mouse = "a"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.cmd([[
  autocmd BufRead,BufNewFile *.jsx setfiletype javascriptreact
  autocmd BufRead,BufNewFile *.tsx setfiletype typescriptreact
]])

vim.cmd([[
  autocmd FileType python setlocal tabstop=4 shiftwidth=4
  autocmd FileType javascript setlocal tabstop=2 shiftwidth=2
  autocmd FileType javascriptreact setlocal tabstop=2 shiftwidth=2
  autocmd FileType typescriptreact setlocal tabstop=2 shiftwidth=2
]])

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.showmode = false

vim.opt.clipboard:append("unnamedplus")

vim.opt.breakindent = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.inccommand = "split"
vim.opt.cursorline = true

-- Spell checking
vim.opt.spell = true
vim.opt.spelllang = "en"

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- Obsidian conceal level for obsidian plugin
vim.o.conceallevel = 2
