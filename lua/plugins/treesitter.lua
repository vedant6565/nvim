return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "javascript", "typescript", "lua", "vim", "vimdoc", "query" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }, {
  "nvim-treesitter/playground",
}, {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require 'treesitter-context'.setup({})
    vim.keymap.set("n", "[c", function()
      require("treesitter-context").go_to_context()
    end, { silent = true })
  end
}
}
