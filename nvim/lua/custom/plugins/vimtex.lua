return {
  {
    'lervag/vimtex',
    lazy = false, -- Load immediately (not lazily)
    init = function()
      -- Enable filetype plugins and syntax
      vim.cmd 'filetype plugin indent on'
      vim.cmd 'syntax enable'

      -- Viewer method (Skim on macOS)
      vim.g.vimtex_view_method = 'skim'

      -- Quickfix filter
      vim.g.vimtex_quickfix_ignore_filters = {
        'theHpagenote',
        'Font Warning',
        'FiXme',
      }

      -- Optionally disable quickfix window opening
      -- vim.g.vimtex_quickfix_enabled = 0

      -- Math environment mappings
      vim.cmd 'nmap dsm <Plug>(vimtex-env-delete-math)'
      vim.cmd 'nmap tsm <Plug>(vimtex-env-toggle-math)'
      vim.cmd 'nmap csm <Plug>(vimtex-env-change-math)'

      -- Vim text objects for math items
      vim.cmd 'omap ai <Plug>(vimtex-am)'
      vim.cmd 'xmap ai <Plug>(vimtex-am)'
      vim.cmd 'omap ii <Plug>(vimtex-im)'
      vim.cmd 'xmap ii <Plug>(vimtex-im)'
      vim.cmd 'omap am <Plug>(vimtex-a$)'
      vim.cmd 'xmap am <Plug>(vimtex-a$)'
      vim.cmd 'omap im <Plug>(vimtex-i$)'
      vim.cmd 'xmap im <Plug>(vimtex-i$)'
    end,
  },
}
