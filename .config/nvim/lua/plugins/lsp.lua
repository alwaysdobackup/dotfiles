return {
  -- Snippet engine
  "hrsh7th/vim-vsnip",
  "hrsh7th/vim-vsnip-integ",

  -- CMP sources
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"]     = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local on_attach = function(_, bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        map("n", "gd",         vim.lsp.buf.definition,  opts)
        map("n", "gD",         vim.lsp.buf.declaration, opts)
        map("n", "gr",         vim.lsp.buf.references,  opts)
        map("n", "K",          vim.lsp.buf.hover,       opts)
        map("n", "<leader>rn", vim.lsp.buf.rename,      opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        map("n", "<leader>f",  vim.lsp.buf.format,      opts)
      end

      local servers = {
        "pyright",
        "clangd",
        "html",
        "cssls",
        "ts_ls",
        "emmet_ls",
        "rust_analyzer",
      }

      for _, name in ipairs(servers) do
        vim.lsp.config(name, {
          capabilities = capabilities,
          on_attach    = on_attach,
        })
        vim.lsp.enable(name)
      end
    end,
  },
}
