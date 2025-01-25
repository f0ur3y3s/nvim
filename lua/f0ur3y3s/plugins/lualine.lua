return {
    { "archibate/lualine-time" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "archibate/lualine-time" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics", "filename" },
                    lualine_c = { "%=", { "ctime", separator = { left = "|" } } },
                    lualine_x = { "cdate" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = { "filename" },
                    lualine_c = {},
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },
}
