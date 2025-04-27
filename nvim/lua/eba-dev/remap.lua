

vim.g.mapleader = ","
vim.g.maplocalleader = ","


vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.g.netrw_list_hide = " *.aux, *.pdf, *.png, *.DS_Store, *.log, *.fls, *.out, *.toc, *.gz, *.fdb_latexmk, *.synctex"

-- Autocommand for file explorer to give numbers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.wo.number = true         -- enable absolute numbers
    vim.wo.relativenumber = true -- optional: enable relative numbers
  end
})



-- fix UltiSnips & YCM tab trigger 
local vimscript = [[
function! g:UltiSnips_Complete()
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 0
    if pumvisible()
      return "\<C-n>"
    else
      call UltiSnips#JumpForwards()
      if g:ulti_jump_forwards_res == 0
        return "\<TAB>"
      endif
    endif
  endif
  return ""
endfunction

function! g:UltiSnips_Reverse()
  call UltiSnips#JumpBackwards()
  if g:ulti_jump_backwards_res == 0
    return "\<C-P>"
  endif

  return ""
endfunction


if !exists("g:UltiSnipsJumpForwardTrigger")
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
endif

if !exists("g:UltiSnipsJumpBackwardTrigger")
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
endif

au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger     . " <C-R>=g:UltiSnips_Complete()<cr>"
au InsertEnter * exec "inoremap <silent> " .     g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
]]

vim.api.nvim_exec(vimscript, false)

-- Function to toggle YouCompleteMe
function ToggleYouCompleteMe()
  -- Check if YouCompleteMe is already enabled
  if vim.g.ycm_auto_trigger == 1 then
    -- Disable YouCompleteMe
    vim.g.ycm_auto_trigger = 0
    print("YouCompleteMe Disabled")
  else
    -- Enable YouCompleteMe
    vim.g.ycm_auto_trigger = 1
    print("YouCompleteMe Enabled")
  end
end

-- Keymap to toggle YouCompleteMe with Control+Y
vim.keymap.set("n", "<C-y>", "<cmd>lua ToggleYouCompleteMe()<CR>")

