return {
    "Mofiqul/vscode.nvim",
    config = function()
        vim.o.background = 'dark'
        require("vscode").setup({
            -- transparent = true,
            italic_comments = true,
            disable_nvimtree_bg = true,
            vim.cmd([[colorscheme vscode]]),
        })
        -- "vague2k/vague.nvim",
        -- config = function()
        --     require("vague").setup({
        --         vim.cmd([[colorscheme vague]]),
        --         transparent = true,
        --     })

        --         vim.cmd([[
        --   highlight Normal guibg=none
        --   highlight NonText guibg=none
        --   highlight Normal ctermbg=none
        --   highlight NonText ctermbg=none
        -- ]])
    end,
}
