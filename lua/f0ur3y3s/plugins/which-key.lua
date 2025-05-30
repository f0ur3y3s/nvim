-- return {
-- 	"folke/which-key.nvim",
-- 	event = "VeryLazy",
-- 	opts = {
-- 		-- your configuration comes here
-- 		-- or leave it empty to use the default settings
-- 		-- refer to the configuration section below
-- 	},
-- 	keys = {
-- 		{
-- 			"<leader>?",
-- 			function()
-- 				require("which-key").show({ global = false })
-- 			end,
-- 			desc = "Buffer Local Keymaps (which-key)",
-- 		},
-- 	},
-- }
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.setup({
			-- your which-key configuration here
		})

		-- LSP keybindings
		local lsp_keys = {
			["gh"] = { vim.lsp.buf.hover, "Hover Documentation" },
			["gd"] = { vim.lsp.buf.definition, "Go to Definition" },
			["gr"] = { vim.lsp.buf.references, "Go to References" },
			["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
			["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
		}

		-- Leader key mappings organized by category
		local leader_keys = {
			-- Buffer operations
			b = {
				name = "Buffer",
				f = {
					function()
						vim.lsp.buf.format({
							filter = function(client)
								return client.name == "null-ls"
							end,
						})
					end,
					"Format Buffer",
				},
				d = {
					function()
						vim.cmd("bdelete")
					end,
					"Delete Buffer",
				},
				h = {
					function()
						vim.cmd("bprevious")
					end,
					"Previous Buffer",
				},
				l = {
					function()
						vim.cmd("bnext")
					end,
					"Next Buffer",
				},
			},

			-- Code operations
			c = {
				name = "Code",
				a = { vim.lsp.buf.code_action, "Code Action" },
				h = { "<cmd>Noice<CR>", "Code History/Warnings" },
			},

			-- Diagnostics
			e = { vim.diagnostic.open_float, "Open Diagnostic Float" },

			-- File operations (Telescope)
			f = {
				name = "Find",
				f = { "<cmd>Telescope find_files<cr>", "Find Files" },
				g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
				b = { "<cmd>Telescope buffers<cr>", "Buffers" },
				h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
				c = {
					function()
						require("telescope.actions").close()
					end,
					"Close Telescope",
				},
			},

			-- Git operations
			g = {
				name = "Git",
				s = { "<cmd>Neotree float git_status<CR>", "Git Status" },
				d = { vim.lsp.buf.definition, "Go to Definition" },
				r = { vim.lsp.buf.references, "References" },
			},

			-- Harpoon
			h = {
				name = "Harpoon",
				a = {
					function()
						require("harpoon"):list():add()
					end,
					"Add File",
				},
				f = {
					function()
						local harpoon = require("harpoon")
						local conf = require("telescope.config").values
						local function toggle_telescope(harpoon_files)
							local file_paths = {}
							for _, item in ipairs(harpoon_files.items) do
								table.insert(file_paths, item.value)
							end
							require("telescope.pickers")
								.new({}, {
									prompt_title = "Harpoon",
									finder = require("telescope.finders").new_table({ results = file_paths }),
									previewer = conf.file_previewer({}),
									sorter = conf.generic_sorter({}),
								})
								:find()
						end
						toggle_telescope(harpoon:list())
					end,
					"Find Files",
				},
				l = {
					function()
						require("harpoon"):list():next()
					end,
					"Next Buffer",
				},
				h = {
					function()
						require("harpoon"):list():prev()
					end,
					"Previous Buffer",
				},
			},

			-- Sessions
			s = {
				name = "Session",
				s = { "<cmd>SessionSearch<CR>", "Search Sessions" },
			},

			-- Buffer fuzzy find
			["/"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer Fuzzy Find" },

			-- Which-key help
			["?"] = {
				function()
					wk.show({ global = false })
				end,
				"Buffer Local Keymaps",
			},
		}

		-- Non-leader mappings
		local normal_keys = {
			-- Neo-tree
			["<C-n>"] = { ":Neotree toggle<CR>", "Toggle Neo-tree" },

			-- Flash navigation
			s = {
				function()
					require("flash").jump()
				end,
				"Flash Jump",
			},
			S = {
				function()
					require("flash").treesitter()
				end,
				"Flash Treesitter",
			},
		}

		-- Flash operator-pending mode
		local operator_keys = {
			r = {
				function()
					require("flash").remote()
				end,
				"Remote Flash",
			},
		}

		-- Flash visual/operator mode
		local visual_operator_keys = {
			R = {
				function()
					require("flash").treesitter_search()
				end,
				"Treesitter Search",
			},
		}

		-- Command mode
		local command_keys = {
			["<c-s>"] = {
				function()
					require("flash").toggle()
				end,
				"Toggle Flash Search",
			},
		}

		-- Telescope insert mode mappings
		local telescope_insert_keys = {
			["<leader>fc"] = {
				function()
					require("telescope.actions").close()
				end,
				"Close",
			},
			["<leader>db"] = {
				function()
					require("telescope.actions").delete_buffer()
				end,
				"Delete Buffer",
			},
		}

		-- Register all keymaps
		wk.add({
			-- Normal mode mappings
			{ "<leader>", group = "Leader" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>c", group = "Code" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Harpoon" },
			{ "<leader>s", group = "Session" },
		})

		-- Set up the keymaps
		for key, mapping in pairs(lsp_keys) do
			vim.keymap.set("n", key, mapping[1], { desc = mapping[2], silent = true })
		end

		for key, mapping in pairs(leader_keys) do
			if type(mapping) == "table" and mapping.name then
				-- Handle grouped mappings
				for subkey, submapping in pairs(mapping) do
					if subkey ~= "name" then
						vim.keymap.set(
							"n",
							"<leader>" .. key .. subkey,
							submapping[1],
							{ desc = submapping[2], silent = true }
						)
					end
				end
			else
				-- Handle direct mappings
				vim.keymap.set("n", "<leader>" .. key, mapping[1], { desc = mapping[2], silent = true })
			end
		end

		for key, mapping in pairs(normal_keys) do
			vim.keymap.set("n", key, mapping[1], { desc = mapping[2], silent = true })
		end

		for key, mapping in pairs(operator_keys) do
			vim.keymap.set("o", key, mapping[1], { desc = mapping[2], silent = true })
		end

		for key, mapping in pairs(visual_operator_keys) do
			vim.keymap.set({ "o", "x" }, key, mapping[1], { desc = mapping[2], silent = true })
		end

		for key, mapping in pairs(command_keys) do
			vim.keymap.set("c", key, mapping[1], { desc = mapping[2], silent = true })
		end

		-- Flash modes with multiple key mappings
		vim.keymap.set({ "n", "x", "o" }, "s", function()
			require("flash").jump()
		end, { desc = "Flash Jump" })
		vim.keymap.set({ "n", "x", "o" }, "S", function()
			require("flash").treesitter()
		end, { desc = "Flash Treesitter" })
	end,
}
