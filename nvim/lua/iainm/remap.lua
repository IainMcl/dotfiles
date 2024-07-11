vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Buffer resize
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Equalize window sizes" })
vim.keymap.set("n", "<leader>+", "<C-w>+10", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>-", "<C-w>-10", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>_", "<C-w>_", { desc = "Maximize window height" })
vim.keymap.set("n", "<leader>\\", "<C-w>|", { desc = "Maximize window width" })
-- Horizontal resize
vim.keymap.set("n", "<leader>h", "<C-w><10", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader>l", "<C-w>>10", { desc = "Increase window width" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- terminal
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal - escape terminal mode" })

-- Obsidian
-- Loaded only if the environment variable $VAULTS_PATH exists
local vaults_path = os.getenv("VAULTS_PATH")
if vaults_path then
    vim.keymap.set("n", "<leader>on", function()
        local input = vim.fn.input("Note name: ")
        if input == nil or input == "" then
            print("Error: A file name must be set.")
            return ""
        end

        -- Format the filename
        -- local date = os.date("%Y_%m_%d")
        -- local formatted_name = date .. "_" .. string.gsub(input, " ", "_") .. ".md"
        local formatted_name = string.gsub(input, " ", "_") .. ".md"

        -- Create the new file
        local file_path = vaults_path .. "inbox/" .. formatted_name
        print("File created: " .. file_path)
        vim.cmd("edit " .. file_path)
    end, { desc = "[O]bsidian [N]ote" })
    vim.api.nvim_set_keymap('n', '<leader>oo', ':cd $VAULTS_PATH<CR>',
        { noremap = true, silent = true, desc = "[O]pen [O]bsidian" })

    vim.api.nvim_set_keymap('n', '<leader>so',
        [[<Cmd>lua local vaults_path = vim.fn.expand(os.getenv("VAULTS_PATH")); vim.cmd("Telescope find_files search_dirs=" .. vaults_path)<CR>]],
        { noremap = true, silent = true, desc = "[S]earch [O]bsidian" })

    vim.api.nvim_set_keymap('n', '<leader>sn',
        [[<Cmd>lua local vaults_path = vim.fn.expand(os.getenv("VAULTS_PATH")); vim.cmd("Telescope live_grep search_dirs=" .. vaults_path)<CR>]],
        { noremap = true, silent = true, desc = "[S]earch [N]otes" })
end
