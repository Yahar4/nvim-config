return {
  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable = true,
      include_declaration = false,
    },
    config = function(_, opts)
      require("lsp-lens").setup(opts)
      
      -- Автоматически включать для gopls
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "gopls" then
            require("lsp-lens").on_attach(client, args.buf)
          end
        end,
      })
    end
  }
}
