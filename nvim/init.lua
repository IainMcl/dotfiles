local keymap = vim.api.nvim_set_keymap
local noremap = {noremap = true}

-- Big time global vim.g
vim.g.mapleader = ' '
vim.cmd([[ set mouse=a ]])

-- Global options vim.o
vim.o.number = true
vim.o.relativenumber = true
vim.o.smarttab = true

-- Window options vim.wo
vim.wo.cursorline = true

-- Buffer options vim.bo
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- Packages
-- PackerSync
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use {
            'junegunn/fzf', run = ":call fzf#install()"
        }
    use {
            'junegunn/fzf.vim',
            config = function()
                vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', {noremap = true})
            end
        }
    use {
       'kyazdani42/nvim-tree.lua',
       requires = {
         'kyazdani42/nvim-web-devicons', -- optional, for file icons
       },
       tag = 'nightly', -- optional, updated every week. (see issue #1193)
       config = function()
           require('nvim-tree').setup()
           vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', {noremap = true})
       end
   }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
            'BurntSushi/ripgrep'
        }
    }
    use {
        'lalitmee/cobalt2.nvim', requires = 'tjdevries/colorbuddy.nvim',
        config = function()
            require('colorbuddy').colorscheme('cobalt2')
        end
    }
    use{
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            require('lualine').setup()
        end
    }
    use 'github/copilot.vim'
    -- Add lsp clients here
    use {
        'neoclide/coc.nvim', branch = 'release',
        config = function()
		vim.cmd([[ command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile') ]])
		vim.api.nvim_set_keymap('n', '<leader>p', ':Prettier<CR>', {noremap = true})
        end
    }
    use { 'mhinz/vim-startify' }
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })
    use 'tpope/vim-fugitive'
end) 

-- Keymap

-- vim.api.nvim_set_keymap({mode}, {keymap}, {mapped to}, {options})


keymap('n', '<A-j>', ':m +1<CR>', noremap)
keymap('n', '<A-k>', ':m -2<CR>', noremap)

keymap("n", "<leader>=", ":vertical resize +5<CR>", noremap)
keymap("n", "<leader>+", ":resize +5<CR>", noremap)
keymap("n", "<leader>-", ":vertical resize -5<CR>", noremap)
keymap("n", "<leader>_", ":resize -5<CR>", noremap)


vim.wo.colorcolumn = '80'
vim.cmd[[highlight ColorColumn ctermbg=0 guibg=#666666]]

vim.opt.spell = true
-- Map spell toggle to <leader>s
function toggle_spell()
    vim.opt.spell = not(vim.opt.spell:get())
end
vim.api.nvim_set_keymap('n', '<leader>s', ':lua toggle_spell()<CR>', noremap)
-- Spelling alias to auto select top suggestion
-- No idea why this needs the extra <CR>
keymap("n", "<leader>z", "z=1<CR><CR>", noremap)
