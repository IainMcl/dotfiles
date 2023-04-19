--[[ local dap = require('dap') ]]
local status_ok, dap = pcall(require, "dap")
if not status_ok then
    return
end

-- -- Keybindings to toggle breakpoints
vim.api.nvim_set_keymap('n', '<leader>b', ':lua require"dap".toggle_breakpoint()<CR>', {desc="[B]reakpoint toggle"})
vim.api.nvim_set_keymap('n', '<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', {desc="[B]reakpoint set"})
vim.api.nvim_set_keymap('n', '<leader>r', ':lua require"dap".repl.open()<CR>', {desc="Debug [R]epl open"})
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require"dap".run_last()<CR>', {desc="[D]ebug [R]un [L]ast"})

-- To use the virtual text debugger
vim.api.nvim_set_keymap('n', '<leader>n', ':lua require"dap".continue()<CR>', {desc="Debug [N]ext/Start debugger"})
vim.api.nvim_set_keymap('n', '<leader>s', ':lua require"dap".step_over()<CR>', {desc="Debug [S]tep over"})
vim.api.nvim_set_keymap('n', '<leader>i', ':lua require"dap".step_into()<CR>', {desc="Debug Step [I]nto"})
vim.api.nvim_set_keymap('n', '<leader>o', ':lua require"dap".step_out()<CR>', {desc="Debug Step [O]ut"})

local dapui = require("dapui")

dapui.setup({
    -- icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    -- mappings = {
    --     -- Use a table to apply multiple mappings
    --     expand = { "<CR>", "<2-LeftMouse>" },
    --     open = "o",
    --     remove = "d",
    --     edit = "e",
    --     repl = "r",
    --     toggle = "t",
    -- },
    -- -- Use this to override mappings for specific elements
    -- element_mappings = {
    --     -- Example:
    --     -- stacks = {
    --     --   open = "<CR>",
    --     --   expand = "o",
    --     -- }
    -- },
    -- -- Expand lines larger than the window
    -- -- Requires >= 0.7
    -- expand_lines = vim.fn.has("nvim-0.7") == 1,
    -- -- Layouts define sections of the screen to place windows.
    -- -- The position can be "left", "right", "top" or "bottom".
    -- -- The size specifies the height/width depending on position. It can be an Int
    -- -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
    -- -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
    -- -- Elements are the elements shown in the layout (in order).
    -- -- Layouts are opened in order so that earlier layouts take priority in window sizing.
    -- layouts = {
    --     {
    --         elements = {
    --             -- Elements can be strings or table with id and size keys.
    --             { id = "scopes", size = 0.25 },
    --             "breakpoints",
    --             "stacks",
    --             "watches",
    --         },
    --         size = 40, -- 40 columns
    --         position = "left",
    --     },
    --     {
    --         elements = {
    --             "repl",
    --             "console",
    --         },
    --         size = 0.25, -- 25% of total lines
    --         position = "bottom",
    --     },
    -- },
    -- controls = {
    --     -- Requires Neovim nightly (or 0.8 when released)
    --     enabled = true,
    --     -- Display controls in this element
    --     element = "repl",
    --     icons = {
    --         pause = "",
    --         play = "",
    --         step_into = "",
    --         step_over = "",
    --         step_out = "",
    --         step_back = "",
    --         run_last = "↻",
    --         terminate = "□",
    --     },
    -- },
    -- floating = {
    --     max_height = nil, -- These can be integers or a float between 0 and 1.
    --     max_width = nil, -- Floats will be treated as percentage of your screen.
    --     border = "single", -- Border style. Can be "single", "double" or "rounded"
    --     mappings = {
    --         close = { "q", "<Esc>" },
    --     },
    -- },
    -- windows = { indent = 1 },
    -- render = {
    --     max_type_length = nil, -- Can be integer or nil.
    --     max_value_lines = 100, -- Can be integer or nil.
    -- }
})


dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Set better icons
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })
