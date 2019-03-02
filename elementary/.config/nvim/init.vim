"
" General
"

set encoding=utf-8
set fileencoding=utf-8

set number
set ruler
set showcmd
set autoindent

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

syntax on

set ttyfast

"
" Plugins
"

call plug#begin()

Plug 'scrooloose/nerdtree'
Plug 'rust-lang/rust.vim'

call plug#end()

"
" Visuals
"

set t_Co=256

colorscheme default
set background=dark

"
" Keybinds
"

" Better Escape binding.
inoremap jj <Esc>

" Don't use arrow keys!
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Really, just don't.
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
