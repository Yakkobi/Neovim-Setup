return {
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = false, 
    opts = {
      port = 5500,
      browser = "default",
    },
    config = function(_, opts)
      require("live-preview").setup(opts)
    end,
    keys = {
      -- Fixed: Uses the true sub-command space layout syntax
      { "<leader>ps", "<cmd>LivePreview start<cr>", desc = "Start Live Preview" },
      { "<leader>px", "<cmd>LivePreview stop<cr>", desc = "Stop Live Preview" },
      { "<leader>pt", "<cmd>LivePreview toggle<cr>", desc = "Toggle Live Preview" },
    },
  },
}

