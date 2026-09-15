-- Force-restart the LSP client(s) attached to the current buffer.
-- Plain :e! only re-reads the file text; it doesn't make the server
-- discard its (possibly desynced) internal document state the way a
-- full close+reopen does. This stops the client(s) and re-triggers a
-- fresh attach, which is what actually clears stuck/stale diagnostics
-- after pico8_ls falls out of sync with externally-edited files.
vim.api.nvim_create_user_command("PicoLspRestart", function()
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    client:stop()
  end
  vim.defer_fn(function()
    vim.cmd("edit")
  end, 200)
end, {})

-- lazydev.nvim unconditionally overwrites lua_ls's root_dir (see
-- lazydev/integrations/lspconfig.lua), clobbering the *.p8 exclusion
-- below regardless of plugin load order, since root_dir is a whole
-- function value and whichever config merges in last wins outright --
-- there's no partial merge. So instead of trying to win that race,
-- just stop lua_ls immediately after it attaches to any buffer inside
-- a *.p8 project. This works no matter which root_dir "won".
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_clients({ id = args.data.client_id })[1]
    if not client or client.name ~= "lua_ls" then
      return
    end
    local fname = vim.api.nvim_buf_get_name(args.buf)
    if require("lspconfig.util").root_pattern("*.p8")(fname) then
      client:stop()
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pico8_ls = {
          filetypes = { "lua" },
          -- pico8-ls's formatter only runs for languageId "pico-8"/"pico-8-lua"
          -- (its VS Code extension registers files under that custom id).
          -- Neovim sends the buffer's actual filetype ("lua") by default, so
          -- without this override the formatter silently no-ops on every
          -- request -- no error, no edit, regardless of what's misformatted.
          get_language_id = function(bufnr, filetype)
            return "pico-8-lua"
          end,
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
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        stylua = {
          -- Same reasoning as lua_ls above: stylua only parses standard
          -- Lua grammar, so it hard-fails to tokenize PICO-8's extended
          -- operators (+= -= *= /= %= and !=/!). Skip it in *.p8 projects
          -- instead of erroring on every format-on-save.
          condition = function(self, ctx)
            return not require("lspconfig.util").root_pattern("*.p8")(ctx.filename)
          end,
        },
      },
      formatters_by_ft = {
        -- lsp_format = "fallback" has to be set here, per-filetype, not
        -- just relied on as LazyVim's global default -- conform's
        -- buffer-has-a-formatter check (which gates format-on-save) reads
        -- this per-entry setting, and stylua's condition above returns
        -- false for pico8_ls buffers, so pico8_ls's own formatter runs.
        lua = { "stylua", lsp_format = "fallback" },
      },
    },
  },
}
