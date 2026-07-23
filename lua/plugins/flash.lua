return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			char = {
				enabled = true,
				-- upstream-recommended dynamic config for f/F/t/T/;/,
				config = function(opts)
					-- autohide flash when in operator-pending mode
					opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

					-- disable jump labels when not enabled, when using a count,
					-- or when recording/executing registers (keeps macros/dot-repeat working)
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
