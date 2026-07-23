return {
	"akinsho/toggleterm.nvim",
	opts = {
		open_mapping = [[<c-\>]], -- toggleterm's own toggle key, independent of which-key
		-- default is vim.o.shell, which is cmd.exe on Windows unless
		-- overridden; prefer the user's actual shell instead: pwsh over
		-- Windows PowerShell, and $SHELL (e.g. zsh) on Unix
		shell = function()
			if vim.fn.has("win32") == 1 then
				return vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
			end
			return vim.env.SHELL or vim.o.shell
		end,
	},
}
