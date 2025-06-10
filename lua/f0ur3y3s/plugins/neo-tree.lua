return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	config = function()
		require("neo-tree").setup({
			-- Prevent Neo-tree from automatically opening on directory
			filesystem = {
				hijack_netrw_behavior = "disabled",
				use_libuv_file_watcher = true,
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				group_empty_dirs = false,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
				never_show = {},
				never_show_by_pattern = {},

				-- Custom commands for better directory handling
				commands = {
					-- Override default directory open behavior
					open_directory = function(state)
						local node = state.tree:get_node()
						if node.type == "directory" then
							require("neo-tree.sources.filesystem").toggle_directory(state, node)
						end
					end,
				},
			},

			enable_git_status = true,
			enable_diagnostics = true,

			-- Enhanced event handlers
			event_handlers = {
				-- {
				-- 	-- event = "file_opened",
				-- handler = function()
				-- 	-- Close Neo-tree when opening a file
				-- 	require("neo-tree.command").execute({ action = "close" })
				-- end,
				-- },
				{
					-- Prevent conflicts with alpha dashboard
					event = "neo_tree_buffer_enter",
					handler = function()
						local buf_name = vim.api.nvim_buf_get_name(0)
						if buf_name:match("alpha") then
							return false -- Don't process if it's alpha
						end
					end,
				},
			},

			window = {
				position = "left",
				width = 50,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
			},

			default_component_configs = {
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = true,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						added = "A",
						modified = "M",
						deleted = "D",
						renamed = "R",
						untracked = "U",
						ignored = "I",
						unstaged = "u",
						staged = "S",
						conflict = "C",
					},
					align = "right",
				},
			},
		})
		local function close_existing_neotree_buffers()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local buf_name = vim.api.nvim_buf_get_name(buf)
				if buf_name:match("neo%-tree") or buf_name:match("filesystem") then
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
				end
			end
		end

		-- Clear any existing Neo-tree state
		close_existing_neotree_buffers()

		-- Add autocmd to handle `nvim .` behavior
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("NeoTreeStartup", { clear = true }),
			callback = function()
				local args = vim.fn.argv()

				-- Only auto-open Neo-tree if explicitly requested
				-- Not when opening a directory with `nvim .`
				if #args == 0 then
					-- No arguments - let alpha show
					return
				elseif #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
					-- Opening a directory - change to it but don't open Neo-tree
					vim.cmd("cd " .. vim.fn.fnameescape(args[1]))
					-- Let alpha dashboard handle the startup screen
					return
				end
				-- For files, normal behavior
			end,
		})
	end,
}
