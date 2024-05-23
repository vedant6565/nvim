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

  local time = tostring(os.date()):sub(12, 16)
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

-- nerdfont: powerline icons have the prefix 'ple-'
local bottomSeparators = { left = '', right = '' }
local topSeparators = { left = '', right = '' }
local emptySeparators = { left = '', right = '' }
local branch_max_width = 40
local branch_min_width = 10

local lualineConfig = {
  -- INFO using the tabline will override vim's default tabline, so the tabline
  -- should always include the tab element
  tabline = {
    lualine_a = {
      -- INFO setting different section separators in the same components has
      -- yanky results, they should have the same separator
      -- searchcounter at the top, so it work with cmdheight=0
      { clock, section_separators = emptySeparators },
      {
        'tabs',
        mode = 1,
        max_length = vim.o.columns * 0.7,
        section_separators = emptySeparators,
        cond = function()
          return fn.tabpagenr '$' > 1
        end,
      },
    },
    lualine_b = {
      { section_separators = topSeparators },
    },
    lualine_c = {},
    lualine_x = {},
    -- INFO dap and recording status defined in the respective plugin configs
    -- for lualine_y and lualine_z for their lazy loading
    lualine_y = {
      { markM },
    },
    lualine_z = {},
  },
  sections = {
    lualine_a = {
      { 'branch', cond = isStandardBranch },
      { currentFile },
    },
    lualine_b = {
      {
        function()
          local lsps = vim.lsp.get_active_clients { bufnr = vim.fn.bufnr() }
          local icon = require('nvim-web-devicons').get_icon_by_filetype(vim.api.nvim_buf_get_option(0, 'filetype'))
          if lsps and #lsps > 0 then
            local names = {}
            for _, lsp in ipairs(lsps) do
              table.insert(names, lsp.name)
            end
            return string.format('%s %s', table.concat(names, ', '), icon)
          else
            return icon or ''
          end
        end,
        on_click = function()
          vim.api.nvim_command 'LspInfo'
        end,
        color = function()
          local _, color = require('nvim-web-devicons').get_icon_cterm_color_by_filetype(vim.api.nvim_buf_get_option(0, 'filetype'))
          return { fg = color }
        end,
      },
      'encoding',
      'progress',
    },
    lualine_c = {
      'mode',
      {
        'branch',
        fmt = function(output)
          local win_width = vim.o.columns
          local max = branch_max_width
          if win_width * 0.25 < max then
            max = math.floor(win_width * 0.25)
          end
          if max < branch_min_width then
            max = branch_min_width
          end
          if max % 2 ~= 0 then
            max = max + 1
          end
          if output:len() >= max then
            return output:sub(1, (max / 2) - 1) .. '...' .. output:sub(-1 * ((max / 2) - 1), -1)
          end
          return output
        end,
      },
    },
    lualine_x = {
      {
        'diagnostics',
        symbols = { error = '󰅚 ', warn = ' ', info = '󰋽 ', hint = '󰘥 ' },
      },
    },
    lualine_y = {
      'diff',
    },
    lualine_z = {
      { selectionCount, padding = { left = 0, right = 1 } },
      'location',
    },
  },
  options = {
    refresh = { statusline = 1000 },
    ignore_focus = {
      'DressingInput',
      'DressingSelect',
      'ccc-ui',
    },
    globalstatus = true,
    component_separators = { left = '', right = '' },
    section_separators = bottomSeparators,
  },
}

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
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { currentFile },
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
