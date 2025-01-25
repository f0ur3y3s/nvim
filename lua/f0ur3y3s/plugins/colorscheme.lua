return {
    "vague2k/vague.nvim",
    config = function()
        require("vague").setup({
            vim.cmd([[colorscheme vague]]),
            transparent = true,
        })

--         vim.cmd([[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]])
    end,
}
