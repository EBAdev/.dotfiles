
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



-- remap to open vim-fugitive
vim.keymap.set("n", "<leader>gs", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)

    -- Match any fugitive status buffer
    if name:match("^fugitive://.*//") then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  -- If not found, open it
  vim.cmd("G")
end, { desc = "Toggle Fugitive Git status" })

-- remap to push
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
