return {
  -- 1. Completely disable flash.nvim so it drops the 's' key
  { "folke/flash.nvim", enabled = false },

  -- 2. Clean Codeberg configuration using the exact string injection format
  {
    -- The primary anonymous string must be the URL itself for non-GitHub hosts
    "https://codeberg.org/andyg/leap.nvim",
    lazy = false, -- Prevent lazy loading blocks
    dependencies = { "tpope/vim-repeat" },
    config = function()
      local leap = require("leap")
      
      -- Native recommended mappings from the official documentation
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap forward" })
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)", { desc = "Leap backward" })
    end,
  },

  -- 3. Prevent mini.surround from conflicting with 'gs' keymaps
  {
    "nvim-mini/mini.surround",
    optional = true,
    opts = {
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
        update_n_lines = "gzn",
      },
    },
  }
}

