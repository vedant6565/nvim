return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      columns = {
        { 'icon', highlight = 'Special' },
        { 'size', highlight = 'Special' },
      },
      view_options = {
        show_hidden = true,
      },
    }
  end,
}
