return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- actively developed rewrite; the plugin's README recommends it over "master"
	lazy = false, -- README: "this plugin does not support lazy-loading"
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
		-- install() no-ops for already-installed parsers, so it's safe to
		-- call on every startup instead of requiring a manual :TSInstall
		ts.install({
			"lua",
			"vim",
			"vimdoc",
			"query",
			"c",
			"cpp",
			"python",
			"bash",
			"markdown",
			"markdown_inline",
			"json",
			"yaml",
			"toml",
			"diff",
			"regex",
		})

		-- main branch doesn't auto-attach highlighting itself; this FileType
		-- autocmd is the exact setup nvim-treesitter's README documents.
		-- Treesitter-based folding (foldexpr) and indent (indentexpr) are
		-- separate opt-ins the README also documents but aren't enabled here
		-- — folding stays "marker" (see settings.lua) and indent uses
		-- filetype defaults.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
