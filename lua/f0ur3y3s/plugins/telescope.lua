return {
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        n = {
                            ["jk"] = actions.close,
                        },

                        i = {
                            ["<leader>ff"] = actions.close,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            local builtin = require("telescope.builtin")
            local kmp = vim.keymap
            --        kmp.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
            kmp.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
            kmp.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
            kmp.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
            kmp.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer fuzzy find" })

            require("telescope").load_extension("ui-select")
        end,
    },
}
