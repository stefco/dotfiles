"------------------------------------------------------------------------------
" load vundle
"------------------------------------------------------------------------------

" these settings are required for Vundle
set nocompatible
filetype off

" set the runtime path
set rtp+=~/dev/dotfiles/submodules/Vundle.vim
call vundle#begin('~/dev/dotfiles/linkfiles/.vim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
" simpylfold does not seem to be working :\
"Plugin 'tmhedberg/SimpylFold'
" syntastic is very slow and not asynchronous
"Plugin 'vim-syntastic/syntastic'
Plugin 'neomake/neomake'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ctrlpvim/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required

"------------------------------------------------------------------------------
" my prefs
"------------------------------------------------------------------------------

" automatically read file updates
set autoread

" use filetype and syntax
filetype indent on
syntax on

" don't word wrap
set nowrap

" italicize comments
highlight Comment cterm=italic

" run Neomake on write
autocmd! BufWritePost * Neomake

" indent settings
let g:pymode_indent = 0
set shiftround " when indenting, indent to a multiple of shiftwidth.
set expandtab
set autoindent
set softtabstop=4
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" set 2-space indent for HTML, CSS, and JSON
autocmd FileType html,css,json set softtabstop=2|set tabstop=2|set shiftwidth=2

" force .md to be interpreted as Markdown, include code syntax
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
let g:markdown_syntax_conceal = 0

" ignore .pyc files in nerdtree
let NERDTreeIgnore=['\.pyc$', '\~$']

" show hidden files and bookmarks by default
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1

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
" note that this is not a supported feature of neovim, so don't run in that
" case.
if ! has('nvim')
    set ttymouse=sgr
endif

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

" next or previous window
noremap <Up> <C-w>W
noremap <Down> <C-w>w

" next or previous tab
noremap <Left> gT
noremap <Right> gt

" next or previous open file
noremap <S-Right> :n<CR>
noremap <S-Left> :N<CR>

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

" resolve symlink for this file, if it is a symlink
noremap <Leader>l :Gresolvelink<CR>
" Follow symlinks when opening a file
" Sources:
"  - https://github.com/tpope/vim-fugitive/issues/147#issuecomment-7572351
"  - http://www.reddit.com/r/vim/comments/yhsn6/is_it_possible_to_work_around_the_symlink_bug/c5w91qw
" Echoing a warning does not appear to work:
"   echohl WarningMsg | echo "Resolving symlink." | echohl None |
function! MyGitResolveSymlink(...)
    let fname = a:0 ? a:1 : expand('%')
    if getftype(fname) != 'link'
        return
    endif
    let resolvedfile = fnameescape(resolve(fname))

    " we want to avoid a warning for editing a file with existing swapfile
    let oldshortmess=&shortmess
    set shortmess+=A

    " open the file
    exec 'file ' . resolvedfile

    " reset warnings
    let &shortmess=oldshortmess

    " tell fugitive to use the resolved file name
    call fugitive#detect(resolvedfile)

    " force write if the file is unmodified (to eliminate the warning)
    if ! &modified
        write!
    endif
endfunction
command! Gresolvelink call MyGitResolveSymlink()
" uncomment the line below to reolve symlinks at start
"autocmd BufReadPost * call MyGitResolveSymlink(expand('<afile>'))

" sync syntax from start with <Leader>s (default leader is \)
map <Leader>s :syntax sync fromstart<CR>

" git pull
map gp :Gpull<CR>

" git push
map gP :Gpush<CR>

" open nerdtree
map gn :NERDTreeToggle<CR>

" run help for some string
map gh :help 

" check mappings
map gm :map 

" load .vimrc
map gl :source ~/.vimrc<CR>

" show git status
nnoremap gs :Gstatus<CR>

" git diff this file
nnoremap gd :Gdiff<CR>

" run git diff in CWD
nnoremap gD :!git diff<CR>

" git commit
nnoremap gc :Gcommit<CR>

" git grep
nnoremap gG :Ggrep 

" git read; do a git checkout to the buffer
nnoremap gr :Gread 

" git write; writes to both the work tree and index versions of file, making
" it like `git add` when called from a work tree file and like `git checkout`
" when called from the index or a blob in the history
nnoremap gw :Gwrite<CR>

" git write (to index) and then commit
nnoremap gW :Gwrite<CR>:Gcommit<CR>

" some stuff for working with interactive sessions in python

" place contents of ipyscratch at cursor
autocmd FileType python nnoremap giP   :.-1r ~/.ipyscratch<CR>
"autocmd FileType python nnoremap <A-V> :.-1r ~/.ipyscratch<CR><C-c>

" place contents of ipyscratch below cursor
autocmd FileType python nnoremap gip   :r ~/.ipyscratch<CR>
"autocmd FileType python nnoremap <A-v> :r ~/.ipyscratch<CR><C-c>

" replace selection with contents of ipyscratch
autocmd FileType python vnoremap gip   c<ESC>:r ~/.ipyscratch<CR>kdd
"autocmd FileType python vnoremap <A-v> c<ESC>:r ~/.ipyscratch<CR>kdd<C-c>

" write selection to ipyscratch
autocmd FileType python vnoremap giw   :w! ~/.ipyscratch<CR>
"autocmd FileType python vnoremap <A-c> :w! ~/.ipyscratch<CR><C-c>

" yank selection and write it to ipyscratch
autocmd FileType python vnoremap giy   :w! ~/.ipyscratch<CR>gvd
"autocmd FileType python vnoremap <A-x> :w! ~/.ipyscratch<CR>gvd<C-c>

" neovim-specific shortcuts go here
if has('nvim')
    " <Esc> enters normal mode in term mode instead of sending <Esc> to term
    "tnoremap <Leader><Esc> <C-\><C-n>

    " Launch term with leader keys
    noremap <Leader>tv :vsp<CR>:term<CR>
    noremap <Leader>ts :sp<CR>:term<CR>
endif
