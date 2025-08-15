local M = {}

M.setup = function()
    vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git Status' })
end

return {
    "tpope/vim-fugitive",
    config = M.setup,
}
