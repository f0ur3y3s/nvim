return {
	-- "server" is required: plain `ruff` is the linter/formatter CLI, not an LSP
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
