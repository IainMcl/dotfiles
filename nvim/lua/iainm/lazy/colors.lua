return {
    {
        'zaldih/themery.nvim',
        config = function()
            -- Minimal config
            require("themery").setup({
                -- Themes should be installed below
                themes = {
                    "gruvbox",
                    "bamboo",
                    "tokyonight",
                    "tokyonight-night",
                    "tokyonight-storm",
                    "tokyonight-day",
                    "tokyonight-moon",
                    "catppuccin",
                    "catppuccin-latte",
                    "catppuccin-mocha",
                    "kanagawa",
                    "kanagawa-lotus",
                    "kanagawa-dragon",
                },                  -- Your list of installed colorschemes
                -- themeConfigFile = "~/.config/nvim/lua/iainm/theme.lua", -- Described below
                livePreview = true, -- Apply theme while browsing. Default to true.
            })
        end
    },
    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('bamboo').setup {
                -- optional configuration here
            }
            require('bamboo').load()
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",

        config = function()
            -- Default options:
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "",  -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("tokyonight-night")
            vim.cmd.hi("Comment gui=none")
        end,
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    "rebelot/kanagawa.nvim",
}
