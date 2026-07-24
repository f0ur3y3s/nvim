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
				-- was "QuickFix Action" — misnomer, these are LSP actions
				-- (rename/format/code action/etc), nothing to do with vim's
				-- quickfix list
				{ "<leader>.", group = "Code Action" },
				-- "open" isn't in which-key's built-in icon-pattern list, so it
				-- needs an explicit icon (unlike f/b/w/d/s above, which match
				-- built-in patterns and get one automatically)
				{ "<leader>o", group = "Open", icon = "󰝰 " },
				{ "<leader>d", group = "Debug" },
				-- moved off "q" — that letter doesn't appear in "Session" at
				-- all (it was borrowed from LazyVim's convention); "s" both
				-- fits the group name and was unclaimed
				{ "<leader>s", group = "Session" },
				-- tw (trim whitespace) and tt (toggle terminal) aren't a real
				-- group — they just share the `t` prefix (see mini config
				-- below) — but a plain "Terminal" label would misdescribe tw,
				-- so the name stays honest about covering both
				{ "<leader>t", group = "Terminal/Trim", icon = " " },
			},
		})

		-- deferred, not `require`d at the top: dap.lua lazy-loads nvim-dap /
		-- nvim-dap-ui / mason-nvim-dap on these same <leader>d keys, and an
		-- eager require() here would defeat that (load them at startup instead)
		local function dap()
			return require("dap")
		end
		local function dapui()
			return require("dapui")
		end

		local minifiles_toggle = function(...)
			if not MiniFiles.close() then
				MiniFiles.open(...)
			end
		end

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
			{ "<C-u>", "<C-u>zz", desc = "Page Up (centered)" },
			{ "<C-d>", "<C-d>zz", desc = "Page Down (centered)" },

		})

		-- OPEN
		wk.add({
			{ "<leader>ol", "<cmd>Lazy<cr>", desc = "Open Lazy" },
			{ "<leader>om", "<cmd>Mason<cr>", desc = "Open Mason" },
		})

		-- SESSION (persistence.nvim)
		wk.add({
			{
				"<leader>ss",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session (cwd)",
			},
			{
				"<leader>sl",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>sd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Session on Exit",
			},
		})

		-- WINDOW MANAGEMENT
		wk.add({
			{ "<leader>wv", "<cmd>vsplit<cr>", desc = "Vertical Split" },
			-- was "ws" (read as generic "window split", asymmetric with wv's
			-- explicit "vertical") — "wh" mirrors wv properly and was free:
			-- the old wh/wj/wk/wl window-nav mappings below are disabled
			-- since <C-h/j/k/l> (settings.lua) already cover that
			{ "<leader>wh", "<cmd>split<cr>", desc = "Horizontal Split" },
			{ "<leader>wc", "<cmd>close<cr>", desc = "Close Window" },
			-- { "<leader>wo", "<cmd>only<cr>", desc = "Only Window" },
			-- { "<leader>wj", "<C-w>j", desc = "Move to Bottom Window" },
			-- { "<leader>wk", "<C-w>k", desc = "Move to Top Window" },
			-- { "<leader>wl", "<C-w>l", desc = "Move to Right Window" },
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

		-- DEBUG
		wk.add({
			{
				"<leader>db",
				function()
					dap().toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					dap().continue()
				end,
				desc = "Continue/Start",
			},
			{
				"<leader>di",
				function()
					dap().step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function()
					dap().step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dO",
				function()
					dap().step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dr",
				function()
					dap().repl.open()
				end,
				desc = "Open REPL",
			},
			{
				"<leader>du",
				function()
					dapui().toggle()
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>dt",
				function()
					dap().terminate()
				end,
				desc = "Terminate Session",
			},
		})

		-- gates the LSP-only mappings below via which-key's `cond`, so they're
		-- only active in buffers that actually have an attached client
		local function lsp_attached()
			return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
		end

		-- CODE ACTIONS
		wk.add({
			{
				"gd",
				function()
					vim.lsp.buf.definition()
				end,
				desc = "Go to Definition",
				cond = lsp_attached,
			},
			{
				"gD",
				function()
					vim.lsp.buf.declaration()
				end,
				desc = "Go to Declaration",
				cond = lsp_attached,
			},
			{
				"gr",
				function()
					vim.lsp.buf.references()
				end,
				desc = "Go to References",
				cond = lsp_attached,
			},
			{
				"gi",
				function()
					vim.lsp.buf.implementation()
				end,
				desc = "Go to Implementation",
				cond = lsp_attached,
			},
			{
				"gt",
				function()
					vim.lsp.buf.type_definition()
				end,
				desc = "Go to Type Definition",
				cond = lsp_attached,
			},
			{
				"gh",
				function()
					vim.lsp.buf.hover()
				end,
				desc = "Hover Documentation",
				cond = lsp_attached,
			},
			{
				"<C-k>",
				function()
					vim.lsp.buf.signature_help()
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
					vim.lsp.buf.code_action()
				end,
				desc = "Code Action",
				cond = lsp_attached,
			},
			{
				"<leader>.r",
				function()
					vim.lsp.buf.rename()
				end,
				desc = "Rename Symbol",
				cond = lsp_attached,
			},
			{
				"<leader>.s",
				function()
					vim.lsp.buf.signature_help()
				end,
				desc = "Signature Help",
				cond = lsp_attached,
			},
			{
				"<leader>.f",
				function()
					vim.lsp.buf.format()
				end,
				desc = "Format Document",
				cond = lsp_attached,
			},
			{
				"<leader>.h",
				function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
				end,
				desc = "Toggle Inlay Hints",
				cond = lsp_attached,
			},
		})

		-- MINI CONFIG
		wk.add({
			{ "<leader>e", minifiles_toggle, desc = "Opens file explorer" },
		})

		-- "t" prefix, no shared theme: trim-whitespace and toggle-terminal
		-- just happen to share a key, not a which-key group (see spec above)
		wk.add({
			{ "<leader>tw", "<cmd>lua MiniTrailspace.trim()<cr>", desc = "Trim trailing whitespace" },
			{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
		})

		-- TELESCOPE
		wk.add({
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
			{ "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Fuzzy Find" },
		})
	end,
}
