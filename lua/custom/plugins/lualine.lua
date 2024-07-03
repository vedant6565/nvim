local bo = vim.bo
local fn = vim.fn
--------------------------------------------------------------------------------

--- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/branch/git_branch.lua#L118
---@nodiscard
---@return boolean
local function isStandardBranch()
  -- checking via lualine API, to not call git outself
  local curBranch = require('lualine.components.branch.git_branch').get_branch()
  local notMainBranch = curBranch ~= 'main' and curBranch ~= 'master'
  local validFiletype = bo.filetype ~= 'help' -- vim help files are located in a git repo
  local notSpecialBuffer = bo.buftype == ''
  return notMainBranch and validFiletype and notSpecialBuffer
end

--------------------------------------------------------------------------------

local function selectionCount()
  local isVisualMode = fn.mode():find '[Vv]'
  if not isVisualMode then
    return ''
  end
  local starts = fn.line 'v'
  local ends = fn.line '.'
  local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
  return ' ' .. tostring(lines) .. 'L ' .. tostring(fn.wordcount().visual_chars) .. 'C'
end

-- shows global mark M
vim.api.nvim_del_mark 'M' -- reset on session start
local function markM()
  local markObj = vim.api.nvim_get_mark('M', {})
  local markLn = markObj[1]
  local markBufname = vim.fs.basename(markObj[4])
  if markBufname == '' then
    return ''
  end -- mark not set
  return ' ' .. markBufname .. ':' .. markLn
end

-- only show the clock when fullscreen (= it covers the menubar clock)
local function clock()
  if vim.opt.columns:get() < 110 or vim.opt.lines:get() < 25 then
    return ''
  end

  local time = tostring(os.date '%I:%M %p')
  if os.time() % 2 == 1 then
    time = time:gsub(':', ' ')
  end -- make the `:` blink
  return time
end

-- wrapper to not require navic directly
-- local function navicBreadcrumbs()
--   if bo.filetype == 'css' or not require('nvim-navic').is_available() then
--     return ''
--   end
--   return require('nvim-navic').get_location()
-- end

--------------------------------------------------------------------------------

---improves upon the default statusline components by having properly working icons
---@nodiscard
local function currentFile()
  local maxLen = 25

  local ext = fn.expand '%:e'
  local ft = bo.filetype
  local name = fn.expand '%:t'
  if ft == 'octo' and name:find '^%d$' then
    name = '#' .. name
  elseif ft == 'TelescopePrompt' then
    name = 'Telescope'
  end

  local deviconsInstalled, devicons = pcall(require, 'nvim-web-devicons')
  local ftOrExt = ext ~= '' and ext or ft
  if ftOrExt == 'javascript' then
    ftOrExt = 'js'
  end
  if ftOrExt == 'typescript' then
    ftOrExt = 'ts'
  end
  if ftOrExt == 'markdown' then
    ftOrExt = 'md'
  end
  if ftOrExt == 'vimrc' then
    ftOrExt = 'vim'
  end
  local icon = deviconsInstalled and devicons.get_icon(name, ftOrExt) or ''
  -- add sourcegraph icon for clarity
  if fn.expand('%'):find '^sg' then
    icon = '󰓁 ' .. icon
  end

  -- truncate
  local nameNoExt = name:gsub('%.%w+$', '')
  if #nameNoExt > maxLen then
    name = nameNoExt:sub(1, maxLen) .. '…' .. ext
  end
  local type = vim.api.nvim_buf_get_option(0, 'filetype')
  local file = vim.fn.expand '%:p:t'
  local path = vim.fn.expand '%:p:h:t'
  local the_file = path .. '/' .. file

  if file == '' then
    the_file = ''
  end -- Buffer
  if file == '[packer]' then
    the_file = '[packer]'
  end
  if file == '[BOXdash]' then
    the_file = '[BOXdash]'
  end
  if type == 'help' then
    the_file = '[help]: ' .. file
  end
  if type == 'lazy' then
    the_file = '[lazy.nvim]'
  end
  if the_file == '.git/COMMIT_EDITMSG' then
    the_file = '[Git commit]'
  end

  if icon == '' then
    return name
  end
  return icon .. ' ' .. the_file
end

--------------------------------------------------------------------------------

-- FIX Add missing buffer names for current file component
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lazy', 'mason', 'TelescopePrompt', 'noice' },
  callback = function()
    local name = vim.fn.expand '<amatch>'
    name = name:sub(1, 1):upper() .. name:sub(2) -- capitalize
    pcall(vim.api.nvim_buf_set_name, 0, name)
  end,
})

local config = {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 2000,
      tabline = 2000,
      winbar = 2000,
    },
  },
  sections = {
    lualine_a = { 'mode', clock, markM },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      currentFile,
      {
        function()
          local count = 0
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, 'modified') then
              count = count + 1
              -- return 'Unsaved buffers' -- any message or icon
            end
          end
          if count > 0 then
            return count .. ' Unsaved'
          end
          return ''
        end,
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}

--------------------------------------------------------------------------------

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup(config)
  end,
}
