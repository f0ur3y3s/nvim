return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "v0.2.2", -- 0.1.8 hits a known bug: preview highlighting calls
        -- nvim-treesitter's removed ft_to_lang; fixed in v0.2.0, which also
        -- dropped the nvim-treesitter dependency for previews entirely
        cmd = "Telescope",
        -- moved ui-select here (was a separate top-level spec with no
        -- trigger of its own, so it loaded eagerly at startup)
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
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
        end,
    },
}
