return {
  'voldikss/vim-floaterm',
  keys = {
    { '<leader>tt', ':FloatermToggle<CR>', desc = 'Toggle Floating Terminal' },
    { '<F2>', ':FloatermToggle<CR>', desc = 'Toggle Floating Terminal' },
  },
  config = function()
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.floaterm_wintype = 'float'
    vim.g.floaterm_position = 'center'
    vim.g.floaterm_autoclose = 1
  end,
}
