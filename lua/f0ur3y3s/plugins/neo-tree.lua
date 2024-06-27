return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
	   "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>", { noremap = true, silent = true})
        vim.keymap.set("n", "<leader>bf", "<Cmd>Neotree source=buffers position=float toggle<CR>", {noremap = true, silent = true})
    end,
}
