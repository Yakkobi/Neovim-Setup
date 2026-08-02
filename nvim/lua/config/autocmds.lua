-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Custom grey comments for .txt files.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "text",
  callback = function()
    -- Clear previous syntax rules if file is reloaded
    vim.cmd([[syntax clear]])

    -- Match lines starting with # or //
    vim.cmd([[syntax match TxtComment /\s*#.*/]])
    vim.cmd([[syntax match TxtComment /\s*\/\/.*/]])

    -- Match lines starting with \\ (properly escaped for vim regex)
    vim.cmd([[syntax match TxtComment /\s*\\\\.*/]])

    -- NEW: Match text between /* and */ for longer comments (handles multi-line)
    vim.cmd([[syntax region TxtBlockComment start=/\/\*/ end=/\*\//]])

    -- Link both rules to the standard Comment highlight group
    vim.cmd([[highlight def link TxtComment Comment]])
    vim.cmd([[highlight def link TxtBlockComment Comment]])
  end,
})

-- Adds the following boilerplate when a new HTML file is opened.
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.html",
  callback = function()
    local boilerplate = {
      "<!DOCTYPE html>",
      "<html lang=\"en\">",
      "<head>",
      "  <meta charset=\"UTF-8\">",
      "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
      "  <title>Document</title>",
      "    <link rel=\"stylesheet\" href=\"style.css\" />",
      "</head>",
      "<body>",
      "  ",
      "    <script src=\"script.js\"></script>",
      "</body>",
      "</html>",
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, boilerplate)
    vim.api.nvim_win_set_cursor(0, {9, 2}) -- Moves cursor inside the body tag
  end,
})

