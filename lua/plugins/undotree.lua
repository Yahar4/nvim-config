local M = {}

M.setup = function()
    vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { desc = 'Undo tree view' })
end

return {
    "mbbill/undotree",
    config = M.setup,
}
