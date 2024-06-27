return {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
        transparent_background = true,
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end,
}
