" automatically read file updates
set autoread

" use filetype and syntax
filetype on
syntax on

" indent settings
set shiftround " when indenting, indent to a multiple of shiftwidth.
set expandtab
set autoindent
set softtabstop=4
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" set 2-space indent for HTML, CSS, and JSON
autocmd FileType html,css,json set softtabstop=2|set tabstop=2|set shiftwidth=2

" turn on folding
set foldmethod=indent

" use line-numbers and mouse-interaction
set number
set mouse=a

" do an incremental search and highlight results
set incsearch
set hlsearch

" put a colored column at column 80 to show suggested max line length
set colorcolumn=80

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

" next or previous open file
noremap <Right> :n<CR>
noremap <Left> :N<CR>

" next or previous vimgrep match
noremap <S-Up> :cp<CR>
noremap <S-Down> :cn<CR>

" toggle search highlighting
noremap - :set hlsearch!<CR>

" toggle fold with spacebar
noremap <Space> zA

" toggle smartypants crap, i.e. linenumbers, autoindent, smartindent, and mouse
" with delete, aka backspace
noremap <Bs> :call ToggleInteractive()<CR>
function! ToggleInteractive()
    setlocal number!
    setlocal autoindent!
    setlocal smartindent!
    if &mouse == "a"
        setlocal mouse=
    else
        setlocal mouse=a
    endif
endfunction

" toggle folding for whole document
noremap <CR> :call ToggleFolding()<CR>
function! ToggleFolding()
    if exists('b:stefco_is_whole_file_folded')
        if b:stefco_is_whole_file_folded
            echom "unfolding."
            execute "normal! ggVGzO\<C-O>\<C-O>"
            let b:stefco_is_whole_file_folded=0
        else
            echom "folding."
            execute "normal! ggVGzC\<C-O>\<C-O>"
            let b:stefco_is_whole_file_folded=1
        endif
    else
        echom "fold state undefined, assuming folded; unfolding."
        execute "normal! ggVGzO\<C-O>\<C-O>"
        let b:stefco_is_whole_file_folded=0
    endif
endfunction
