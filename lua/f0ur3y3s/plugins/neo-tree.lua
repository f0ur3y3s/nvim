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
            -- Add these options to prevent buffer conflicts
            enable_git_status = true,
            enable_diagnostics = true,

            filesystem = {
                -- This helps prevent buffer name conflicts
                use_libuv_file_watcher = true,
                follow_current_file = {
                    enabled = true,
                },
                -- Clear state on window close
                hijack_netrw_behavior = "open_current",
            },

            -- Add this to handle buffer management better
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function()
                        -- Close Neo-tree when opening a file
                        require("neo-tree.command").execute({ action = "close" })
                    end
                },
            },

            -- Prevent duplicate windows
            -- window = {
            --     position = "left",
            --     width = 30,
            --     mapping_options = {
            --         noremap = true,
            --         nowait = true,
            --     },
            -- },
        })
    end,
}
