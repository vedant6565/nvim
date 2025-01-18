return {
  'andrewferrier/debugprint.nvim',
  dependencies = {
    'echasnovski/mini.nvim',
  },
  lazy = false,
  version = '*',
  config = function()
    require('debugprint').setup {}
  end,
}
