vim.keymap.set('n', '<leader>pv', ':Ex')
vim.keymap.set('n', '<leader>oi', ':OrganizeImports<CR>')
-- vim.keymap.set('n', '<leader>oi', ':TSToolsOrganizeImports<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Copy to system clipbord' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Copy line to system clipbord' })

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<leader>z', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Select and change word' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-h>', '<cmd> TmuxNavigateLeft<CR>')
vim.keymap.set('n', '<C-j>', '<cmd> TmuxNavigateDown<CR>')
vim.keymap.set('n', '<C-l>', '<cmd> TmuxNavigateRight<CR>')
vim.keymap.set('n', '<C-k>', '<cmd> TmuxNavigateUp<CR>')
vim.keymap.set('n', '<leader>U', '<cmd>UndotreeToggle<CR>')

vim.keymap.set('n', '-', ':Oil<CR>', { desc = 'Open parent directory' })

vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Git [P]review' })
vim.keymap.set({ 'n', 'v' }, '<leader>gd', ':DiffviewFileHistory<CR>', { desc = 'Git [D]iff' })
vim.keymap.set('n', '<leader>gcd', ':DiffviewClose<CR>', { desc = 'Git [C]lose Diff' })
vim.keymap.set('n', '<leader>gcf', ':DiffviewFileHistory %<CR>', { desc = 'Git [C]urrent Diff' })
