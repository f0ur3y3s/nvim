return {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	-- compile_commands.json/compile_flags.txt (build-system generated) take
	-- priority so clangd gets real compiler flags; .clangd/.git are fallbacks
	-- so it still attaches in projects without a generated compile database.
	root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
}
