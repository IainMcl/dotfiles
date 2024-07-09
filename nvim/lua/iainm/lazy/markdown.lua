return {
    "OXY2DEV/markview.nvim",

    -- lazy = true,
    dependencies = {
        -- You may not need this if you don't lazy load
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",

        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("markview").setup({
            --     block_quotes = {
            --         enable = true,
            --         callouts = {
            --             match_string = "SUCCESS",
            --             aliases = { "CHECK", "DONE" },
            --             border = "▋",
            --             border_hl = "rainbow4",
            --             callout_preview = "✓ Success",
            --             callout_preview_hl = "rainbow4",
            --             custom_title = true,
            --             custom_icon = "✓ "
            --         }
            --     },
            --
        })
    end
}
