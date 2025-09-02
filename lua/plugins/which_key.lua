return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")

        wk.setup({
            preset = "helix",
        })

        -- {{{ BASICS
        wk.add({
            { "<A-j>", ":m .+1<CR>==", desc = "Move line down" },
            { "<A-k>", ":m .-2<CR>==", desc = "Move line up" },
            { "<A-j>", ":m '>+1<CR>gv=gv", desc = "Move selection down", mode = "v" },
            { "<A-k>", ":m '<-2<CR>gv=gv", desc = "Move selection up", mode = "v" },
        })
        -- }}}

    end,
}
