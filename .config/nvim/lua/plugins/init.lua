-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins.theme" },
  { import = "plugins.lsp" },
  { import = "plugins.treesitter" },
  { import = "plugins.telescope" },
  { import = "plugins.editing" },
  { import = "plugins.obsidian" },
}, {
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = true,  -- auto-check for plugin updates
    notify = false,
  },
})
