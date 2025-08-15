return {
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
        -- Set the color scheme
        vim.cmd.colorscheme("rose-pine")

        -- Set transparency for Normal and NormalFloat highlights
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
}
