return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-emoji",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()

			local luasnip = require("luasnip")
			luasnip.config.set_config({
				enable_autosnippets = true,
				update_events = "TextChanged,TextChangedI",
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Set up better selection highlighting
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3E4451", fg = "#61AFEF", bold = true })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#61AFEF", bold = true })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#61AFEF", bold = true })

			-- Highlight for selected snippet items
			vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#E5C07B", bold = true })
			vim.api.nvim_set_hl(0, "CmpItemMenuSnippet", { fg = "#E5C07B", italic = true })

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
						-- Enhanced highlighting for better selection visibility
						winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
						scrollbar = true,
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:CmpDoc",
					}),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					["<C-j>"] = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if cmp.get_selected_entry() then
								cmp.confirm({ select = true })
							else
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "emoji", priority = 700 },
					{ name = "path", priority = 500 },
				}, {
					{ name = "buffer", priority = 250 },
				}),

				-- Simple formatting without icons
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, vim_item)
						-- Simple text-only formatting
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
							emoji = "[Emoji]",
						})[entry.source.name] or ""

						-- Apply special highlighting to snippets when selected
						if entry.source.name == "luasnip" then
							vim_item.kind_hl_group = "CmpItemKindSnippet"
							vim_item.menu_hl_group = "CmpItemMenuSnippet"
						end

						return vim_item
					end,
				},

				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},

				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				performance = {
					debounce = 60,
					throttle = 30,
					fetching_timeout = 500,
				},
			})

			-- Toggle completions function
			local cmp_enabled = true
			local function toggle_completions()
				if cmp_enabled then
					cmp.setup({ enabled = false })
					cmp_enabled = false
					vim.notify("Completions disabled", vim.log.levels.INFO)
				else
					cmp.setup({ enabled = true })
					cmp_enabled = true
					vim.notify("Completions enabled", vim.log.levels.INFO)
				end
			end
		end,
	},
}
