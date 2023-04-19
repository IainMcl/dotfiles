-- Check if Packer is installed
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

-- If Packer is not installed, install it
if not packer_exists then
    local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
        vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
        vim.cmd 'packadd packer.nvim'
    end
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    ---------------------------------------------------------------------------
    -- File finding
    ---------------------------------------------------------------------------
    use { 'junegunn/fzf', run = ":call fzf#install()" }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly',                    -- optional, updated every week. (see issue #1193)
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
            'BurntSushi/ripgrep'
        }
    }
    use { "LinArcX/telescope-command-palette.nvim" }

    ---------------------------------------------------------------------------
    -- Color Schemes
    ---------------------------------------------------------------------------

    --[[ use{"ellisonleao/gruvbox.nvim"} ]]
    use { 'lalitmee/cobalt2.nvim', requires = 'tjdevries/colorbuddy.nvim' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }


    ---------------------------------------------------------------------------
    -- LSP
    ---------------------------------------------------------------------------

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                                       -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },   -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },   -- Required
        }
    }
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-dap-python'
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use "ray-x/lsp_signature.nvim"
    use {
        'akinsho/flutter-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    }
    use { -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    }
    ---------------------------------------------------------------------------
    -- Copilot
    ---------------------------------------------------------------------------
    use 'github/copilot.vim'

    ---------------------------------------------------------------------------
    -- Text editing
    ---------------------------------------------------------------------------
    use 'kylechui/nvim-surround'
    use 'numToStr/Comment.nvim'
    use 'mbbill/undotree'
    use { -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    }
    use 'jiangmiao/auto-pairs'
    use 'luochen1990/rainbow'
    ---------------------------------------------------------------------------
    -- MISC
    ---------------------------------------------------------------------------
    use 'mhinz/vim-startify'
    use {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    }
    use 'tpope/vim-fugitive'
    use 'folke/zen-mode.nvim'
    use {  -- Adds git releated signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    }
    use "akinsho/toggleterm.nvim"
end)
