return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          -- Explicitly show all files (including dotfiles)
        },
        filters = {
            dotfiles = false, -- Show .env
            custom = {},      -- No additional file filters
        },
        -- Ensure git-ignored files are visible
        git = {
          enable = true,
          ignore = false, -- Show git-ignored files (like .env if in .gitignore)
        },
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" },
      { "<leader>a", "<cmd>NvimTreeFindFile<cr>", desc = "Find Current File" },
    },
  }
}
