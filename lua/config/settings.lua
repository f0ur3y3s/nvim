vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- On WSL, setting 'clipboard' triggers the stock clipboard provider's
-- executable() probing (win32yank/xclip/xsel/wl-copy/tmux), and each check
-- has to stat every directory in the Windows PATH WSL inherits over the
-- DrvFs bridge — measured at ~750ms of startup time. OSC52 is a built-in
-- Neovim provider that skips all of that: pure terminal escape codes, no
-- subprocess, no PATH scan. Windows Terminal supports OSC52 copy/paste.
if vim.fn.has("wsl") == 1 then
	local osc52 = require("vim.ui.clipboard.osc52")
	vim.g.clipboard = {
		name = "OSC 52",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
	}
end
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "auto"
vim.opt.foldcolumn = "0"
vim.opt.foldmethod = "marker"

vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "●" },
	severity_sort = true,
	underline = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
	float = { border = "rounded", source = true },
})

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

-- Terminal functions
kmp.set("t", "jk", "<c-\\><c-n>")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 1000 })
	end,
})

-- Quickfix
kmp.set("n", "<M-j>", "<cmd>cnext<CR>", { silent = true })
kmp.set("n", "<M-k>", "<cmd>cprev<CR>", { silent = true })

-- Inlay hints (only for servers that actually support them)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end
	end,
})
