return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'BurntSushi/ripgrep',
    'folke/trouble.nvim',
  },
  config = function()
    require('spectre').setup { is_block_ui_break = true }
    vim.keymap.set('n', '<leader>fr', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = 'Toggle Spectre',
    })
    vim.keymap.set('n', '<leader>fw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = 'Search current word',
    })
    vim.keymap.set('v', '<leader>fsw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = 'Search current word',
    })
    vim.keymap.set('n', '<leader>fsp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = 'Search on current file',
    })
  end,
}
