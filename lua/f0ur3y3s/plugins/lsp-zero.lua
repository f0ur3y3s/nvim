return {

    {
        "VonHeikemen/lsp-zero.nvim",
        requires = {
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},
        },
        branch = "v3.x",
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({buffer = bufnr})
            end)
           lsp_zero.set_sign_icons({
               error = '✘',
               warn = '▲',
               hint = '⚑',
               info = '»'
           })
        end,
    },
    {"neovim/nvim-lspconfig"},
    {"hrsh7th/cmp-nvim-lsp"},
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()

            local cmp_config = cmp.get_config()
            table.insert(cmp_config.sources, {
                name = "copilot",
                group_index = 1,
            })
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp_action.luasnip_supertab(),
                    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                -- sources = {
                --     { name = "copilot", group_index = 2},
                -- }
            })

        end,
    },
    {"L3MON4D3/LuaSnip"},
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {"clangd","marksman"},
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,
                }
            })
        end,
    },
}
