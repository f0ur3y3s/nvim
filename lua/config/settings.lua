local vo = vim.opt

vo.number = true
vo.relativenumber = true
vo.hidden = true
vo.backup = false
vo.swapfile = false
vo.writebackup = false
vo.expandtab = true
vo.tabstop = 4
vo.shiftwidth = 4
vo.softtabstop = 4
vo.clipboard = "unnamedplus"
vo.signcolumn = "yes"
vo.foldcolumn = "0"
vo.foldmethod = "marker"
vo.list = true
vo.listchars = {
	tab = "▸ ", -- Show tabs as ▸ followed by spaces
	trail = "·", -- Show trailing spaces as dots
	extends = "❯", -- Show when line extends beyond screen
	precedes = "❮", -- Show when line precedes screen
	nbsp = "␣", -- Show non-breaking spaces
}
vo.undofile = true
vo.undodir = "~/.config/nvim/undodir"

local kmp = vim.keymap

-- Basics
kmp.set("i", "jk", "<Esc>")
kmp.set("n", "<Tab>", ">>")
kmp.set("n", "<S-Tab>", "<<")

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
