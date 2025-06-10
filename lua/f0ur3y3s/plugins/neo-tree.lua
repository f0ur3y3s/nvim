return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
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
				{
					event = "file_opened",
					handler = function()
						-- Close Neo-tree when opening a file
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
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
				mappings = {
					-- Add quick open mapping
					["<space>"] = {
						"toggle_node",
						nowait = false,
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "cancel",
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					["l"] = "focus_preview",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["C"] = "close_node",
					["z"] = "close_all_nodes",
					["a"] = {
						"add",
						config = {
							show_path = "none",
						},
					},
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
					["i"] = "show_file_details",
				},
			},

			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					with_expanders = nil,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰜌",
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
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
					-- symbols = {
					-- 	added = "✚",
					-- 	modified = "",
					-- 	deleted = "✖",
					-- 	renamed = "󰁕",
					-- 	untracked = "",
					-- 	ignored = "",
					-- 	unstaged = "󰄱",
					-- 	staged = "",
					-- 	conflict = "",
					-- },
				},
				file_size = {
					enabled = true,
					required_width = 64,
				},
				type = {
					enabled = true,
					required_width = 122,
				},
				last_modified = {
					enabled = true,
					required_width = 88,
				},
				created = {
					enabled = true,
					required_width = 110,
				},
				symlink_target = {
					enabled = false,
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
