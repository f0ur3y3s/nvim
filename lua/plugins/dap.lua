-- lazy-load trigger shared by all three specs below: nothing here should
-- load at startup, only when a debug keymap is actually pressed (which_key.lua
-- defers its require("dap")/require("dapui") calls to match, see there)
local dap_keys = {
	"<leader>db",
	"<leader>dc",
	"<leader>di",
	"<leader>do",
	"<leader>dO",
	"<leader>dr",
	"<leader>du",
	"<leader>dt",
}

return {
	{ "mfussenegger/nvim-dap", keys = dap_keys },
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = dap_keys,
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()

			-- standard nvim-dap-ui pattern: open on session start, close on end
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
		keys = dap_keys,
		opts = {
			-- dap-adapter names, not raw Mason package names — they can
			-- differ (mason-nvim-dap translates "python" <-> debugpy);
			-- "codelldb" covers C/C++/Rust debugging via lldb
			ensure_installed = { "codelldb", "python" },
			automatic_installation = true,
			-- default_setup() does more than wire the adapter: it also
			-- auto-populates dap.configurations[filetype] from
			-- mason-nvim-dap's own bundled defaults (codelldb -> c/cpp/rust
			-- with a "LLDB: Launch" config prompting for the executable via
			-- vim.fn.input, cwd = workspaceFolder; python -> debugpy) — no
			-- extra dap.configurations block needed here.
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		},
	},
}
