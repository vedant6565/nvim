return {
  'wfxr/minimap.vim',
  as = 'minimap',
  config = function()
    vim.g.minimap_auto_start = 1
    vim.g.minimap_auto_start_win_enter = 1
    vim.g.minimap_width = 10
    vim.g.minimap_highlight_range = 1
    vim.g.minimap_highlight_search = 1
    vim.g.minimap_auto_start = 1
    vim.g.minimap_auto_start_win_enter = 1
    vim.g.minimap_auto_start_filetypes = {
      'markdown',
      'vimwiki',
      'text',
      'help',
      'lua',
      'typescript',
      'javascript',
      'typescriptreact',
      'javascriptreact',
      'json',
      'yaml',
      'html',
      'css',
    }
  end,
}
