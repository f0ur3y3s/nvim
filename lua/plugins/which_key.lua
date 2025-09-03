return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")

        wk.setup({
            preset = "helix",
        })

        local minifiles_toggle = function(...)
            if not MiniFiles.close() then MiniFiles.open(...) end
        end

        --- {{{ BASICS
        wk.add({
            { "<A-j>", ":m .+1<CR>==", desc = "Move line down" },
            { "<A-k>", ":m .-2<CR>==", desc = "Move line up" },
            { "<A-j>", ":m '>+1<CR>gv=gv", desc = "Move selection down", mode = "v" },
            { "<A-k>", ":m '<-2<CR>gv=gv", desc = "Move selection up", mode = "v" },
            { "<C-u>", "<C-u>zz", desc = "Page Up (centered)" },
            { "<C-d>", "<C-d>zz", desc = "Page Down (centered)" },
        })
        --- }}}

        --- MINI CONFIG
        wk.add({
            { "<leader>e", minifiles_toggle, desc = "Opens file explorer" },
            { "<leader>tw", "<cmd>lua MiniTrailspace.trim()<cr>", desc = "Trim trailing whitespace" },
        })

        wk.add({
            { "<leader>L", "<cmd>Lazy<cr>", desc = "Open Lazy"}
        })

    end,
}
