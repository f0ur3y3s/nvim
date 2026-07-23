return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" }, -- matches the Lua runtime Neovim itself embeds
			diagnostics = { globals = { "vim" } }, -- `vim` is injected by Neovim, not undefined
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true), -- so lua_ls can resolve vim.* API types
				checkThirdParty = false, -- skip the "is this a plugin dir?" prompt on every new project
			},
			telemetry = { enable = false },
		},
	},
}
