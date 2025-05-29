local servers = {
    "clangd",
    "cmake",
    "lua_ls",
    "marksman",
    "pylsp",
    "ruff",
    "vimls",
}

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = servers,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities,
                })
            end

            local kmp = vim.keymap

            kmp.set("n", "K", vim.lsp.buf.hover, {})
            kmp.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            kmp.set("n", "<leader>gr", vim.lsp.buf.references, {})
            kmp.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
            vim.diagnostic.config({
                virtual_text = {
                    enabled = true,
                    source = "if_many",
                    prefix = "●",
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
            -- vim.diagnostic.config({
            --     virtual_text = true,
            --     signs = {
            --         text = {
            --             [vim.diagnostic.severity.ERROR] = "E",
            --             [vim.diagnostic.severity.WARN] = "W",
            --             [vim.diagnostic.severity.HINT] = "H",
            --             [vim.diagnostic.severity.INFO] = "I",
            --         },
            --     },
            --     underline = true,
            -- })
        end,
    },
}
