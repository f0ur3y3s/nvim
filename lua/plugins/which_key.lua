return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.setup({
			preset = "helix",
			spec = {
				{ "<leader>f", group = "Find/Files" },
				{ "<leader>b", group = "Buffer" },
				{ "<leader>w", group = "Window" },
				{ "<leader>.", group = "QuickFix Action" },
				{ "<leader>d", group = "Diagnostics" },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>o", group = "Open" }, -- Added open group
			},
		})

		local minifiles_toggle = function(...)
			if not MiniFiles.close() then
				MiniFiles.open(...)
			end
		end

		local neoscroll = require("neoscroll")
		-- BASICS
		wk.add({
			-- Text movement
			{ "<S-j>", ":m .+1<CR>==", desc = "Move line down" },
			{ "<S-k>", ":m .-2<CR>==", desc = "Move line up" },
			{ "<S-j>", ":m '>+1<CR>gv=gv", desc = "Move selection down", mode = "v" },
			{ "<S-k>", ":m '<-2<CR>gv=gv", desc = "Move selection up", mode = "v" },

			-- Buffer movement
			{ "<S-l>", "<cmd>bnext<cr>", desc = "Next Buffer" },
			{ "<S-h>", "<cmd>bprevious<cr>", desc = "Previous Buffer" },

			-- Window navigation
			{ "<C-h>", "<C-w>h", desc = "Move to left window" },
			{ "<C-j>", "<C-w>j", desc = "Move to bottom window" },
			{ "<C-k>", "<C-w>k", desc = "Move to top window" },
			{ "<C-l>", "<C-w>l", desc = "Move to right window" },

			-- Screen movement
			{
				"<C-u>",
				function()
					neoscroll.ctrl_u({ duration = 100 })
					vim.schedule(function()
						vim.cmd("normal! zz")
					end)
				end,
				desc = "Page Up (centered)",
			},
			{
				"<C-d>",
				function()
					neoscroll.ctrl_d({ duration = 100 })
					vim.schedule(function()
						vim.cmd("normal! zz")
					end)
				end,
				desc = "Page Down (centered)",
			},
			-- { "<C-u>", "<C-u>zz", desc = "Page Up (centered)" },
			-- { "<C-d>", "<C-d>zz", desc = "Page Down (centered)" },
			{ "<leader>e", minifiles_toggle, desc = "Open file explorer" },
		})

		-- OPEN GROUP
		wk.add({
			{ "<leader>ol", "<cmd>Lazy<cr>", desc = "Open Lazy" },
			{ "<leader>om", "<cmd>Mason<cr>", desc = "Open Mason" },
			{ "<leader>ot", "<cmd>Themery<cr>", desc = "Open themery" },
		})

		-- WINDOW MANAGEMENT
		wk.add({
			{ "<leader>wv", "<cmd>vsplit<cr>", desc = "Vertical Split" },
			{ "<leader>wh", "<cmd>split<cr>", desc = "Horizontal Split" },
			{ "<leader>wc", "<cmd>close<cr>", desc = "Close Window" },
			{ "<leader>w=", "<C-w>=", desc = "Equalize Windows" },
			{ "<leader>w+", "<cmd>resize +5<cr>", desc = "Increase Height" },
			{ "<leader>w-", "<cmd>resize -5<cr>", desc = "Decrease Height" },
			{ "<leader>w<", "<cmd>vertical resize -5<cr>", desc = "Decrease Width" },
			{ "<leader>w>", "<cmd>vertical resize +5<cr>", desc = "Increase Width" },
		})

		-- BUFFER MANAGEMENT
		wk.add({
			{ "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
			{ "<leader>bD", "<cmd>bdelete!<cr>", desc = "Force Delete Buffer" },
			{ "<leader>bl", "<cmd>bnext<cr>", desc = "Next Buffer" },
			{ "<leader>bh", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
			{ "<leader>ba", '<cmd>%bdelete|edit #|normal `"<cr>', desc = "Delete All Buffers" },
			{ "<leader>bo", '<cmd>%bdelete|edit #|normal `"<cr>', desc = "Delete Other Buffers" },
		})

		local function lsp_attached()
			local get_clients = vim.lsp.get_clients
			return next(get_clients({ bufnr = 0 })) ~= nil
		end

		local vlb = vim.lsp.buf
		-- CODE ACTIONS
		wk.add({
			{
				"gd",
				function()
					vlb.definition()
				end,
				desc = "Go to Definition",
				cond = lsp_attached,
			},
			{
				"gD",
				function()
					vlb.declaration()
				end,
				desc = "Go to Declaration",
				cond = lsp_attached,
			},
			{
				"gr",
				function()
					vlb.references()
				end,
				desc = "Go to References",
				cond = lsp_attached,
			},
			{
				"gi",
				function()
					vlb.implementation()
				end,
				desc = "Go to Implementation",
				cond = lsp_attached,
			},
			{
				"gt",
				function()
					vlb.type_definition()
				end,
				desc = "Go to Type Definition",
				cond = lsp_attached,
			},
			{
				"gh",
				function()
					vlb.hover()
				end,
				desc = "Hover Documentation",
				cond = lsp_attached,
			},
			{
				"<C-k>",
				function()
					vlb.signature_help()
				end,
				desc = "Signature Help",
				mode = "i",
				cond = lsp_attached,
			},
		})

		wk.add({
			{
				"<leader>.a",
				function()
					vlb.code_action()
				end,
				desc = "Code Action",
				cond = lsp_attached,
			},
			{
				"<leader>.r",
				function()
					vlb.rename()
				end,
				desc = "Rename Symbol",
				cond = lsp_attached,
			},
			{
				"<leader>.s",
				function()
					vlb.signature_help()
				end,
				desc = "Signature Help",
				cond = lsp_attached,
			},
			{
				"<leader>.f",
				function()
					vlb.format()
				end,
				desc = "Format Document",
				cond = lsp_attached,
			},
		})

		-- DIAGNOSTICS
		wk.add({
			{
				"<leader>dd",
				"<cmd>Telescope diagnostics bufnr=0<cr>",
				desc = "Buffer Diagnostics",
				cond = lsp_attached,
			},
			{
				"<leader>dw",
				"<cmd>Telescope diagnostics<cr>",
				desc = "Workspace Diagnostics",
				cond = lsp_attached,
			},
			{
				"<leader>dl",
				function()
					vim.diagnostic.open_float()
				end,
				desc = "Line Diagnostics",
				cond = lsp_attached,
			},
			{
				"[d",
				function()
					vim.diagnostic.goto_prev()
				end,
				desc = "Previous Diagnostic",
				cond = lsp_attached,
			},
			{
				"]d",
				function()
					vim.diagnostic.goto_next()
				end,
				desc = "Next Diagnostic",
				cond = lsp_attached,
			},
		})

		-- TOGGLE GROUP
		wk.add({
			{
				"<leader>td",
				function()
					local current_config = vim.diagnostic.config()
					local new_virtual_text = not current_config.virtual_text
					vim.diagnostic.config({
						virtual_text = new_virtual_text,
					})
					print("Virtual text diagnostics: " .. (new_virtual_text and "ON" or "OFF"))
				end,
				desc = "Toggle Inline Diagnostics",
			},
			{
				"<leader>tw",
				"<cmd>lua MiniTrailspace.trim()<cr>",
				desc = "Trim Trailing Whitespace",
			},
			{
				"<leader>tl",
				function()
					vim.opt.list = not vim.opt.list:get()
					print("List mode (whitespace): " .. (vim.opt.list:get() and "ON" or "OFF"))
				end,
				desc = "Toggle List Mode (Show Whitespace)",
			},
			{
				"<leader>tc",
				function()
					if vim.o.conceallevel == 0 then
						vim.o.conceallevel = 2
						print("Conceal: ON")
					else
						vim.o.conceallevel = 0
						print("Conceal: OFF")
					end
				end,
				desc = "Toggle Conceal Level",
			},
			{
				"<leader>tg",
				function()
					require("grug-far").toggle_instance({
						instanceName = "far",
						staticTitle = "Find and Replace with Grug",
					})
				end,
				desc = "Toggle Grug",
			},
		})

		-- TELESCOPE
		wk.add({
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
			{ "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Fuzzy Find" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
		})

		wk.add({
			{ "<leader>n", "<cmd>Neogen<cr>", desc = "Generate Neogen annotation" },
		})
	end,
}
