syntax on

filetype plugin indent on 

colorscheme peachpuff

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

function! Json()
   :%!python -m json.tool
endfunction

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

Plug 'isRuslan/vim-es6'

Plug 'mxw/vim-jsx'

Plug 'govim/govim'

Plug 'matze/vim-move'

call plug#end()            

let g:clojure_syntax_keywords = {
    \ 'clojureDefine': ["defproject", "s/defn"]
    \ }

let g:move_key_modifier='C'
let g:rustfmt_autosave=1
let mapleader='\'
