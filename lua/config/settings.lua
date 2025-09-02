vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set hidden")
vim.cmd("set nobackup")
vim.cmd("set noswapfile")
vim.cmd("set nowritebackup")
vim.cmd("set expandtab")
vim.cmd("set tabstop=5")
vim.cmd("set shiftwidth=4")
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set signcolumn=auto")
vim.cmd("set foldcolumn=0")
vim.cmd("set foldmethod=marker")

local kmp = vim.keymap

-- Basics
kmp.set("i", "jk", "<Esc>")
kmp.set("n", "<Tab>", ">>")
kmp.set("n", "<S-Tab>", "<<")

-- Resize functions
kmp.set("n", "<M-,>", "<c-w>5<")
kmp.set("n", "<M-.>", "<c-w>5>")
kmp.set("n", "<M-t>", "<c-w>+")
kmp.set("n", "<M-s>", "<c-w>-")

-- Buffer navigation
kmp.set("n", "<M-S-h>", ":bprev<CR>", { silent = true })
kmp.set("n", "<M-S-l>", ":bnext<CR>", { silent = true })

-- Window navigation
kmp.set("n", "<c-h>", "<c-w><c-h>")
kmp.set("n", "<c-j>", "<c-w><c-j>")
kmp.set("n", "<c-k>", "<c-w><c-k>")
kmp.set("n", "<c-l>", "<c-w><c-l>")

-- Terminal functions
kmp.set("t", "jk", "<c-\\><c-n>")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
	end,
})

-- Quickfix
kmp.set("n", "<M-j>", "<cmd>cnext<CR>", { silent = true })
kmp.set("n", "<M-k>", "<cmd>cprev<CR>", { silent = true })

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrwSettings = 1
-- vim.g.loaded_netrwFileHandlers = 1
