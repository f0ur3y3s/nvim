return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		-- Requires `fortune` and `cowsay` on PATH (not always the case,
		-- e.g. no fortune database configured); any non-zero exit from
		-- either falls back to a plain greeting below.
		local function run(cmd)
			local handle = io.popen(cmd)
			if not handle then
				return nil
			end
			local output = handle:read("*a")
			local ok, _, code = handle:close()
			if not ok or (code and code ~= 0) or output == "" then
				return nil
			end
			return output
		end

		local function get_fortune()
			local text
			if vim.fn.has("win32") == 1 then
				-- the Windows cowsay port doesn't read stdin — it requires
				-- the text as a -t/--text argument, so fortune's output has
				-- to be captured separately and passed in rather than piped
				local fortune_text = run("fortune 2>NUL")
				text = fortune_text
					and run(string.format('cowsay -t "%s" 2>NUL', fortune_text:gsub('"', '\\"'):gsub("\n$", "")))
			else
				text = run("fortune | cowsay 2>/dev/null")
			end
			return text or "welcome back"
		end

		dashboard.section.header.val = vim.split(get_fortune(), "\n")
		dashboard.section.header.opts.hl = "AlphaHeader"
		alpha.setup(dashboard.config)
	end,
}
