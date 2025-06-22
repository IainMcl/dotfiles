-- Command that takes a visual selection and formats it using
-- `!fmt -w 80 -s` command.

local function format_lines_command()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    local range = string.format("%d,%d", start_line, end_line)
    local command = string.format(":%s!fmt -w 80 -s", range)

    vim.cmd(command)
end

vim.keymap.set(
    "v",
    "<leader>fl",
    format_lines_command,
    { desc = "[F]ormat [L]ines", noremap = true, silent = true }
)
