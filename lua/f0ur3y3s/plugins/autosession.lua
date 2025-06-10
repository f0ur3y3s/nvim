return {
	"rmagatti/auto-session",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	lazy = false,
	config = function()
		-- Enhanced auto-session setup with better error handling for 0.11
		require("auto-session").setup({
			-- Directories to suppress auto-session
			suppressed_dirs = {
				"~/",
				"~/Projects",
				"~/Downloads",
				"/",
				"/tmp",
				"~/.config/nvim", -- Prevent sessions in config directory
			},

			-- Enhanced session options for 0.11
			auto_session_suppress_dirs = {
				"~/",
				"~/Projects",
				"~/Downloads",
				"/",
				"/tmp",
			},

			-- Better session handling
			auto_session_enabled = true,
			auto_save_enabled = true,
			auto_restore_enabled = true,

			-- Enhanced session options for 0.11 compatibility
			session_lens = {
				previewer = false,
				theme_conf = {
					border = true,
					layout_config = {
						width = 0.8,
						height = 0.6,
					},
				},
			},

			-- Better session file handling
			session_root_dir = vim.fn.stdpath("data") .. "/sessions/",

			-- Pre and post session hooks for error handling
			pre_save_cmds = {
				-- Close problematic buffers before saving session
				function()
					-- Close any terminal buffers
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_valid(buf) then
							local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
							if buftype == "terminal" then
								vim.api.nvim_buf_delete(buf, { force = true })
							end
						end
					end
				end,
			},

			-- Commands to run after session restore
			post_restore_cmds = {
				-- Refresh diagnostics and LSP after restore
				function()
					vim.schedule(function()
						vim.cmd("silent! LspRestart")
						vim.diagnostic.reset()
					end)
				end,
			},

			-- Better session saving logic
			auto_session_create_enabled = function()
				local cmd = "git rev-parse --is-inside-work-tree"
				local result = vim.fn.system(cmd)
				-- Only create sessions in git repositories
				return vim.v.shell_error == 0
			end,

			-- Enhanced bypass session save/restore for certain conditions
			bypass_session_save_file_types = {
				"gitcommit",
				"gitrebase",
				"alpha",
				"dashboard",
				"lspinfo",
				"mason",
				"lazy",
			},

			-- Session save/restore hooks with error handling
			save_extra_cmds = {
				-- Save additional state
				function()
					return {
						-- Save current working directory
						"cd " .. vim.fn.getcwd(),
					}
				end,
			},

			-- Better session restoration
			args_allow_single_directory = true,
			args_allow_files_auto_save = false,

			-- Logging for debugging
			log_level = vim.log.levels.ERROR, -- Only log errors to reduce noise
		})

		-- Enhanced session options for better 0.11 compatibility
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

		-- Add autocmd to handle session restoration errors
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("AutoSessionErrorHandler", { clear = true }),
			callback = function()
				-- Clean up any corrupted session files in the session directory
				local session_dir = vim.fn.stdpath("data") .. "/sessions/"
				if vim.fn.isdirectory(session_dir) == 1 then
					local session_files = vim.fn.glob(session_dir .. "*", false, true)
					for _, file in ipairs(session_files) do
						if vim.fn.filereadable(file) == 1 then
							local file_content = vim.fn.readfile(file)
							-- Check if file is empty or corrupted
							if #file_content == 0 or (file_content[1] and file_content[1]:match("Error")) then
								vim.notify(
									"Removing corrupted session file: " .. vim.fn.fnamemodify(file, ":t"),
									vim.log.levels.WARN
								)
								vim.fn.delete(file)
							end
						end
					end
				end
			end,
		})

		-- Keymaps for session management
		vim.keymap.set("n", "<leader>ss", "<cmd>SessionSearch<CR>", { desc = "Search Sessions", silent = true })
		vim.keymap.set("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "Delete Session", silent = true })
		vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore Session", silent = true })
		vim.keymap.set("n", "<leader>sS", "<cmd>SessionSave<CR>", { desc = "Save Session", silent = true })
	end,
}
