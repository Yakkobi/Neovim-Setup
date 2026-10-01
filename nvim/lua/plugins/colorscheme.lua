return {
  {
    "folke/tokyonight.nvim",

    opts = {
      -- Pitch-black background in any terminal, instead of transparency,
      -- which shows the terminal's own (not always black) background.
      on_colors = function(colors)
        colors.bg = "#000000"
        colors.bg_dark = "#000000"
        colors.bg_sidebar = "#000000"
        colors.bg_float = "#000000"
      end,
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}

