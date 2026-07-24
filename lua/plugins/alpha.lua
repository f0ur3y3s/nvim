return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		-- fortune|cowsay was a synchronous subprocess spawn on every
		-- startup (~100ms+ on Windows) just for a header string — a
		-- random static greeting gets the same variety for ~0ms
		local greetings = {
			"welcome back",
			"let's write some code",
			"good to see you again",
			"ready when you are",
		}
		-- unseeded math.random() returns the same first value every
		-- startup, which would defeat the point of "randomly selected"
		math.randomseed(os.time())
		local header = greetings[math.random(#greetings)]

		dashboard.section.header.val = vim.split(header, "\n")
		dashboard.section.header.opts.hl = "AlphaHeader"
		alpha.setup(dashboard.config)
	end,
}
