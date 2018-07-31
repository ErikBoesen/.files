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
"set mouse=a

" --- Vundle ---
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'HeroCC/moos-vim-syntax'
Plugin 'lervag/vimtex'
Plugin 'keith/swift.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'darfink/vim-plist'
" Theme
Plugin 'ErikBoesen/vim-brogrammer-theme'
Plugin 'frc1418/vim-victis'

call vundle#end()
filetype plugin indent on

colorscheme brogrammer
"colorscheme victis
hi Normal guibg=NONE ctermbg=NONE

" Remove trailing whitespace on write
autocmd BufWritePre * %s/\s\+$//e

map <F7> mzgg=G`z " Reindent entire file
map r :source ~/.vimrc<CR>
map [ gT<CR>
map ] gt<CR>
