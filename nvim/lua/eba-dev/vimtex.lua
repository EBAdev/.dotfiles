-- This is necessary for VimTeX to load properly. The "indent" is optional.
-- Note that most plugin managers will do this automatically.
vim.cmd("filetype plugin indent on")

-- This enables Vim's and neovim's syntax-related features. Without this, some
-- VimTeX features will not work (see ":help vimtex-requirements" for more info).
vim.cmd("syntax enable")

-- Viewer options: One may configure the viewer either by specifying a built-in
-- viewer method:
vim.g.vimtex_view_method = 'skim'

vim.g.vimtex_quickfix_ignore_filters = {'theHpagenote', 'Font Warning', 'FiXme'}

-- Stop quickfix window from opening
--vim.g.vimtex_quickfix_enabled = 0


--- VIMTEX remaps
--- Modify keybindings for math enviorments
vim.cmd("nmap dsm <Plug>(vimtex-env-delete-math)")
vim.cmd("nmap tsm <Plug>(vimtex-env-toggle-math)")
vim.cmd("nmap csm <Plug>(vimtex-env-change-math)")


--- Modify Commands for Vim Text objects
--- Use `ai` and `ii` to select the item text object
vim.cmd("omap ai <Plug>(vimtex-am)")
vim.cmd("xmap ai <Plug>(vimtex-am)")
vim.cmd("omap ii <Plug>(vimtex-im)")
vim.cmd("xmap ii <Plug>(vimtex-im)")


-- Use `am` and `im` to select the inline math text object
vim.cmd("omap am <Plug>(vimtex-a$)")
vim.cmd("xmap am <Plug>(vimtex-a$)")
vim.cmd("omap im <Plug>(vimtex-i$)")
vim.cmd("xmap im <Plug>(vimtex-i$)")
