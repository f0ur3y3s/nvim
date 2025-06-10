return {
	{ "archibate/lualine-time" },
	{ "AndreM222/copilot-lualine" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "archibate/lualine-time" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "codedark",
					-- theme = "base16",
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						"NvimTree",
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						"%=",
						{ "filename", path = 3, separator = { left = "|" } },
					},
					-- lualine_y = { "progress" },
					-- lualine_z = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}
