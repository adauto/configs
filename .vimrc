vim9script

syntax on

filetype plugin indent on 

colorscheme adauto

hi Pmenu ctermbg=235 ctermfg=white
hi CocFloating ctermbg=235

set mouse-=a
set clipboard=unnamed
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set ma
set number
set ruler
set hlsearch
set nocompatible
set laststatus=1
set backspace=indent,eol,start
set rtp+=~/.vim/bundle/Vundle.vim
set encoding=UTF-8

def Json()
   :%!python3 -m json.tool
enddef

call plug#begin()

Plug 'VundleVim/Vundle.vim'

Plug 'jremmen/vim-ripgrep'

Plug 'tpope/vim-fugitive'

Plug 'cespare/vim-toml', { 'branch': 'main' }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'junegunn/fzf.vim'

Plug 'rust-lang/rust.vim'

Plug 'https://tpope.io/vim/fireplace'

Plug 'https://github.com/guns/vim-clojure-static'

Plug 'preservim/nerdtree'

Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'ryanoasis/vim-devicons'

# Plug 'isRuslan/vim-es6'
# Plug 'mxw/vim-jsx'
 
Plug 'leafgarland/typescript-vim'

Plug 'govim/govim'

Plug 'matze/vim-move'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()            

g:clojure_syntax_keywords = {
  \ 'clojureDefine': ["defproject", "s/defn"]
  \ }

# Configs fzf
nnoremap <C-f> :Files<CR>

# Configs for coc.java 
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

# Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

def ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
enddef

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

def CheckBackspace(): bool
  var col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
enddef

command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

command! -nargs=0 FM :call CocActionAsync('format')

g:move_key_modifier = 'C'
g:rustfmt_autosave = 1
#g:mapleader = '\'

# Configs nerdtree
var fgreen = "8FAA54"
g:WebDevIconsDefaultFolderSymbolColor = fgreen

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
# nnoremap <C-f> :NERDTreeFind<CR>
