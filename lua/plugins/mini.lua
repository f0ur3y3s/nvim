return {
    'nvim-mini/mini.nvim',
    version = "*",
    config = function()
        require("mini.pairs").setup()
        require("mini.ai").setup()
        require("mini.files").setup()

        -- appearance
        require("mini.icons").setup()
        require("mini.statusline").setup()
        require("mini.notify").setup()
        require("mini.trailspace").setup({
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function()
                    MiniTrailspace.trim()
                end,
            }),

            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = "*:n",  -- Any mode to normal mode
                callback = function()
                    MiniTrailspace.trim()
                end,
            })
        })
        require("mini.tabline").setup()
        require("mini.cursorword").setup()
    end,
}
