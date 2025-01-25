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
            require("mason-lspconfig").setup({})
        end,
        -- config = function()
        --     require("mason-lspconfig").setup({
        --         ensure_installed = {
        --             "lua_ls",
        --         },
        --     })
        -- end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
            lspconfig.marksman.setup({
                capabilities = capabilities,
            })

            local kmp = vim.keymap

            kmp.set("n", "K", vim.lsp.buf.hover, {})
            kmp.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            kmp.set("n", "<leader>gr", vim.lsp.buf.references, {})
            kmp.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
