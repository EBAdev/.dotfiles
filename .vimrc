let mapleader = ","
let maplocalleader = ","
  
" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Stop vim .swp files as backup happens through autosave.
set noswapfile
" -----------------------------------------------------------------------------
"  VimPlug plugins
" -----------------------------------------------------------------------------

call plug#begin()


"--UltiSnips (Vim snippets)--"
Plug 'sirver/ultisnips'
    let g:UltiSnipsExpandTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

"--- vimtex (LaTex compiler)---"
Plug 'lervag/vimtex'
    let g:tex_flavor='latex'
    let g:vimtex_view_method='skim'
    let g:vimtex_quickfix_ignore_filters = [
          \ 'Underfull',
          \]
    
" Use `dsm` to delete surrounding math (replacing the default shorcut `ds$`)
nmap dsm <Plug>(vimtex-env-delete-math)

" Use `ai` and `ii` for the item text object
omap ai <Plug>(vimtex-am)
xmap ai <Plug>(vimtex-am)
omap ii <Plug>(vimtex-im)
xmap ii <Plug>(vimtex-im)

" Use `am` and `im` for the inline math text object
omap am <Plug>(vimtex-a$)
xmap am <Plug>(vimtex-a$)
omap im <Plug>(vimtex-i$)
xmap im <Plug>(vimtex-i$)

"--- tex-conceal (collapsing of env in .tex)---"    
Plug 'KeitaNakamura/tex-conceal.vim'
    set conceallevel=1
    let g:tex_conceal='abdmg'
    hi Conceal ctermbg=none

"--- Spell-Checker  --- "
setlocal spell
set spelllang=en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" -- Autosave -- "
Plug '907th/vim-auto-save'
let g:auto_save = 1

" -- Color scheme --- "
Plug 'nordtheme/vim'

" Status line plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1

"configure airline status bar for Fira code.
let g:airline_left_sep=' '
let g:airline_right_sep=' '

" fix delay when leaving insert mode.
set ttimeoutlen=50

" --- FUZZY FINDER ----
" fzf native plugin
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" fzf.vim
Plug 'junegunn/fzf.vim'

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
" Handle conflicts with UltiSnips
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
" setup vimtex to talk to YCM
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme



call plug#end()




" -----------------------------------------------------------------------------
"  GENERAL SETTINGS FOR EVERYONE
"  ----------------------------------------------------------------------------
" Turn on syntax highlighting
syntax on

" set colorscheme to nord
colorscheme nord


" For plugins to load correctly
filetype plugin indent on

" Security
set modelines=0

"Show file stats
set ruler

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=80
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=5
set backspace=indent,eol,start

"Make line numbers yellow and appear relative
hi LineNr guifg=yellow ctermfg=yellow
set number
set relativenumber

" use mouse for scroll or window size
set mouse=a 

"Remove Bell sound and visual cue
set belloff=all

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch


" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬

" Create toggle for YCM plugin
nnoremap <silent> <leader>y :let g:ycm_auto_trigger = 1 - g:ycm_auto_trigger<CR>

" Git-ignore for Fzf command
" Configure FZF with grep for searching with file exclusion
command! -bang -nargs=* Fzf
      \ call fzf#run({
      \   'source': 'find . -type f -not -path "*.swp" -not -name "*.out" -not -name "*.aux" -not -name "*.fdb_latexmk" -not -name "*.pdf" -not -name "*.DS_Store" -not -name "*.gz" -not -name "*.fls" -not -name "*.log" -not -name "*.toc"',
      \   'sink':  'e',
      \   'options': '--ansi --prompt="Go to> " --preview "bat --color=always {}" --preview-window "50%"'
      \ })

" Map a keybinding for quick search
nnoremap <leader>g :Fzf <CR>


" allow copying to clipboard
set clipboard=unnamed

