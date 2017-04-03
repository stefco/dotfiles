set autoread " automatically read file updates

set shiftround " when indenting, indent to a multiple of shiftwidth.
set expandtab
set autoindent
set softtabstop=4
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" turn on folding
set foldmethod=indent

set number
set mouse=a
filetype on
syntax on

"put a colored column at column 81 to show suggested max line length
set colorcolumn=81

"next or previous open file
noremap <F3> :n<CR>
noremap <F2> :N<CR>

"next or previous vimgrep match
noremap <S-Up> :cp<CR>
noremap <S-Down> :cn<CR>

" allow mouse past 220th column
" http://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
set ttymouse=sgr
                                                                                                                                                                                                                                                          
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Send more characters for redraws
set ttyfast

" Show a status line
set laststatus=2

" make it possible to edit crontabs in vim.
if $VIM_CRONTAB == "true"
set nobackup
set nowritebackup
endif

" toggle fold with spacebar
noremap <Space> za
