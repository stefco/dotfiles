set autoread " automatically read file updates

set shiftround " when indenting, indent to a multiple of shiftwidth.
set expandtab
set autoindent

set number
set mouse=a
filetype on
syntax on

"put a colored column at column 81 to show suggested max line length
set colorcolumn=81
set softtabstop=4
set tabstop=4
set shiftwidth=4

"next or previous open file
noremap <F3> :n<CR>
noremap <F2> :N<CR>

" allow mouse past 220th column
" http://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
set ttymouse=sgr

" make sure the correct mouse codes are being interpreted, EVEN IN TMUX
set ttymouse=xterm2
