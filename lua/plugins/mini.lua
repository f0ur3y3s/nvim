return { 
    'nvim-mini/mini.nvim', 
    version = "*",
    config = function()
        require("mini.pairs").setup()
        require("mini.ai").setup()

        -- appearance
        require("mini.icons").setup()
        require("mini.statusline").setup()
        require("mini.notify").setup()
        require("mini.trailspace").setup()
        require("mini.tabline").setup()
    end,
}
