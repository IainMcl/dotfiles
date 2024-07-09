return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },

        config = function()
            -- key maps
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
            vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "[G]et [H]over" })
            vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "[G]oto [T]ype definition" })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "[G]oto [R]eferences" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
            vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

            local cmp = require("cmp")
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            require("fidget").setup({})
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    -- "gopls",
                    "pylsp",
                },
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    runtime = { version = "Lua 5.1" },
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    },
                                },
                            },
                        })
                    end,

                    ["pylsp"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.pylsp.setup({
                            settings = {
                                pylsp = {
                                    plugins = {
                                        -- Formatter options
                                        black = { enabled = true },
                                        autopep8 = { enabled = true },
                                        -- linter options
                                        pylint = { enabled = true, executable = "pylint" },
                                        pyflakes = { enabled = false },
                                        pycodestyle = { enabled = false },
                                        -- type checker
                                        pylsp_mypy = { enabled = true },
                                        -- auto-completion options
                                        jedi_completion = { fuzzy = true },
                                        -- import sorting
                                        pyls_isort = { enabled = true },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "black",
                    "debugpy",
                    "flake8",
                    "isort",
                    "mypy",
                    "pylint",
                },
            })
            vim.api.nvim_command("MasonToolsInstall")

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<TAB>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
                    -- ["<CR>"] = cmp.mapping.cmp.mapping.confirm({ select = true }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                }, {
                    { name = "buffer" },
                }),
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end,
    },
    -- {
    -- 	"fisadev/vim-isort", -- Import sorting for python
    -- 	ft = "python",
    -- 	config = function()
    -- 		vim.g.cim_isort_map = ""
    --
    -- 		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    -- 			pattern = "*.py",
    -- 			callback = function()
    -- 				vim.cmd("Isort")
    -- 			end,
    -- 		})
    -- 	end,
    -- },
    {
        "mfussenegger/nvim-lint",
        event = "BufWritePost",

        config = function()
            require("lint").linters_by_ft = {
                python = {
                    "flake8",
                    "mypy",
                    "pylint",
                },
            }

            -- Automatically run linters after saving
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                pattern = { "*.py" },
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
