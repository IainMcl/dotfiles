set nocompatible
filetype off

syntax on 
set rnu
set nu
set encoding=utf-8
let mapleader=" "
set noerrorbells
set vb t_vb=

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

set noswapfile
set nobackup

set nowrap
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
set formatoptions=tcqrn1

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

nnoremap <A-j> :m +1<CR>
nnoremap <A-k> :m -1<CR>

nnoremap <Leader>= :vertical resize +5<CR>
nnoremap <Leader>+ :resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>_ :resize -5<CR>


