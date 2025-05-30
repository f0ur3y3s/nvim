return {
    "rmagatti/auto-session",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    config = function()
        require("auto-session").setup({
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            session_lens = {
                previewer = false,
            }
        })

        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
}
