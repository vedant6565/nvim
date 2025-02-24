return {
  'dmmulroy/ts-error-translator.nvim',
  cunfig = function()
    require('ts-error-translator').setup {
      auto_override_publish_diagnostics = true,
    }
  end,
}
