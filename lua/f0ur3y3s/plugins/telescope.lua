return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local actions = require("telescope.actions")
        require("telescope").setup({
            defaults = {
                mappings = {
                    n = {
                        ["jk"] = actions.close
                    },

                    i = {
                        ["<leader>ff"] = actions.close
                    }
                }
            }
        })

        local kmp = vim.keymap
        kmp.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    end,
}
