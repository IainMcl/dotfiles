return {
    {
        "github/copilot.vim",
        -- vim.api.nvim_set_keymap('i', '^[[C', 'copilot#Accept("")', { silent = true, expr = true }),
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" },
            { "nvim-lua/popup.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        opts = {
            debug = true, -- Enable debugging
            -- See Configuration section for rest
            window = {
                width = 80,
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
