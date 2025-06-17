local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.formatprg = "ruff format --stdin-filename " .. vim.fn.expand("%")
	end,
})
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim.diagnostic.config({ virtual_lines = true })

require("lazy").setup({
	spec = {
		{ import = "f0ur3y3s.plugins" },
		{ import = "f0ur3y3s.plugins.lsp" },
		{ import = "f0ur3y3s.plugins.visual" },
		{ import = "f0ur3y3s.plugins.qol" },
	},
	checker = { enabled = true },
})

-- local startup_group = vim.api.nvim_create_augroup("StartupBehavior", { clear = true })

local function start_alpha_safely()
	local ok, alpha = pcall(require, "alpha")
	if ok then
		local start_ok, err = pcall(alpha.start)
		if not start_ok then
			vim.notify("failed to start alpha: " .. tostring(err), vim.log.levels.error)
		end
	end
end

-- start_alpha_safely()

vim.api.nvim_create_autocmd("vimenter", {
	group = startup_group,
	callback = function()
		local args = vim.fn.argv()
		local buf_name = vim.api.nvim_buf_get_name(0)
		local buf_ft = vim.bo[0].filetype
		local buf_lines = vim.api.nvim_buf_line_count(0)

		-- scenario 1: no arguments (nvim)
		if #args == 0 and buf_name == "" and buf_ft == "" and buf_lines == 1 then
			start_alpha_safely()
			return
		end

		-- scenario 2: opening a directory (nvim .)
		if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
			vim.cmd("cd " .. vim.fn.fnameescape(args[1]))

			-- clear the buffer
			vim.cmd("enew")
			start_alpha_safely()
			vim.defer_fn(function()
				vim.cmd("nvimtreeopen")
			end, 100)
			return
		end

		-- scenario 3: opening files - let them open normally
		-- no action needed for file opens
	end,
})
