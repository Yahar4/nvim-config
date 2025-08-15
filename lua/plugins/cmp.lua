return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
        "hrsh7th/cmp-buffer",     -- Buffer source for nvim-cmp
        "hrsh7th/cmp-path",       -- Path source for nvim-cmp
        "L3MON4D3/LuaSnip",       -- Snippet engine
        "saadparwaiz1/cmp_luasnip" -- Snippet source for nvim-cmp
    },
    config = function()
        local cmp = require'cmp'

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)  -- For snippet support
                end,
            },
            mapping = {
                ['<C-j>'] = cmp.mapping.select_next_item(),  -- Select next item
                ['<C-k>'] = cmp.mapping.select_prev_item(),  -- Select previous item
                ['<C-Space>'] = cmp.mapping.complete(),        -- Trigger completion
                ['<C-e>'] = cmp.mapping.close(),               -- Close completion
                ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
            },

            sources = {
                { name = 'nvim_lsp' },  -- LSP source
                { name = 'luasnip' },   -- Snippet source
                { name = 'buffer' },    -- Buffer source
                { name = 'path' },      -- Path source
            },
        })
    end,
}
