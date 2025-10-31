return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- Your existing hotkeys
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        end

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer", 
                "tsserver",
                "pyright",      -- Added your Python LSP
                "gopls",        -- Added your Go LSP
                "clangd",       -- Added your C/C++ LSP
            },
            handlers = {
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach
                    }
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                -- Your custom Python configuration
                ["pyright"] = function()
                    local function get_python_path()
                        local cwd = vim.fn.getcwd()
                        local venv_path = cwd .. "/venv/bin/python"

                        if vim.fn.filereadable(venv_path) == 1 then
                            return venv_path
                        end

                        return "python3"
                    end

                    require("lspconfig").pyright.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            python = {
                                pythonPath = get_python_path(),
                                analysis = {
                                    autoSearchPaths = true,
                                    autoImportCompletions = true,
                                    useLibraryCodeForTypes = true,
                                    diagnosticMode = "workspace",
                                },
                            },
                        },
                    }
                end,

                -- Your custom Go configuration
                ["gopls"] = function()
                    require("lspconfig").gopls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            gopls = {
                                usePlaceholders = true,
                                staticcheck = true,
                                analyses = {
                                    unusedparams = true,
                                    unusedvariables = true,
                                },
                                formatting = {
                                    gofumpt = true,
                                },
                            },
                        },
                    }
                end,

                -- Your custom C/C++ configuration
                ["clangd"] = function()
                    require("lspconfig").clangd.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy", 
                            "--header-insertion=iwyu",
                            "--completion-style=detailed",
                            "--function-arg-placeholders",
                            "--fallback-style=llvm",
                        },
                        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                        init_options = {
                            clangdFileStatus = true,
                            usePlaceholders = true,
                            completeUnimported = true,
                            semanticHighlighting = true,
                        }
                    }
                end,
            }
        })

        -- Your Go autoformat on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*.go',
            callback = function()
                vim.lsp.buf.format({ async = true })
                vim.lsp.buf.code_action({ 
                    context = { only = { 'source.organizeImports' } }, 
                    apply = true 
                })
            end
        })

        -- Your diagnostic configuration
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal", 
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
