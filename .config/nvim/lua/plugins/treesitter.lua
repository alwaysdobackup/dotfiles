return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "python", "lua", "c", "cpp", "rust",
          "javascript", "typescript", "html", "css",
          "markdown", "markdown_inline",
          "bash", "jsdoc", "glsl",
          "json", "yaml", "toml",
        },
        sync_install = false,
        auto_install  = false,
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },
}
