
vim.g.mapleader = " "
vim.g.maplocalleader = " "


vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


vim.g.netrw_list_hide = "*.aux, *.pdf, *.png, *.DS_Store, *.log, *.fls, *.out, *.toc, *.gz, *.fdb_latexmk, *.synctex"


-- Autocommand for file explorer to give numbers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.wo.number = true         -- enable absolute numbers
    vim.wo.relativenumber = true -- optional: enable relative numbers
  end
})

