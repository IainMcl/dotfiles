return {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    keys = {
        { "<leader>sc",  "<cmd>CodeSnap<cr>",     mode = "x", desc = "Save selected code snapshot into clipboard" },
        { "<leader>css", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
    opts = {
        save_path = "~/Pictures",
        has_breadcrumbs = true,
        -- bg_theme = "grape",
        bg_color = "#1e1e2e",
        has_line_number = true,
        bg_padding = 10,
        watermark = "",
        title = "",
        mac_window_bar = false,
    },
}
