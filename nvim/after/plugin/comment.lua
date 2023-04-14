require('Comment').setup({
    padding = true,
    -- toggler = {
    --     line = '<C-/>',
    --     block = '<C-/>',
    -- },
    toggler = {
        line = "gc",
        block = "gc"
     }, 
     pre_hok = nil,
     post_hook = nil,
    -- pre_hook = function()
    --     print("This is my pre hook")
    -- end,
    -- post_hook = function()
    --     print("this is my post hook")
    -- end
})

