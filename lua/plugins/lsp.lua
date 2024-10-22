return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'nvimdev/lspsaga.nvim',
        'nvim-neotest/neotest',
        'nvim-neotest/nvim-nio',
        'leoluz/nvim-dap-go',
        'fredrikaverpil/neotest-golang',
    },
    config = function()
        require('mason').setup({
            ensure_installed = { "goimports", "gofumpt" },
            ui = {
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        })

        require('lspsaga').setup({})

        require("neotest").setup({
            adapters = {
                go = {
                    dap_go_enabled = true,
                },
            },
        })

        require('mason-lspconfig').setup({
            -- A list of servers to automatically install if they're not already installed
            ensure_installed = {
                'pylsp',
                'lua_ls',
                'rust_analyzer',
                'ts_ls',
                'cssmodules_ls',
                'emmet_language_server',
                'jdtls',
                'gopls',
            },
        })

        -- Set different settings for different languages' LSP
        -- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        -- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
        --     - the settings table is sent to the LSP
        --     - on_attach: a lua callback function to run after LSP atteches to a given buffer
        local lspconfig = require('lspconfig')

        -- Customized on_attach function
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(_, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            -- vim.keymap.set('n', '<space>wl', function()
            -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            -- end, bufopts)
            -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', '<cmd>Lspsaga rename<CR>', bufopts)
            vim.keymap.set('n', '<space>ca', '<cmd>Lspsaga code_action<CR>', bufopts)
            vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>', bufopts)
            -- vim.keymap.set("n", "<space>f", function()
            -- vim.lsp.buf.format({ async = true })
            -- end, bufopts)
        end

        -- Configure each language
        -- How to add LSP for a specific language?
        -- 1. use `:Mason` to install corresponding LSP
        -- 2. add configuration below

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        lspconfig.pylsp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig.ts_ls.setup({
            capabilities = capabilities,
            filetypes = {
                'javascript',
                'javascriptreact',
                'javascript.jsx',
                'typescript',
                'typescriptreact',
                'typescript.tsx',
            },
            on_attach = on_attach,
        })

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            filetypes = { 'lua' },
            on_attach = on_attach,
        })

        lspconfig.cssmodules_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig.emmet_language_server.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig.jdtls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig.gopls.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                -- workaround for gopls not supporting semanticTokensProvider
                LazyVim.lsp.on_attach(function(client, _)
                    if not client.server_capabilities.semanticTokensProvider then
                        local semantic = client.config.capabilities.textDocument.semanticTokens
                        client.server_capabilities.semanticTokensProvider = {
                            full = true,
                            legend = {
                                tokenTypes = semantic.tokenTypes,
                                tokenModifiers = semantic.tokenModifiers,
                            },
                            range = true,
                        }
                    end
                end, "gopls")
            end,
            settings = {
                gopls = {
                    gofumpt = true,
                    codelenses = {
                        gc_details = false,
                        generate = true,
                        regenerate_cgo = true,
                        run_govulncheck = true,
                        test = true,
                        tidy = true,
                        upgrade_dependency = true,
                        vendor = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                    analyses = {
                        fieldalignment = true,
                        nilness = true,
                        unusedparams = true,
                        unusedwrite = true,
                        useany = true,
                    },
                    usePlaceholders = true,
                    completeUnimported = true,
                    staticcheck = true,
                    directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                    semanticTokens = true,
                },
            },
        })
    end,
}
