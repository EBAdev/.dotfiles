-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>e', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_pattern = { -- glob style patterns
          '*.pdf',
          '*.log',
          '*.tmp',
          '*.bak',
          '*.swp',
          '*.aux',
          '*.out',
          '*.toc',
          '*.dvi',
          '*.fdb_latexmk',
          '*.fls',
          '*.synctex.gz',
          '*.bbl',
          '*.blg',
          '*.run.xml',
          '*.bcf',
        },
        hide_by_name = {
          'node_modules',
          '.DS_Store',
          'thumbs.db',
          '.git',
        },
      },
      window = {
        mappings = {
          ['<leader>e'] = 'close_window',
        },
      },
    },
  },
}
