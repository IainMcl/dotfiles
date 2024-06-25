-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
    -- NOTE: Yes, you can install new plugins here!
    "mfussenegger/nvim-dap",
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        "rcarriga/nvim-dap-ui",

        -- Required dependency for nvim-dap-ui
        "nvim-neotest/nvim-nio",

        -- Installs the debug adapters for you
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",

        -- Add your own debuggers here
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
        "mxsdev/nvim-dap-vscode-js"
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                "delve",
                "chrome-debug-adapter",
                "firefox-debug-adapter",
                "debugpy"
            },
        })

        -- Basic debugging keymaps, feel free to change to your liking!
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
        vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Set Breakpoint" })
        vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle [B]reakpoint" })
        vim.keymap.set("n", "<leader>bl", function()
            local input = vim.fn.input("Log point message: ")
            if input ~= "" then
                require("dap").set_breakpoint(nil, nil, input)
            end
        end, { desc = "[B]reakpoint [L]og" })
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[D]ebug [C]ontinue" })
        vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[D]ebug step [O]ver" })
        vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ebug step [I]nto" })
        vim.keymap.set("n", "<leader>doo", dap.step_out, { desc = "[D]ebug step [O]ut [O]f" })
        vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "[D]ebug UI [T]oggle" })
        vim.keymap.set("n", "<leader>dd", function()
            vim.notify("Ending dap session")
            require("dap").disconnect()
            require("dapui").close()
        end, { desc = "[D]ebug [D]isconnect" })
        vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "[D]ebug [R]epl toggle" })

        -----------
        --- Custom dap styling
        -----------
        -- vim.fn.sign_define('DapBreakpoint', { text = '•', texthl = 'red', linehl = '', numhl = '' })
        -- local set_namespace = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
        -- local namespace = vim.api.nvim_create_namespace("dap-hlng")
        -- vim.api.nvim_set_hl(namespace, 'DapBreakpoint', { fg = '#eaeaeb', bg = '#ffffff' })
        -- vim.api.nvim_set_hl(namespace, 'DapLogPoint', { fg = '#eaeaeb', bg = '#ffffff' })
        -- vim.api.nvim_set_hl(namespace, 'DapStopped', { fg = '#eaeaeb', bg = '#ffffff' })
        --
        vim.fn.sign_define('DapBreakpoint',
            { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointCondition',
            { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointRejected',
            { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
        vim.fn.sign_define('DapLogPoint', {
            text = '',
            texthl = 'DapLogPoint',
            linehl = 'DapLogPoint',
            numhl =
            'DapLogPoint'
        })
        vim.fn.sign_define('DapStopped',
            { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup({
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "",
                    play = "▶",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "",
                    terminate = "",
                    disconnect = "",
                },
            },
        })

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        -- Install golang specific config
        require("dap-go").setup({
            delve = {
                -- On Windows delve must be run attached or it crashes.
                -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
                detached = vim.fn.has("win32") == 0,
            },
        })

        require("dap-vscode-js").setup({
            debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug",
            adapters = {
                "chrome",
                "pwa-node",
                "pwa-chrome",
                "pwa-msedge",
                "node-terminal",
                "pwa-extensionHost",
                "node",
                "chrome"
            }
        })

        require("dap-python").setup("python3")
    end,
}
