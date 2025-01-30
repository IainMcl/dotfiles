return {
    {
        "github/copilot.vim",
        config = function()
            require("copilot").setup({})
        end
        -- vim.api.nvim_set_keymap('i', '^[[C', 'copilot#Accept("")', { silent = true, expr = true }),
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" },
            { "nvim-lua/popup.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        opts = {
            debug = false, -- Enable debugging
            -- See Configuration section for rest
            window = {
                width = 80,
            },
            mappings = {
                complete = {
                    detail = 'Use @<Tab> or /<Tab> for options.',
                    insert = '<Tab>',
                },
                close = {
                    normal = 'q',
                    insert = '<C-c>'
                },
                reset = {
                    normal = '<C-S-r>',
                    insert = '<C-S-r>'
                },
                submit_prompt = {
                    normal = '<CR>',
                    insert = '<C-CR>'
                },
                accept_diff = {
                    normal = '<C-y>',
                    insert = '<C-y>'
                },
                yank_diff = {
                    normal = 'gy',
                    register = '"',
                },
                show_diff = {
                    normal = 'gd'
                },
                show_info = {
                    normal = 'gp'
                },
                show_context = {
                    normal = 'gs'
                },
            },
        },
        vim.keymap.set("n", "<leader>ct", function()
            require("CopilotChat").toggle({})
        end, { desc = "Toggle [C]opilot [C]hat" }),

        vim.keymap.set("n", "<leader>cc", function()
            local input = vim.fn.input("Quick chat: ")
            if input ~= "" then
                require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
            end
        end, { desc = "Ask [C]opilot" }),

        vim.keymap.set("n", "<leader>ch", function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end, { desc = "Show [C]opilot [H]elp" }),

        vim.keymap.set("n", "<leader>cs", function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end, { desc = "Show [C]opilot [S]uggestions" }),
    },
}
