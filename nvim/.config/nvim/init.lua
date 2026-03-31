-- Load core settings
require("user.settings")
require("user.keymaps")
require("user.plugins")

-- Set colorscheme after plugins load
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    vim.cmd.colorscheme("tokyonight-night")
  end,
})
