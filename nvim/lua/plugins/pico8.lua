return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pico8_ls = {
        filetypes = { "lua" },
      },
      lua_ls = {
        -- Don't attach lua_ls in any project that contains a *.p8 cart.
        -- lua_ls parses standard Lua grammar, which has no += -= *= /= %=
        -- or !=/! -- PICO-8's extended operators -- so it flags them as
        -- syntax errors. pico8_ls (above) understands them and already
        -- knows the full PICO-8 API, so it's the sole server for those
        -- buffers; lua_ls still works as normal everywhere else.
        root_dir = function(bufnr, on_dir)
          local util = require("lspconfig.util")
          local fname = vim.api.nvim_buf_get_name(bufnr)
          if util.root_pattern("*.p8")(fname) then
            return
          end
          on_dir(util.root_pattern(".luarc.json", ".luarc.jsonc", ".git")(fname) or vim.fn.getcwd())
        end,
      },
    },
  },
}
