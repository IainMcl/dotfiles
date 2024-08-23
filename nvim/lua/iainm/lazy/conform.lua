return {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
        {
            "<leader>f",
            function()
                vim.notify("Formatting buffer", "Title")
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },

    config = function()
        require("conform").setup({
            notify_on_error = true,
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    vim.notify("Autoformat-on-save disabled for this buffer", "WarningMsg")
                    return
                end
                local disable_filetypes = { c = true, cpp = true, md = true }
                vim.notify("Autoformatting buffer", "Title")
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                python = function(bufnr)
                    if require("conform").get_formatter_info("ruff_format", bufnr).available then
                        return { "ruff_format" }
                    else
                        return { "isort", "black" }
                    end
                end,
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                javascript = { { "prettierd", "prettier" } },
                go = { "goimports", "gofmt" },
                -- ["*"] = { "codespell" },
                ["_"] = { "trim_whitespace" },
            },

        })
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disabel autoformat-on-save",
            bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Enable autoformat-on-save",
        })
    end
}
