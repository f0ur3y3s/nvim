return {
    "NStefan002/donut.nvim",
    version = "*",
    lazy = false,
    config = function()
        require("donut").setup({
            timeout = 300,
            sync_donuts = true,
        })
    end,
}
