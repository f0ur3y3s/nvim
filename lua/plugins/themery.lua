return {
	"zaldih/themery.nvim",
	config = function()
		require("themery").setup({
			themes = {
				"carbonfox",
				"gruvbox-material",
				"kanagawa",
				"onedark",
				"oxocarbon",
				"sonokai",
				"vscode",
			},
			livePreview = true,
		})
	end,
}
