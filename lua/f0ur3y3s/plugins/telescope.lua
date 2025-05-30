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
                            ["<leader>fc"] = actions.close,
                            ["<leader>db"] = actions.delete_buffer,
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
            require("telescope").load_extension("ui-select")
        end,
    },
}
