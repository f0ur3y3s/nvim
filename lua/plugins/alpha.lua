return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		-- Requires `fortune` and `cowsay` on PATH (not present on Windows by
		-- default); silently falls back to "Moo!" below if either is missing.
		local function get_fortune()
			local handle = io.popen("fortune | cowsay")
			if handle then
				local result = handle:read("*a")
				handle:close()
				return result
			else
				return "Moo! 🐄"
			end
		end

		dashboard.section.header.val = vim.split(get_fortune(), "\n")
		dashboard.section.header.opts.hl = "AlphaHeader"
		alpha.setup(dashboard.config)
	end,
}
