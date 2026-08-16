-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Makes all files LF (uses Unix-style line breaks instead of the default CLRF line breaks for Windows. Essential for Windows/Linux cross-compatibility).
vim.opt.fileformat = "unix"

--Fixes/re-enables the Tutor command for LazyVim.
-- Wait until Neovim is fully initialized to overwrite the command
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    pcall(vim.api.nvim_del_user_command, "Tutor")
    -- Overwrite the Tutor command safely using LazyVim's native engine
    vim.api.nvim_create_user_command("Tutor", function()
      -- Use LazyVim's built-in terminal runner
      -- This automatically hides gutters, goes full window, and handles clean deletion
      LazyVim.terminal('nvim --clean -c "packadd cfilter" -c "Tutor"', {
        esc_esc = false, -- Keeps your Esc key working normally inside the tutor
        ctrl_hjkl = false, -- Prevents accidental window jumping key conflicts
      })
    end, {})
  end,
})
