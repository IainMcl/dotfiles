require("iainm.set")
require("iainm.remap")
require("iainm.packer")


-- Big time global vim.g
-- vim.cmd([[ set mouse=a ]])

-- Global options vim.o

-- Window options vim.wo

-- Buffer options vim.bo

--

-- Keymap

-- vim.api.nvim_set_keymap({mode}, {keymap}, {mapped to}, {options})





-- vim.opt.spell = true
-- -- Map spell toggle to <leader>s
-- function toggle_spell()
--     vim.opt.spell = not(vim.opt.spell:get())
-- end
-- vim.api.nvim_set_keymap('n', '<leader>s', ':lua toggle_spell()<CR>', {noremap = true})
-- -- Spelling alias to auto select top suggestion
-- -- No idea why this needs the extra <CR>
-- vim.api.nvim_set_keymap("n", "<leader>z", "z=1<CR><CR>", {noremap = true})
