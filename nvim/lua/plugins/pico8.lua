local pico8_globals = {
  "cls", "spr", "sspr", "fget", "fset", "sget", "sset",
  "mget", "mset", "map", "tline",
  "pset", "pget", "color", "rect", "rectfill", "circ", "circfill",
  "oval", "ovalfill", "line", "fillp",
  "print", "cursor", "camera", "clip", "pal", "palt", "flip",
  "btn", "btnp",
  "sfx", "music",
  "stat", "cartdata", "dget", "dset",
  "memcpy", "memset", "reload", "cstore", "peek", "poke",
  "peek2", "poke2", "peek4", "poke4",
  "printh", "time", "t",
  "rnd", "srand", "flr", "ceil", "abs", "sgn", "min", "max", "mid",
  "sqrt", "sin", "cos", "atan2",
  "band", "bor", "bxor", "bnot", "shl", "shr", "lshr", "rotl", "rotr",
  "tostr", "tonum", "chr", "ord", "sub", "split",
  "add", "del", "deli", "all", "foreach", "count",
  "yield", "cocreate", "coresume", "costatus",
  "stop", "menuitem", "extcmd", "serial",
  "_init", "_update", "_update60", "_draw",
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pico8_ls = {
        filetypes = { "lua" },
      },
      lua_ls = {
        on_init = function(client)
          local root = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
          if root and vim.fn.glob(root .. "/*.p8") ~= "" then
            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
              diagnostics = {
                disable = { "lowercase-global" },
                globals = pico8_globals,
              },
            })
          end
        end,
      },
    },
  },
}
