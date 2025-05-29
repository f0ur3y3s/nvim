return {
    "Mofiqul/vscode.nvim",
    config = function()
        vim.o.background = 'dark'
        require("vscode").setup({
            -- transparent = true,
            italic_comments = true,
            disable_nvimtree_bg = true,
        })
        vim.cmd([[colorscheme vscode]])
    end,
}
