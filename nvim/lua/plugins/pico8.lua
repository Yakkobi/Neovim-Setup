return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pico8_ls = {
        filetypes = { "lua" },
      },
    },
  },
}
