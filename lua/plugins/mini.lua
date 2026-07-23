return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		require("mini.pairs").setup()
		require("mini.ai").setup()
		require("mini.files").setup()
		require("mini.git").setup()
		require("mini.diff").setup()
		require("mini.icons").setup()
		require("mini.statusline").setup()
		require("mini.notify").setup()
		require("mini.trailspace").setup()

		-- Trim on save, and also whenever returning to Normal mode, so
		-- trailing space doesn't visibly linger mid-edit until the next write.
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				MiniTrailspace.trim()
			end,
		})

		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = "*:n", -- any mode to Normal mode
			callback = function()
				if vim.bo.modifiable and not vim.bo.readonly then
					MiniTrailspace.trim()
				end
			end,
		})
		require("mini.surround").setup()
		require("mini.tabline").setup()
		require("mini.cursorword").setup()
		require("mini.completion").setup()
		require("mini.snippets").setup()

		-- VSCode-style Tab/Enter: cycles snippet tabstops and the completion
		-- popup, expands snippets, and defers to mini.pairs for CR/BS so
		-- bracket-pair expansion still works inside the popup.
		require("mini.keymap").setup()

		local map_multistep = require("mini.keymap").map_multistep
		map_multistep("i", "<Tab>", { "minisnippets_next", "minisnippets_expand", "pmenu_next" })
		map_multistep("i", "<S-Tab>", { "minisnippets_prev", "pmenu_prev" })
		map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
		map_multistep("i", "<BS>", { "minipairs_bs" })

		require("mini.align").setup()
		require("mini.hipatterns").setup({
			-- %f[%w]/%f[%W] are Lua frontier patterns restricting matches to
			-- whole words, so e.g. "TODOING" or "MYTODO" don't also light up
			highlighters = {
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
			},
		})
	end,
}
