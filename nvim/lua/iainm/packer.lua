require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use {
        'junegunn/fzf', run = ":call fzf#install()"
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
            'BurntSushi/ripgrep'
        }
    }
    -- use {
        --     'lalitmee/cobalt2.nvim', requires = 'tjdevries/colorbuddy.nvim',
        --     as = 'cobalt2',
        -- }
        use{"ellisonleao/gruvbox.nvim"}
        use{
            'nvim-lualine/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true},
        }
        use 'github/copilot.vim'
        --    -- Add lsp clients here
        use {'neoclide/coc.nvim', branch = 'release'}
        use 'mhinz/vim-startify'
        use{
            "iamcco/markdown-preview.nvim",
            run = function() vim.fn["mkdp#util#install"]() end,
        }
        use 'kylechui/nvim-surround'
        use 'tpope/vim-fugitive'
        use 'folke/zen-mode.nvim'
        use 'numToStr/Comment.nvim'
        use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
        use 'mbbill/undotree'
        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v2.x',
            requires = {
                -- LSP Support
                {'neovim/nvim-lspconfig'},             -- Required
                {                                      -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }
    use {
        'akinsho/flutter-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    }
end) 

