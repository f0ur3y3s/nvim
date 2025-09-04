return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-mini/mini.icons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		-- Function to get fortune | cowsay output
		local function get_fortune()
			local handle = io.popen("fortune -s | cowsay")
			if handle then
				local result = handle:read("*a")
				handle:close()
				return result
			else
				return "Welcome back"
			end
		end

		dashboard.section.header.val = vim.split(get_fortune(), "\n")
		dashboard.section.header.opts.hl = "AlphaHeader"
		alpha.setup(dashboard.config)
	end,
}
