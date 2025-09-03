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
				{ "<leader>c", group = "Code" },
			},
		})

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

			-- Window navigation
			{ "<C-h>", "<C-w>h", desc = "Move to left window" },
			{ "<C-j>", "<C-w>j", desc = "Move to bottom window" },
			{ "<C-k>", "<C-w>k", desc = "Move to top window" },
			{ "<C-l>", "<C-w>l", desc = "Move to right window" },

			-- Screen movement
			{ "<C-u>", "<C-u>zz", desc = "Page Up (centered)" },
			{ "<C-d>", "<C-d>zz", desc = "Page Down (centered)" },

			{ "<leader>L", "<cmd>Lazy<cr>", desc = "Open Lazy" },
			{ "<leader>M", "<cmd>Mason<cr>", desc = "Open Mason" },
		})

		-- WINDOW MANAGEMENT
		wk.add({
			{ "<leader>wv", "<cmd>vsplit<cr>", desc = "Vertical Split" },
			{ "<leader>ws", "<cmd>split<cr>", desc = "Horizontal Split" },
			{ "<leader>wc", "<cmd>close<cr>", desc = "Close Window" },
			{ "<leader>wo", "<cmd>only<cr>", desc = "Only Window" },
			-- { "<leader>wh", "<C-w>h", desc = "Move to Left Window" },
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
			{ "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
			{ "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
			{ "<leader>bl", "<cmd>bnext<cr>", desc = "Next Buffer" },
			{ "<leader>bh", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
			{ "<leader>ba", '<cmd>%bdelete|edit #|normal `"<cr>', desc = "Delete All Buffers" },
			{ "<leader>bo", '<cmd>%bdelete|edit #|normal `"<cr>', desc = "Delete Other Buffers" },
		})

		local function lsp_attached()
			local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
			return next(get_clients({ bufnr = 0 })) ~= nil
		end
		-- CODE ACTIONS
		wk.add({
			{
				"<leader>ca",
				function()
					vim.lsp.buf.code_action()
				end,
				desc = "Code Action",
				cond = lsp_attached,
			},
		})

		-- MINI CONFIG
		wk.add({
			{ "<leader>e", minifiles_toggle, desc = "Opens file explorer" },
			{ "<leader>tw", "<cmd>lua MiniTrailspace.trim()<cr>", desc = "Trim trailing whitespace" },
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
