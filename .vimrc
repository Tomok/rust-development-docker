execute pathogen#infect()
set t_Co=256
syntax on
filetype plugin indent on

set relativenumber
set number

let g:airline#extensions#tabline#enabled=1
let g:airline_theme='deus'
""Powerline fonts do not seem to work in docker, so don't enable them for now
"let g:airline_powerline_fonts=1
