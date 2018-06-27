syntax on
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set clipboard=unnamed
set number
set backspace=2
" Enable mouse
set mouse=a

" --- Vundle ---
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'HeroCC/moos-vim-syntax'
Plugin 'lervag/vimtex'
Plugin 'darfink/vim-plist'
" Theme
Plugin 'AlessandroYorba/Sierra'

call vundle#end()
filetype plugin indent on

let g:sierra_Midnight = 1
colorscheme sierra
hi Normal guibg=NONE ctermbg=NONE

map <F7> mzgg=G`z " Reindent entire file
