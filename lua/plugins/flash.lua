return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			char = {
				enabled = true,
				config = function(opts)
					opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

					opts.jump_labels = opts.jump_labels
						and vim.v.count == 0
						and vim.fn.reg_executing() == ""
						and vim.fn.reg_recording() == ""
				end,
				autohide = true,
				jump_labels = true,
				multi_line = true,
			},
		},
	},
}
