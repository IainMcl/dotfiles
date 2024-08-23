return {
    "nvim-lualine/lualine.nvim",
    dependancies = {
        "nvim-tree/nvim-web-devicons",
        -- "folke/trouble.nvim",
    },
    -- opts = function(_, opts)
    -- 	local trouble = require("trouble")
    -- 	local symbols = trouble.statusline({
    -- 		mode = "lsp_document_symbols",
    -- 		groups = {},
    -- 		title = false,
    -- 		filter = { range = true },
    -- 		format = "{kind_icon}{symbol.name:Normal}",
    -- 		-- The following line is needed to fix the background color
    -- 		-- Set it to the lualine section you want to use
    -- 		hl_group = "lualine_c_normal",
    -- 	})
    -- 	table.insert(opts.sections.lualine_c, {
    -- 		symbols.get,
    -- 		cond = symbols.has,
    -- 	})
    -- end,
    config = function()
        -- Example custom function
        -- local function hello()
        --     return [[Hello world]]
        -- end
        -- lualine_c = { hello },
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "/", right = "" },
                section_separators = { left = "█", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {},
                lualine_x = { { "filename", path = 1 } },
                lualine_y = { "filetype" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
    end,
}
