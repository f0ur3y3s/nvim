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

require("lazy").setup({
	spec = {
		{ import = "f0ur3y3s.plugins" },
	},
	-- install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})

local startup_group = vim.api.nvim_create_augroup("StartupBehavior", { clear = true })

-- Handle different startup scenarios
vim.api.nvim_create_autocmd("VimEnter", {
	group = startup_group,
	callback = function()
		local args = vim.fn.argv()
		local buf_name = vim.api.nvim_buf_get_name(0)
		local buf_ft = vim.bo[0].filetype
		local buf_lines = vim.api.nvim_buf_line_count(0)

		-- Scenario 1: No arguments (nvim)
		if #args == 0 and buf_name == "" and buf_ft == "" and buf_lines == 1 then
			require("alpha").start()
			return
		end

		-- Scenario 2: Opening a directory (nvim .)
		if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
			-- Change to the directory
			vim.cmd("cd " .. vim.fn.fnameescape(args[1]))

			-- Clear the buffer
			vim.cmd("enew")

			-- Show alpha dashboard
			require("alpha").start()

			-- Optional: Auto-open Neo-tree after a short delay
			vim.defer_fn(function()
				vim.cmd("Neotree show")
			end, 100)
			return
		end

		-- Scenario 3: Opening files - let them open normally
		-- No action needed for file opens
	end,
})
