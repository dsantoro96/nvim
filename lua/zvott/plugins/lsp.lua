return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },
            { 'j-hui/fidget.nvim' },
        },
        config = function()
            require('fidget').setup({})
            require('mason').setup()

            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            local luasnip = require("luasnip")
            luasnip.config.setup({})

            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                mapping = cmp.mapping.preset.insert({
                    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    -- { name = 'luasnip' },
                    { name = 'path' },
                }, {
                    { name = 'buffer' },
                })
            })

            local cmp_lsp = require('cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'angularls',
                    'tailwindcss',
                    'lua_ls',
                    'yamlls',
                    'tsserver',
                    'eslint',
                    'clangd',
                    'pylsp',
                },

                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")

                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" }
                                    }
                                }
                            }
                        })
                    end,
                }
            })

            vim.diagnostic.config({
                virtual_text = true,
                update_in_insert = true,
            })
        end
    },
}
