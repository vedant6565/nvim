return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {}
    vim.keymap.set('n', '[c', function()
      require('treesitter-context').go_to_context()
    end, { silent = true })
    vim.keymap.set('n', '<leader>tc', function()
      require('treesitter-context').toggle()
    end, { silent = true })
  end,
}
