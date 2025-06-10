return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		-- Enhanced build function with error handling
		local ts_install = require("nvim-treesitter.install")

		-- Check if tree-sitter CLI is available
		if vim.fn.executable("tree-sitter") == 0 then
			vim.notify(
				"tree-sitter CLI not found. Some features may be limited.\n"
					.. "Install with: npm install -g tree-sitter-cli",
				vim.log.levels.WARN
			)
			-- Use Neovim's built-in parser compilation
			ts_install.prefer_git = false
			ts_install.compilers = { "gcc", "clang" }
		end

		return ":TSUpdate"
	end,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local ts = require("nvim-treesitter.configs")

		-- Check for tree-sitter CLI availability
		local has_ts_cli = vim.fn.executable("tree-sitter") == 1

		if not has_ts_cli then
			vim.notify("Tree-sitter CLI not found. Installing parsers with built-in compiler.", vim.log.levels.INFO)
		end

		ts.setup({
			-- Enhanced highlighting for 0.11 (now async by default)
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},

			indent = {
				enable = true,
				disable = { "python", "yaml" },
			},

			autotag = {
				enable = true,
				enable_rename = true,
				enable_close = true,
				enable_close_on_slash = true,
				filetypes = {
					"html",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"tsx",
					"jsx",
					"xml",
					"php",
					"markdown",
				},
			},

			-- Essential parsers that work without CLI
			ensure_installed = {
				"lua",
				"bash",
				"c",
				"cpp",
				"python",
				"markdown",
				"markdown_inline",
				"vimdoc",
				"json",
				"yaml",
				"html",
				"css",
				"javascript",
				"typescript",
			},

			-- Enhanced text objects
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},

			-- Install configuration with fallbacks
			sync_install = false,
			auto_install = has_ts_cli, -- Only auto-install if CLI is available
			ignore_install = {},

			-- Compiler preference (fallback when CLI not available)
			install = {
				prefer_git = has_ts_cli,
				compilers = { "gcc", "clang", "cc", "cl", "zig" },
			},
		})

		-- Set up folding with error handling
		pcall(function()
			-- vim.opt.foldmethod = "expr"
			-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			-- vim.opt.foldcolumn = "1"
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
			vim.opt.foldenable = true
		end)

		-- Enhanced markdown concealing
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.opt_local.conceallevel = 2
				vim.opt_local.concealcursor = "n"
			end,
		})

		-- Create command to check tree-sitter status
		vim.api.nvim_create_user_command("TSStatus", function()
			local parsers = require("nvim-treesitter.parsers")
			local info = require("nvim-treesitter.info")

			print("Tree-sitter CLI available: " .. (has_ts_cli and "✓" or "✗"))
			print("Installed parsers:")

			for lang, _ in pairs(parsers.get_parser_configs()) do
				if parsers.has_parser(lang) then
					print("  ✓ " .. lang)
				end
			end
		end, { desc = "Show tree-sitter status" })
	end,
}
