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
                        i = {
                            ["<C-c>"] = actions.close,
                            ["<C-x>"] = actions.delete_buffer,
                            ["jk"] = actions.close,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            require("telescope").load_extension("ui-select")
            -- Removed all keybind setups - now in which-key
        end,
    },
}
