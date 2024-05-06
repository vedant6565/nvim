return {
  'kdheepak/lazygit.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'lazy [G]it' })
  end,
}
