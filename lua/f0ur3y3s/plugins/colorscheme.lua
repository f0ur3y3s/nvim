return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			compile = false,
			undercurl = true,
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true,
			dimInactive = false,
			terminalColors = true,

			colors = {
				palette = {},
				theme = {
					wave = {},
					lotus = {},
					dragon = {
						-- Custom dragon theme colors for better consistency
						ui = {
							-- transparent backgrounds
							-- bg_dim = "none",
							-- bg = "none",
							-- bg_p1 = "none",
							-- bg_p2 = "none",
							-- bg_m1 = "none",
							-- bg_m2 = "none",
							-- bg_m3 = "none",
							-- Dark background
							bg_dim = "#181616",
							bg = "#181616",
							bg_p1 = "#1D1C19",
							bg_p2 = "#26241D",
							bg_m1 = "#16151D",
							bg_m2 = "#0d0c0c",
							bg_m3 = "#0a0a0a",

							-- UI elements
							bg_gutter = "none",
							bg_visual = "#2D4F67",
							bg_search = "#2D4F67",

							-- Borders and separators
							whitespace = "#2a2a2a",
							bg_p3 = "#363636",

							-- Special UI colors
							special = "#957FB8",
							nontext = "#54546D",

							-- Float/popup specific
							float = {
								bg = "#181616",
								bg_border = "#181616",
								fg_border = "#54546D",
							},
						},
					},
					all = {
						ui = {
							bg_gutter = "none",
							-- Enhanced float settings for all themes
							float = {
								bg = "none",
								bg_border = "none",
								fg_border = "#54546D",
							},
						},
					},
				},
			},

			overrides = function(colors)
				local theme = colors.theme
				local palette = colors.palette

				return {
					-- ============================================
					-- CORE UI FIXES FOR DRAGON THEME
					-- ============================================
					Normal = { fg = theme.ui.fg, bg = theme.ui.bg },
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none", fg = "#54546D" },
					FloatTitle = { bg = "none", fg = theme.ui.special, bold = true },

					-- ============================================
					-- CMDLINE & POPUP FIXES
					-- ============================================
					MsgArea = { bg = "none", fg = theme.ui.fg },
					CmdLine = { bg = "none", fg = theme.ui.fg },
					CmdlinePopup = { bg = "#181616", fg = theme.ui.fg },
					CmdlinePopupBorder = { bg = "none", fg = "#54546D" },
					CmdlineIcon = { fg = theme.ui.special },

					-- ============================================
					-- WHICH-KEY COMPLETE FIX
					-- ============================================
					WhichKey = { fg = theme.syn.fun, bg = "none" },
					WhichKeyGroup = { fg = theme.syn.keyword, bg = "none" },
					WhichKeyDesc = { fg = theme.ui.fg, bg = "none" },
					WhichKeySeperator = { fg = "#54546D", bg = "none" },
					WhichKeySeparator = { fg = "#54546D", bg = "none" },
					WhichKeyFloat = { bg = "#181616" },
					WhichKeyBorder = { bg = "none", fg = "#54546D" },
					WhichKeyValue = { fg = theme.ui.fg_dim, bg = "none" },
					WhichKeyTitle = { fg = theme.ui.special, bg = "none", bold = true },

					-- ============================================
					-- NOTIFICATION & ERROR FIXES
					-- ============================================
					ErrorMsg = { fg = "#E82424", bg = "none" },
					WarningMsg = { fg = "#FF9E3B", bg = "none" },
					MoreMsg = { fg = theme.diag.info, bg = "none" },
					Question = { fg = theme.diag.info, bg = "none" },

					-- Notification backgrounds
					NotifyBackground = { bg = "#181616" },
					NotifyERRORBorder = { fg = "#E82424", bg = "none" },
					NotifyERRORIcon = { fg = "#E82424" },
					NotifyERRORTitle = { fg = "#E82424", bold = true },
					NotifyERRORBody = { fg = theme.ui.fg, bg = "#181616" },

					NotifyWARNBorder = { fg = "#FF9E3B", bg = "none" },
					NotifyWARNIcon = { fg = "#FF9E3B" },
					NotifyWARNTitle = { fg = "#FF9E3B", bold = true },
					NotifyWARNBody = { fg = theme.ui.fg, bg = "#181616" },

					NotifyINFOBorder = { fg = theme.diag.info, bg = "none" },
					NotifyINFOIcon = { fg = theme.diag.info },
					NotifyINFOTitle = { fg = theme.diag.info, bold = true },
					NotifyINFOBody = { fg = theme.ui.fg, bg = "#181616" },

					NotifyDEBUGBorder = { fg = "#54546D", bg = "none" },
					NotifyTRACEBorder = { fg = "#54546D", bg = "none" },

					-- ============================================
					-- NOICE UI FIXES
					-- ============================================
					NoicePopup = { bg = "#181616" },
					NoicePopupBorder = { bg = "none", fg = "#54546D" },
					NoiceCmdline = { bg = "#181616", fg = theme.ui.fg },
					NoiceCmdlinePopup = { bg = "#181616", fg = theme.ui.fg },
					NoiceCmdlinePopupBorder = { bg = "none", fg = "#54546D" },
					NoiceCmdlinePopupTitle = { bg = "none", fg = theme.ui.special },
					NoiceCmdlineIcon = { fg = theme.ui.special },
					NoiceConfirm = { bg = "#181616" },
					NoiceConfirmBorder = { bg = "none", fg = "#54546D" },
					NoiceMini = { bg = "none" },

					-- ============================================
					-- COMPLETION MENU IMPROVEMENTS
					-- ============================================
					Pmenu = { fg = theme.ui.fg, bg = "#1D1C19", blend = vim.o.pumblend },
					PmenuSel = { fg = "NONE", bg = "#26241D", bold = true },
					PmenuSbar = { bg = "#26241D" },
					PmenuThumb = { bg = "#54546D" },
					PmenuKind = { fg = theme.syn.type, bg = "#1D1C19" },
					PmenuKindSel = { fg = theme.syn.type, bg = "#26241D", bold = true },
					PmenuExtra = { fg = theme.ui.fg_dim, bg = "#1D1C19" },
					PmenuExtraSel = { fg = theme.ui.fg_dim, bg = "#26241D" },

					-- CMP specific
					CmpItemAbbr = { fg = theme.ui.fg },
					CmpItemAbbrDeprecated = { fg = theme.ui.fg_dim, strikethrough = true },
					CmpItemAbbrMatch = { fg = theme.syn.fun, bold = true },
					CmpItemAbbrMatchFuzzy = { fg = theme.syn.fun, bold = true },
					CmpItemKind = { fg = theme.syn.type },
					CmpItemMenu = { fg = theme.ui.fg_dim, italic = true },

					-- ============================================
					-- TELESCOPE IMPROVEMENTS
					-- ============================================
					TelescopeTitle = { fg = theme.ui.special, bold = true },
					TelescopeBorder = { bg = "none", fg = "#54546D" },
					TelescopeNormal = { bg = "none", fg = theme.ui.fg },
					TelescopePromptNormal = { bg = "#1D1C19", fg = theme.ui.fg },
					TelescopePromptBorder = { bg = "none", fg = "#54546D" },
					TelescopePromptTitle = { fg = theme.ui.special, bold = true },
					TelescopeResultsNormal = { fg = theme.ui.fg, bg = "none" },
					TelescopeResultsTitle = { fg = theme.ui.special },
					TelescopeResultsBorder = { bg = "none", fg = "#54546D" },
					TelescopePreviewNormal = { bg = "none" },
					TelescopePreviewTitle = { fg = theme.ui.special },
					TelescopePreviewBorder = { bg = "none", fg = "#54546D" },
					TelescopeSelection = { fg = theme.ui.fg, bg = "#26241D" },
					TelescopeSelectionCaret = { fg = theme.ui.special },
					TelescopeMatching = { fg = theme.syn.fun, bold = true },

					-- ============================================
					-- DIAGNOSTIC IMPROVEMENTS
					-- ============================================
					DiagnosticError = { fg = "#E82424" },
					DiagnosticWarn = { fg = "#FF9E3B" },
					DiagnosticInfo = { fg = "#658594" },
					DiagnosticHint = { fg = "#54546D" },

					DiagnosticVirtualTextError = { fg = "#E82424", bg = "none", italic = true },
					DiagnosticVirtualTextWarn = { fg = "#FF9E3B", bg = "none", italic = true },
					DiagnosticVirtualTextInfo = { fg = "#658594", bg = "none", italic = true },
					DiagnosticVirtualTextHint = { fg = "#54546D", bg = "none", italic = true },

					DiagnosticFloatingError = { fg = "#E82424", bg = "none" },
					DiagnosticFloatingWarn = { fg = "#FF9E3B", bg = "none" },
					DiagnosticFloatingInfo = { fg = "#658594", bg = "none" },
					DiagnosticFloatingHint = { fg = "#54546D", bg = "none" },

					DiagnosticSignError = { fg = "#E82424", bg = "none" },
					DiagnosticSignWarn = { fg = "#FF9E3B", bg = "none" },
					DiagnosticSignInfo = { fg = "#658594", bg = "none" },
					DiagnosticSignHint = { fg = "#54546D", bg = "none" },

					-- ============================================
					-- LSP IMPROVEMENTS
					-- ============================================
					LspReferenceText = { bg = "#26241D" },
					LspReferenceRead = { bg = "#26241D" },
					LspReferenceWrite = { bg = "#26241D" },
					LspSignatureActiveParameter = { bg = "#26241D", bold = true },
					LspCodeLens = { fg = "#54546D", italic = true },
					LspInlayHint = { fg = "#54546D", bg = "none", italic = true },

					-- ============================================
					-- GIT SIGNS & DIFFS
					-- ============================================
					GitSignsAdd = { fg = "#76946A", bg = "none" },
					GitSignsChange = { fg = "#DCA561", bg = "none" },
					GitSignsDelete = { fg = "#E82424", bg = "none" },
					GitSignsAddNr = { fg = "#76946A", bg = "none" },
					GitSignsChangeNr = { fg = "#DCA561", bg = "none" },
					GitSignsDeleteNr = { fg = "#E82424", bg = "none" },

					-- ============================================
					-- STATUSLINE & TABLINE
					-- ============================================
					StatusLine = { fg = theme.ui.fg, bg = "#1D1C19" },
					StatusLineNC = { fg = theme.ui.fg_dim, bg = "#181616" },
					TabLine = { fg = theme.ui.fg_dim, bg = "#1D1C19" },
					TabLineFill = { bg = "#181616" },
					TabLineSel = { fg = theme.ui.fg, bg = "#26241D", bold = true },

					-- ============================================
					-- SEARCH & VISUAL
					-- ============================================
					Search = { fg = "#181616", bg = "#957FB8" },
					IncSearch = { fg = "#181616", bg = "#FF9E3B" },
					CurSearch = { fg = "#181616", bg = "#FF9E3B" },
					Substitute = { fg = "#181616", bg = "#E82424" },
					Visual = { bg = "#2D4F67" },
					VisualNOS = { bg = "#2D4F67" },

					-- ============================================
					-- CURSOR & LINE NUMBERS
					-- ============================================
					Cursor = { fg = "#181616", bg = theme.ui.fg },
					CursorLine = { bg = "#1D1C19" },
					CursorColumn = { bg = "#1D1C19" },
					LineNr = { fg = "#54546D", bg = "none" },
					CursorLineNr = { fg = theme.ui.special, bg = "none", bold = true },
					SignColumn = { bg = "none" },

					-- ============================================
					-- FOLDS & INDENT
					-- ============================================
					Folded = { fg = theme.ui.fg_dim, bg = "#1D1C19" },
					FoldColumn = { fg = "#54546D", bg = "none" },
					IndentBlanklineChar = { fg = "#2a2a2a", nocombine = true },
					IndentBlanklineContextChar = { fg = "#54546D", nocombine = true },

					-- ============================================
					-- TREESITTER CONTEXT
					-- ============================================
					TreesitterContext = { bg = "#1D1C19" },
					TreesitterContextBottom = { underline = true, sp = "#54546D" },
					TreesitterContextLineNumber = { fg = "#54546D", bg = "#1D1C19" },

					-- ============================================
					-- WINDOW SEPARATORS
					-- ============================================
					WinSeparator = { fg = "#54546D", bg = "none" },
					VertSplit = { fg = "#54546D", bg = "none" },

					-- ============================================
					-- SPECIAL BUFFERS
					-- ============================================
					EndOfBuffer = { fg = "#181616" },
					NonText = { fg = "#54546D" },
					Whitespace = { fg = "#2a2a2a" },
					SpecialKey = { fg = "#54546D" },
				}
			end,

			theme = "dragon",
			background = {
				dark = "dragon",
				light = "lotus",
			},
		})

		-- Set the colorscheme to dragon
		vim.cmd([[colorscheme kanagawa-dragon]])

		-- Additional fixes after colorscheme loads
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "kanagawa-dragon",
			callback = function()
				-- Force specific highlight fixes for stubborn UI elements
				vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#54546D", bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				vim.api.nvim_set_hl(0, "CmdlinePopupBorder", { fg = "#54546D", bg = "none" })
				vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#54546D", bg = "none" })
				vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "#181616" })

				-- Fix any remaining error styling
				vim.api.nvim_set_hl(0, "ErrorMsg", { fg = "#E82424", bg = "none" })
				vim.api.nvim_set_hl(0, "WarningMsg", { fg = "#FF9E3B", bg = "none" })
			end,
		})

		-- Force immediate application
		vim.defer_fn(function()
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#54546D", bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "ErrorMsg", { fg = "#E82424", bg = "none" })
		end, 100)
	end,
}
