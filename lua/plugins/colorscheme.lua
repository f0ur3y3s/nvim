return {
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		config = function()
			vim.g.gruvbox_material_enable_italic = true
		end,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		config = function()
			vim.opt.background = "dark"
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
	},
	{
		"sainnhe/sonokai",
		lazy = false,
		config = function()
			vim.g.sonokai_enable_italic = true
			vim.g.sonokai_style = "shusia"
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		config = function()
			require("vscode").setup({
				italic_comments = true,
				-- transparent = true,
			})
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
	},
	{
		"navarasu/onedark.nvim",
		lazy = false,
		config = function()
			require("onedark").setup({
				style = "warmer",
			})
		end,
	},
}
