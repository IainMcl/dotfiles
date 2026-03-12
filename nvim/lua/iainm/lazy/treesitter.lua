return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
                "javascript",
                "typescript",
                "lua",
                "python",
                "jsdoc",
                "markdown",
                "markdown_inline",
                "jsonc",
            },
            sync_install = false,
            auto_install = true,
        })

        vim.treesitter.language.register("templ", "templ")
    end,
}
