return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Set up LSP servers
        vim.lsp.enable("pyright")
        vim.lsp.enable("gopls")
        vim.lsp.enable("clangd")
       
        -- Define capabilities and on_attach function if not already defined
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

        end

        -- Python
        local function get_python_path()
            local cwd = vim.fn.getcwd()
            local venv_path = cwd .. "/venv/bin/python"

            -- Проверяем существует ли venv в текущем проекте
            if vim.fn.filereadable(venv_path) == 1 then
                return venv_path
            end

            -- Если нет, используем системный python3
            return "python3"
        end

        vim.lsp.config("pyright", {
            filetypes = { "python" },
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
        })

        -- Golang
        vim.lsp.config("gopls", {
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            on_attach = on_attach,
            capabilities = capabilities,
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
        })

         -- Clangd for C/C++
        vim.lsp.config("clangd", {
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
            -- This makes sure clangd doesn't override the offset encoding
            init_options = {
                clangdFileStatus = true,
                usePlaceholders = true,
                completeUnimported = true,
                semanticHighlighting = true,
            }
        })

        -- autoformat on save for Go
        vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = true })]]

        vim.api.nvim_create_autocmd('BufWritePre', {
           pattern = '*.go',
            callback = function()
                vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
            end
        })
    end,
}
