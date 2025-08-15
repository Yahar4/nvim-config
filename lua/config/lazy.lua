-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- leader = space
vim.g.mapleader = " "

-- bindings 
-- go back to tree view
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- move selected text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- copy to clipboard
vim.keymap.set("v", "<leader>y", "\"+y")
-- moving across wins
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
-- split win
vim.keymap.set("n", "<leader>vs", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>hs", vim.cmd.split)

-- tabs
vim.keymap.set("n", "<leader>tn", vim.cmd.tabnew)
vim.keymap.set("n", "<leader>tc", vim.cmd.tabclose)
vim.keymap.set("n", "b]", vim.cmd.tabnext)
vim.keymap.set("n", "b[", vim.cmd.tabprev)

-- options
vim.opt.guicursor = ""
vim.opt.colorcolumn = "90"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.scrolloff = 8
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.undofile = true


-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins.telescope" },
        { import = "plugins.colors" },
        { import = "plugins.treesitter" },
        { import = "plugins.undotree" },
        { import = "plugins.fugitive" },
        { import = "plugins.lsp" },
        { import = "plugins.cmp" },
        { import = "plugins.autoclose" },
        { import = "plugins.tree" },
        { import = "plugins.gitsigns" },

        {
            "mason-org/mason.nvim",
            opts = {}
        }, 
  },

  checker = { enabled = true },
})
