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
            { 'mfussenegger/nvim-jdtls' },
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

            local lspconfig = require("lspconfig")

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'tailwindcss',
                    'lua_ls',
                    'yamlls',
                    'tsserver',
                    'clangd',
                    'pylsp',
                    'jdtls',
                },

                handlers = {
                    function(server_name) -- default handler (optional)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                    ['clangd'] = function()
                        lspconfig.clangd.setup({
                            capabilities = capabilities,
                            cmd = {
                                'clangd',
                                '--fallback-style=webkit',
                            },
                        })
                    end,
                    ["lua_ls"] = function()
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
                    ["jdtls"] = function()
                        local home = os.getenv 'HOME'
                        local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
                        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
                        local workspace_dir = workspace_path .. project_name

                        local status, jdtls = pcall(require, 'jdtls')
                        if not status then
                            return
                        end
                        local extendedClientCapabilities = jdtls.extendedClientCapabilities

                        local config = {
                            cmd = {
                                'java',
                                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                                '-Dosgi.bundles.defaultStartLevel=4',
                                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                                '-Dlog.protocol=true',
                                '-Dlog.level=ALL',
                                '-Xmx1g',
                                '--add-modules=ALL-SYSTEM',
                                '--add-opens',
                                'java.base/java.util=ALL-UNNAMED',
                                '--add-opens',
                                'java.base/java.lang=ALL-UNNAMED',
                                '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
                                '-jar',
                                vim.fn.glob(home ..
                                '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
                                '-configuration',
                                home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
                                '-data',
                                workspace_dir,
                            },
                            root_dir = function ()
                                return require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
                            end,

                            settings = {
                                java = {
                                    signatureHelp = { enabled = true },
                                    extendedClientCapabilities = extendedClientCapabilities,
                                    maven = {
                                        downloadSources = true,
                                    },
                                    referencesCodeLens = {
                                        enabled = true,
                                    },
                                    references = {
                                        includeDecompiledSources = true,
                                    },
                                    inlayHints = {
                                        parameterNames = {
                                            enabled = 'all', -- literals, all, none
                                        },
                                    },
                                    format = {
                                        enabled = false,
                                    },
                                },
                            },

                            init_options = {
                                bundles = {},
                            },
                            capabilities = capabilities,
                        }
                        lspconfig.jdtls.setup(config)
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
