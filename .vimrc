set encoding=utf-8
scriptencoding utf-8

" install plug for plugin managment
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rust-lang/rust.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'Valloric/YouCompleteMe'

call plug#end()


"set 256 color mode
set t_Co=256

" disable vi-compatible mode
set nocp

set tabstop=4
" Display tabs & trailing whitespace - does only work in utf-8 mode due to
" special character
set list
set listchars=tab:>-,trail:·

"Do not automatically fix eol
set nofixeol

set relativenumber
set number

"Modify scrolloff (number of lines remaining visible e.g. when using z [Enter]
set scrolloff=5

" if wrapping is allowed indent wrapped lines as much as parent line
set breakindent

"hide toolbar in gvim
set guioptions-=T

let g:airline#extensions#tabline#enabled=1
let g:airline_theme='deus'
"to enable or disable powerline fonts:
"let g:airline_powerline_fonts=1

"enable mouse support in console
set mouse=a

"set rust src path for YouCompleteMe
let g:ycm_rust_src_path='/home/dev/rust-src/rustc-1.29.1-src/src'
