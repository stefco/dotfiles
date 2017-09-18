"------------------------------------------------------------------------------
" load vundle
"------------------------------------------------------------------------------

" these settings are required for Vundle
set nocompatible
filetype off

" use unicode
set encoding=utf8

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
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ryanoasis/vim-devicons'
" let me not use this for now and instead see how vim-dispatch treats me
" Plugin 'janko-m/vim-test'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-commentary.git'
" smart date incrementing
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
" case changes/complex substitutions/programmable autocorrect
Plugin 'tpope/tpope-vim-abolish'
" add repeatability to supporting custom plugins
Plugin 'tpope/vim-repeat'
" add async via iterm and tmux to vim
Plugin 'tpope/vim-dispatch'
" nice wrapper for existing persistence/session saving vim functionality!
" Plugin 'tpope/vim-obsession'
" add extra '[' and ']' mappings
" Plugin 'tpope/vim-unimpaired'
" add some unix sugar
" Plugin 'tpope/vim-eunuch'
" tmux bindings for vim with nice tab completion
" Plugin 'tpope/vim-tbone'
" JSON tools
" Plugin 'tpope/vim-jdaddy'

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

" automatically enter after 79 characters; requires 't' to be in formatoptions.
set textwidth=79

" define comment strings for various langs
autocmd FileType vim setlocal commentstring=\"\ %s

" set the <Leader> key to space
let mapleader = ' '

" italicize comments
highlight Comment cterm=italic

" make current line number a different color
hi CursorLineNR ctermfg=Magenta cterm=bold
augroup CLNRSet
    autocmd! ColorScheme * hi CursorLineNR ctermfg=Yellow
augroup END

" run Neomake on write
autocmd! BufWritePost * Neomake

" display all buffs in tab bar when only one tab is open
let g:airline#extensions#tabline#enabled = 1

" use the base16 airline theme. some favs below.
"let g:airline_theme = 'laederon'
"let g:airline_theme = 'raven'
"let g:airline_theme = 'papercolor'
"let g:airline_theme = 'monochrome'
"let g:airline_theme = 'jellybeans'
"let g:airline_theme = 'distinguished'
"let g:airline_theme = 'cool'
let g:airline_theme = 'behelit'
"let g:airline_theme = 'aurora'

" use airline powerline fonts
let g:airline_powerline_fonts = 1

" change airline separators
let g:airline_left_sep = "\uE0B8"
let g:airline_right_sep = "\uE0BE"

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

" ignore .pyc files in nerdtree as well as HDF5 data files
let NERDTreeIgnore=['\.pyc$', '\~$', '\.hdf5$']

" always delete buffers of deleted nerdtree files
let NERDTreeAutoDeleteBuffer = 1

"hide the '? for help' message in NERDTree
let NERDTreeMinimalUI = 1

" turn on folding
set foldmethod=indent

" use smart contextual hybrid linenumbers
" https://jeffkreeftmeijer.com/vim-number/#relative-line-numbers
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" use mouse input
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

" format onto the next line but without combining with the contents of the
" next line
noremap g<Down> o<Esc>gqkddk

" toggle search highlighting
noremap - :set hlsearch!<CR>

" toggle fold with spacebar
noremap <Leader><CR> zA

" start command with double tap of the spacebar
noremap <Leader><Space> :

" start a shell command without hitting shift
noremap <Leader>1 :!

" toggle smartypants crap, i.e. linenumbers, autoindent, smartindent, and mouse
" with delete, aka backspace
noremap <Bs> :call ToggleInteractive()<CR>
function! ToggleInteractive()
    if &mouse == "a"
        setlocal mouse=
        setlocal nonumber
        setlocal norelativenumber
        setlocal noautoindent
        setlocal nosmartindent
        echom "Interactive off."
    else
        setlocal mouse=a
        setlocal number
        setlocal relativenumber
        setlocal autoindent
        setlocal smartindent
        echom "Interactive on."
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
map <Leader>p :Gpull<CR>

" git push
map <Leader>P :Gpush<CR>

" open nerdtree
map <Leader>n :NERDTreeToggle<CR>

" run help for some string
map <Leader>h :help 

" check mappings
map <Leader>m :map 

" show git status
nnoremap <Leader>s :Gstatus<CR>

" git diff this file
nnoremap <Leader>d :Gdiff<CR>

" run git diff in CWD
nnoremap <Leader>D :!git diff<CR>

" git commit
nnoremap <Leader>C :Gcommit<CR>

" git grep
nnoremap <Leader>G :Ggrep 

" git read; do a git checkout to the buffer
nnoremap <Leader>r :Gread 

" open up the undo gtree, Gundo
nnoremap <Leader>u :GundoToggle<CR>

" try to imgcat the selected filename
vnoremap <Leader>I y:!imgcat <C-f>pA<CR>

" git write; writes to both the work tree and index versions of file, making
" it like `git add` when called from a work tree file and like `git checkout`
" when called from the index or a blob in the history
nnoremap <Leader>w :Gwrite<CR>

" git write (to index) and then commit
nnoremap <Leader>W :Gwrite<CR>:Gcommit<CR>

" some stuff for working with interactive sessions in python

" place contents of ipyscratch at cursor
autocmd FileType python nnoremap <Leader>iP   :.-1r ~/.ipyscratch<CR>

" place contents of ipyscratch below cursor
autocmd FileType python nnoremap <Leader>ip :r ~/.ipyscratch<CR>

" replace selection with contents of ipyscratch
autocmd FileType python vnoremap <Leader>ip c<ESC>:r ~/.ipyscratch<CR>kdd

" write selection to ipyscratch
autocmd FileType python vnoremap <Leader>iw :w! ~/.ipyscratch<CR>

" yank selection and write it to ipyscratch
autocmd FileType python vnoremap <Leader>iy :w! ~/.ipyscratch<CR>gvd

" toggle comments on various things using vim-commentary with leader
map <Space>c gc

" bindings copied from spacemacs

" load .vimrc
map <Leader>feR :source ~/.vimrc<CR>

" edit .vimrc
map <Leader>fed :e ~/.vimrc<CR>

" neovim-specific shortcuts go here
if has('nvim')
    " <Esc> enters normal mode in term mode instead of sending <Esc> to term
    "tnoremap <Leader><Esc> <C-\><C-n>

    " Launch term with leader keys
    noremap <Leader>tv :vsp<CR>:term<CR>
    noremap <Leader>ts :sp<CR>:term<CR>
endif
