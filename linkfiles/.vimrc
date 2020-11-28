"==============================================================================
" LOAD VUNDLE
"==============================================================================

set nocompatible
set encoding=utf8

" vim-plug plugins
call plug#begin('~/dev/dotfiles/linkfiles/.vim/bundle')
Plug 'tikhomirov/vim-glsl'
Plug 'https://gitlab.com/n9n/vim-apl'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', has('nvim') ? {'branch': 'release'} : { 'on': [] }
Plug 'ekalinin/Dockerfile.vim'
Plug 'jamessan/vim-gnupg'
Plug 'godlygeek/tabular'
Plug 'cespare/vim-toml'
" Plug 'neomake/neomake'
" Plug 'nvie/vim-flake8'
Plug 'dhruvasagar/vim-table-mode'
Plug 'lepture/vim-jinja'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-scripts/GrepCommands'
" let me not use this for now and instead see how vim-dispatch treats me
" Plug 'janko-m/vim-test'
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
" smart date incrementing
Plug 'tpope/vim-speeddating'
" surround strings with characters, e.g. quotes.
" PREFIXES
"   - 'ys' adds adds wrapping characters, e.g. 'ysiw<em>' wraps a word with
"     <em>
"   - 'ds' removes wrapping characters, e.g. 'ds"' to remove wrapping double
"     quotes
"   - 'cs' changes wrapping characters, e.g. 'cs"<q>' swaps double quotes for
"     quotation tags <q>
Plug 'tpope/vim-surround'
" case changes/complex substitutions/programmable autocorrect
Plug 'tpope/tpope-vim-abolish'
" add repeatability to supporting custom plugins
Plug 'tpope/vim-repeat'
" nice wrapper for existing persistence/session saving vim functionality!
" Plug 'tpope/vim-obsession'
" add extra '[' and ']' mappings
Plug 'tpope/vim-unimpaired'
" add some unix sugar
Plug 'tpope/vim-eunuch'
"Plug 'edkolev/promptline.vim'
" tmux bindings for vim with nice tab completion
" Plug 'tpope/vim-tbone'
" JSON tools
" Plug 'tpope/vim-jdaddy'
Plug 'Shougo/unite.vim'
" Handle snippets, i.e. templates, like a new class definition in Python:
" Plug 'SirVer/ultisnips'
" Add tab-completion of LaTeX unicode characters (for Julia and more)
Plug 'JuliaEditorSupport/julia-vim'
call plug#end()
noremap <F1> :Unite<Space>

"==============================================================================
" TRAILING WHITESPACE
"==============================================================================

" highlight trailing whitespace, but not on insert mode
" https://stackoverflow.com/a/4617156/3601493
highlight ExtraWhitespace ctermbg=blue guibg=blue
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"==============================================================================
" MAC GUI VIM PREFS
"==============================================================================

set guifont=Iosevka\ Nerd\ Font\ Mono:h11
" colorscheme industry

"==============================================================================
" BASIC VIM PREFS
"==============================================================================

" leave plenty of time to enter key combinations; 10 seconds
set timeoutlen=10000

" automatically read file updates
set autoread

" use filetype and syntax
filetype indent on
syntax on

" show tabs
" https://vi.stackexchange.com/questions/422/displaying-tabs-as-characters
set list
set listchars=tab:▸·

" define a function for setting textwidth. this is necessary to enable the
" ToggleInteractive function. Used for setting hard word wraps..
function! ActivateTextWidth()
    " autoenter after 79 characters
    set textwidth=79
    " local exceptions for the following filetypes
    if &filetype == 'crontab'
        setlocal textwidth=0
    elseif &filetype == 'sh'
        setlocal textwidth=0
    elseif &filetype == 'tex'
        setlocal textwidth=0
    elseif &filetype == 'taskedit'
        setlocal textwidth=0
    elseif &filetype == 'tmux'
        setlocal textwidth=0
    elseif &filetype == 'yaml.docker-compose'
        setlocal textwidth=0
    elseif &filetype == 'yaml'
        setlocal textwidth=0
    elseif &filetype == 'Dockerfile'
        setlocal textwidth=0
    endif
endfunction

" update gitgutter and COC 250ms after changes
set updatetime=250

" automatically enter after 79 characters; requires 't' to be in formatoptions.
autocmd FileType * call ActivateTextWidth()

" set the <Leader> key to space
let mapleader = ' '

" show commands as they are being entered, like in emacs
set showcmd

" italicize comments
highlight Comment cterm=italic

" make current line number a different color
hi CursorLineNR ctermfg=Magenta cterm=bold
augroup CLNRSet
    autocmd! ColorScheme * hi CursorLineNR ctermfg=Yellow
augroup END

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
autocmd FileType html,css let &l:softtabstop=2|let &l:tabstop=2|let &l:shiftwidth=2
autocmd FileType htmldjango,yaml let &l:softtabstop=2|let &l:tabstop=2|let &l:shiftwidth=2
autocmd FileType typescript let &l:softtabstop=2|let &l:tabstop=2|let &l:shiftwidth=2

" don't expandtab for Makefiles; use actual tabs
autocmd FileType make set noexpandtab

" force .md to be interpreted as Markdown, include code syntax
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = [
    \'apl',
    \'bash=sh',
    \'c',
    \'crontab',
    \'css',
    \'fortran',
    \'gitcommit',
    \'haskell',
    \'html',
    \'htmldjango',
    \'json',
    \'mailcap',
    \'make',
    \'markdown',
    \'matlab',
    \'muttrc',
    \'python',
    \'rst',
    \'sshconfig',
    \'taskedit',
    \'tex',
    \'tmux',
    \'typescript',
    \'vim',
    \'yaml',
    \]
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100

" turn on folding, but start with all folds open
set foldmethod=indent
autocmd Syntax * normal zR

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
" for FORTRAN, put columns at line 6 and 73-80 to follow FORTRAN formatting:
" (Taken from https://web.stanford.edu/class/me200c/tutorial_77/03_basics.html)
"   Col. 1     : Blank, or a 'c' or '*' for comments
"   Col. 1-5   : Statement label (optional)
"   Col. 6     : Continuation of previous line (optional)
"   Col. 7-72  : Statements
"   Col. 73-80 : Sequence number (optional, rarely used today)
autocmd FileType fortran setlocal colorcolumn=6,73,74,75,76,77,78,79,80

" allow mouse past 220th column
" http://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
" note that this is not a supported feature of neovim, so don't run in that
" case.
if ! has('nvim')
    " set ttymouse=sgr
    set ttymouse=xterm2
else
    hi CocFloating guibg=none guifg=none ctermbg=24
    " hi CocFloating guibg=none guifg=none
    " hi Quote ctermbg=109 guifg=#83a598
    " set winhl=Normal:PMenu

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " get floating window with border
    " https://github.com/neovim/neovim/issues/9718#issuecomment-559573308
    " function! CreateCenteredFloatingWindow()
    "     let width = min([&columns - 4, max([80, &columns - 20])])
    "     let height = min([&lines - 4, max([20, &lines - 10])])
    "     let top = ((&lines - height) / 2) - 1
    "     let left = (&columns - width) / 2
    "     let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    "     let top = "╭" . repeat("─", width - 2) . "╮"
    "     let mid = "│" . repeat(" ", width - 2) . "│"
    "     let bot = "╰" . repeat("─", width - 2) . "╯"
    "     let lines = [top] + repeat([mid], height - 2) + [bot]
    "     let s:buf = nvim_create_buf(v:false, v:true)
    "     call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    "     call nvim_open_win(s:buf, v:true, opts)
    "     set winhl=Normal:Floating
    "     let opts.row += 1
    "     let opts.height -= 2
    "     let opts.col += 2
    "     let opts.width -= 4
    "     call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    "     au BufWipeout <buffer> exe 'bw '.s:buf
    " endfunction

    " let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" format onto the next line but without combining with the contents of the
" next line
noremap gq<Down> o<Esc>gqkddk

" yank to system clipboard by prefixing with <Leader>
noremap <Leader>y "*y

" pull from system clipboard by prefixing with <Leader>
noremap <Leader>p "*p

" start command with double tap of the spacebar
noremap <Leader><Space> :

" start a shell command without hitting shift
noremap <Leader>1 :!

"==============================================================================
" ENCRYPTION SETTINGS
"==============================================================================

" Use blowfish2 for vim-encrypted stuff
if !has('nvim')
    set cryptmethod=blowfish2
endif

" Use symmetric encryption
let GPGPreferSymmetric=1

"==============================================================================
" NEOMAKE SETTINGS
"==============================================================================

" RECALL that neomake adds warnings/messages to your location list, so you can
" navigate them with :lnext and :lprev; shortcuts for these are in the
" NAVIGATION COMMANDS section of this file.

" run Neomake on write
" autocmd! BufWritePost * Neomake

"==============================================================================
" TO DO STATE SETTINGS
"==============================================================================

" These settings are inspired by org mode with spacemacs bindings, though they
" use <Leader>t instead of bare t to avoid clobbering the t operator.

" mark this paragraph as having a particular state
function! TodoState_TeX_Paragraph(state)
    execute "normal! {jc}\\". a:state. "{\<CR>}\<Esc>P}"
endfunction

" strip todo state from this paragraph
function! TodoState_TeX_Paragraph_Strip()
    normal! {jdd}kdd
endfunction

" add bindings for various TODO states
function! TodoState_TeX_AddBindings()
    noremap <Leader>tt :call TodoState_TeX_Paragraph("TODO")<CR>
    noremap <Leader>ts :call TodoState_TeX_Paragraph("STARTED")<CR>
    noremap <Leader>tr :call TodoState_TeX_Paragraph("REVIEW")<CR>
    noremap <Leader>td :call TodoState_TeX_Paragraph("DONE")<CR>
    noremap <Leader>tq :call TodoState_TeX_Paragraph("QUESTION")<CR>
    noremap <Leader>tc :call TodoState_TeX_Paragraph("COMMENT")<CR>
    " add binding to strip TODO state, but only if there is already a binding
    noremap <Leader>tn :call TodoState_TeX_Paragraph_Strip()<CR>
endfunction

" activate bindings by file type
" autocmd FileType tex                call TodoState_TeX_AddBindings()

"==============================================================================
" MARKDOWN/GIT COMMIT SETTINGS
"==============================================================================

" set 6-space indent for git commit messages (to allow for MD checklists)
autocmd FileType gitcommit setlocal softtabstop=6|setlocal tabstop=6|setlocal shiftwidth=6

" in gitcommit and markdown files, shift-tab toggles a list
autocmd FileType gitcommit,markdown
    \ map <S-Tab> :call ToggleMDList()<CR> |
    \ setlocal spell spelllang=en_us |
    \ silent call tablemode#Enable() |
    \ let g:table_mode_corner='|'

" TODO command for toggling markdown list at start
function ToggleMDList()
    echom 'TODO: ToggleMDList not yet implemented.'
endfunction

"==============================================================================
" RESTRUCTUREDTEXT SETTINGS
"==============================================================================

" Turn on tablemode with reST for easy tables
autocmd FileType rst
    \ call tablemode#Enable() |
    \ let g:table_mode_corner_corner='+' |
    \ let g:table_mode_header_fillchar='='

"==============================================================================
" GIT GUTTER SETTINGS
"==============================================================================

" toggle highlighting of diffs
noremap <Leader>hd :GitGutterLineHighlightsToggle<CR>

"==============================================================================
" DISPLAY/FOLDING/INTERACTION SETTINGS
"==============================================================================

" toggle search highlighting
noremap - :set hlsearch!<CR>

" toggle fold with spacebar enter
noremap <Leader><CR> zA

" toggle smartypants crap, i.e. linenumbers, autoindent, smartindent, and mouse
" with delete, aka backspace
noremap <Bs> :call ToggleInteractive()<CR>

function! ToggleInteractive()
    if &mouse == "a"
        GitGutterDisable
        setlocal textwidth=0
        setlocal mouse=
        setlocal nonumber
        setlocal norelativenumber
        setlocal noautoindent
        setlocal nosmartindent
        echom "Interactive off."
    else
        GitGutterEnable
        call ActivateTextWidth()
        setlocal mouse=a
        setlocal number
        setlocal relativenumber
        setlocal autoindent
        setlocal smartindent
        echom "Interactive on."
    endif
endfunction

" center the screen
noremap <CR> zz

"==============================================================================
" REFRESHING THE VIEW
"==============================================================================

" sync syntax from start with <Leader>s (default leader is \)
map <Leader>rs :syntax sync fromstart<CR>

" redraw the screen
map <Leader>rr :redraw!<CR>

"==============================================================================
" COMMENT SYNTAX
"==============================================================================

" define comment strings for various langs
autocmd FileType vim                setlocal commentstring=\"\ %s
autocmd FileType crontab,sh,python  setlocal commentstring=#\ %s
autocmd FileType mailcap,muttrc     setlocal commentstring=#\ %s
autocmd FileType sshconfig          setlocal commentstring=#\ %s
autocmd FileType tex,matlab         setlocal commentstring=%\ %s
autocmd FileType yaml,tmux          setlocal commentstring=#\ %s
autocmd FileType text               setlocal commentstring=#\ %s
autocmd FileType haskell            setlocal commentstring=--\ %s
autocmd FileType apl                setlocal commentstring=⍝\ %s

"==============================================================================
" SOFT WORD WRAP
"==============================================================================

" don't soft wrap by default
set nowrap

" define a function for setting soft word wrap options, including mapping
" up/down motion within wrapped lines to j/k instead of gj/gk
function! ActivateSoftWrap()
    " linebreak ensures that we break on words instead of wrapping around in
    " the middle of one
    setlocal wrap linebreak
    noremap j gj
    noremap k gk
    " show partial wrapped lines even when there is not enough space
    " on the page for the full wrapped line
    set display=lastline
endfunction

" activate soft wrap for text files where this is desirable
autocmd FileType tex,taskedit       call ActivateSoftWrap()

"==============================================================================
" AIRLINE CONFIG
"==============================================================================

" display all buffers in tab bar when only one tab is open
let g:airline#extensions#tabline#enabled = 1

" show abbreviated word count string in airline
let g:airline#extensions#wordcount#format = '%d w'

" show an abbreviated mode string
" removed the empty line since empty key was generating and error:
"    \ '' : 'V',
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ 's'  : 'S',
    \ }

" use the base16 airline theme. some favs below.
" let g:airline_theme = 'laederon'
" let g:airline_theme = 'raven'
" let g:airline_theme = 'papercolor'
" let g:airline_theme = 'monochrome'
" let g:airline_theme = 'jellybeans'
" let g:airline_theme = 'distinguished'
let g:airline_theme = 'cool'
" let g:airline_theme = 'behelit'
" let g:airline_theme = 'aurora'

" use airline powerline fonts
" let g:airline_powerline_fonts = 1

" change airline separators
" let g:airline_left_sep = "\uE0B8"
" let g:airline_right_sep = "\uE0BE"

"==============================================================================
" NAVIGATION COMMANDS
"==============================================================================

" next or previous window
noremap <Up> <C-w>W
noremap <Down> <C-w>w

" navigate around windows with control + hjkl
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" next or previous tab
noremap <Left> gT
noremap <Right> gt

" next or previous open file
" noremap <S-Right> :n<CR>
" noremap <S-Left> :N<CR>

" next or previous vimgrep match
noremap <S-Up> :cp<CR>
noremap <S-Down> :cn<CR>

" next or previous error from neomake
noremap <S-Right> :lnext<CR>
noremap <S-Left> :lprev<CR>

"==============================================================================
" HELP COMMANDS
"==============================================================================

" run help for some string
map <Leader>hh :help<Space>

" check mappings
map <Leader>hm :map<Space>

" get help for selection or word under cursor
nnoremap <Leader>hw yiw:help <C-r>"<CR>
vnoremap <Leader>hw y:help <C-r>"<CR>

"==============================================================================
" SEARCH TOOLS
"==============================================================================

" use Ag if available even when using Ack package
if executable('ag')
  let g:ackprg = 'ag -s --vimgrep'
endif

"==============================================================================
" JULIA SETTINGS
"==============================================================================

" toggle whether the LaTeX to Unicode tab completion is active
noremap <expr> <F7> LaTeXtoUnicode#Toggle()
inoremap <expr> <F7> LaTeXtoUnicode#Toggle()

"==============================================================================
" NERDTREE SETTINGS
"==============================================================================

" ignore .pyc files in nerdtree as well as HDF5 data files
let NERDTreeIgnore=['\.pyc$', '\~$', '\.hdf5$']

" always delete buffers of deleted nerdtree files
let NERDTreeAutoDeleteBuffer = 1

"hide the '? for help' message in NERDTree
let NERDTreeMinimalUI = 1

"==============================================================================
" ASYNCRUN COMMANDS
"==============================================================================

" start a shell command to run asynchronously
noremap <Leader>2 :AsyncRun<Space>

" kill the current async command
noremap <Leader><Esc> :AsyncStop<CR>

" display asyncrun status in airline
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])

" make fugitive fetch and push async
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

"==============================================================================
" TABULARIZE
"==============================================================================
noremap gt :Tabularize /

"==============================================================================
" FUGITIVE (GIT) MAPPINGS
"==============================================================================

" git pull
map <Leader>gp :Gresolvelink<CR>:Gpull<CR>

" git push
map <Leader>gu :Gresolvelink<CR>:Gpush<CR>

" show git status
nnoremap <Leader>gs :Gresolvelink<CR>:Gstatus<CR>

" show git blame
nnoremap <Leader>gb :Gresolvelink<CR>:Gblame<CR>

" git diff this file
nnoremap <Leader>gd :Gresolvelink<CR>:Gdiff<CR>

" show a really nicely pretty-printed git log
nnoremap <Leader>gl :!git lg2<Space>

" run git diff in (user can enter extra commands)
nnoremap <Leader>gD :Gresolvelink<CR>:!git diff<Space>

" git commit
nnoremap <Leader>gc :Gresolvelink<CR>:Gcommit<CR>

" git commit and immediately push
nnoremap <Leader>gC :Gresolvelink<CR>:Gcommit<CR>:Gpush<CR>

" git fetch
nnoremap <Leader>gf :Gresolvelink<CR>:Gfetch<CR>

" git grep; you can also use Ack/Ag, which is not tied to vim
nnoremap <Leader>gg :Gresolvelink<CR>:Ggrep<Space>
vnoremap <Leader>gg :Gresolvelink<CR>y:Ggrep <C-r>"<CR>

" git read; do a git checkout to the buffer
nnoremap <Leader>gr :Gresolvelink<CR>:Gread<Space>

" git rm a file and delete the buffer
nnoremap <Leader>gR :Gresolvelink<CR>:Gdelete<CR>

" git write; writes to both the work tree and index versions of file, making
" it like `git add` when called from a work tree file and like `git checkout`
" when called from the index or a blob in the history
nnoremap <Leader>gw :Gresolvelink<CR>:Gwrite<CR>

" git write (to index) and then commit
nnoremap <Leader>gW :Gresolvelink<CR>:Gwrite<CR>:Gcommit<CR>

" resolve symlink for this file, if it is a symlink (necessary for links);
" function defined below
noremap <Leader>l :Gresolvelink<CR>

" Follow symlinks when opening a file
" sources:
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

"==============================================================================
" GUNDO
"==============================================================================
nnoremap <Leader>u :UndotreeToggle<CR>

"==============================================================================
" PREVIEWING THINGS
"==============================================================================

" run whatever command on the filename under the cursor; for nerdtree
" windows, make sure to get the filename from the line rather than the
" exact term under the cursor.
function! RunCommandOnFileUnderCursor(command)
  if bufname("") == "NERD_tree_1"
    " move to end of line to make sure we are over the filename in NERDTree
    normal $
    " if we are in a nerdtree directory, we should execute this in the same
    " directory but then reset working directory to what it was before.
    let pre_preview_in_nerdtree = 1
    let pre_preview_cwd = fnameescape(getcwd())
    normal cd
  endif
  let fname=expand("<cfile>")
  execute("!" . a:command . ' "' . fname . '"')
  "execute("!tput clear")
  silent !tput clear
  redraw!
  if bufname("") == "NERD_tree_1"
    if exists(pre_preview_in_nerdtree) && pre_preview_in_nerdtree
      " change back to the old directory now that the preview is done
      let pre_preview_in_nerdtree = 0
      execute "cd ".pre_preview_cwd
    endif
    " if we are still in the NERDTree window, move back to the start of the
    " line in NERDTree after we finish.
    normal 0
  endif
endfunction

" image view in terminal with imgcat
nnoremap <Leader>vi :call RunCommandOnFileUnderCursor("imgcat")<CR>
vnoremap <Leader>vi y:!imgcat <C-r>"<CR>

" use mac's quicklook (or whatever command has been deemed to fulfill this
" role in the present environment)
nnoremap <Leader>vp :call RunCommandOnFileUnderCursor("ql")<CR>
vnoremap <Leader>vp y:!ql <C-r>"<CR>

" open a file under the cursor using mac's 'open' command
nnoremap <Leader>vo :call RunCommandOnFileUnderCursor("open")<CR>
vnoremap <Leader>vo y:!open <C-r>"<CR>

"==============================================================================
" PYTHON
"==============================================================================

" Automatically generate a UML diagram for this file on save
function! StefcoPythonUmlPdf() abort
    " From AsyncRun documentation (https://github.com/skywind3000/asyncrun.vim)
    " %:t:r   - File name of current buffer without path and extension
    AsyncRun 
        \ pyreverse
            \ "--output=pdf"
            \ "--module-names=n"
            \ "--all-ancestors"
            \ "--project=%:t:r"
            \ "%:t:r"
endfunction

" autocmd FileType python autocmd BufWritePost * call StefcoPythonUmlPdf()

"==============================================================================
" IPYTHON
"==============================================================================

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
map <Leader>c gc

"==============================================================================
" SPACEMACS BINDINGS
"==============================================================================

"---------------------------------------
" KEYBINDING FOR `MAKE` AND ANALOGUES
"---------------------------------------

" run 'make' command with no arguments; same as 'helm-make' in emacs
nmap <Leader>cm :make<CR><Space>:bp<CR>:bd#<CR>

" for LaTeX files, replace the make command with async latexmk compilation
" autocmd FileType tex nmap <Leader>cm :call StefcoCompileTexAsync()<CR>

"---------------------------------------
" FILE OPENING BINDINGS
"---------------------------------------

" use these bindings to open files (in a GUI environment)

" open the filename under the cursor

"---------------------------------------
" FILE SEARCH RELATED BINDINGS
"---------------------------------------

" combos: {b,f,fr}{g,f}{s,(n)c,(v)c,g}

" FIRST SECTION is the set of data to search:
"   - b  is for 'buffer'
"   - f  is for 'files' only in the current directory
"   - fr is for 'files', searching recursively from the current directory
" SECOND SECTION is the type of search:
"   - g is for 'grep', i.e. we are pattern matching file *contents*
"   - f is for 'find', i.e. we are pattern matching file *names*
" THIRD SECTION is the search string:
"   - s is for 'search', i.e. you will type your own search string
"   - c is for 'current', i.e. current selection (visual) or word (normal); the
"     field gets prepopulated
"   - g is for 'go', i.e. hit enter after 'current', i.e. just immediately
"     execute a search on the highlighted word (visual) or word under the
"     cursor (normal)

" Grep will open up the quickfix window, which can be navigated with :cnext/:cn
" and :cprevious/:cp, which I have remapped elsewhere in this file.

" Searches (fundamental): {b,f,fr}{g,f}s

" SPC b f s -- find a buffer using fake helm, i.e. Unite/Denite
map <Leader>bfs <F1> -no-split -no-auto-resize -ignorecase -start-insert buffer<CR>

" SPC b g s -- grep a buffer by contents using Ack
" map <Leader>bgs :bufdo AckAdd -n threading<Space>
map <Leader>bgs :BufGrep<Space>

" SPC f f s -- find a file using fake helm in current dir
" add a spacemacs binding to find a file using helm, i.e. Unite/Ddenite
map <Leader>ffs <F1> -no-split -no-auto-resize -ignorecase -start-insert file buffer<CR>

" SPC f g s -- search files by contents using Ack in this directory
nnoremap <Leader>fgs :Ack --follow --no-recurse<Space>

" SPC f r f s -- searches files recursively
map <Leader>frfs <F1> -no-split -no-auto-resize -ignorecase -start-insert file_rec buffer<CR>

" SPC f r g s -- search files recursively by contents using Ack
nnoremap <Leader>frgs :Ack --follow<Space>

" Cursor (always the same modification of the above): {b,f,fr}{g,f}c

" normal mode maps
nmap <Leader>bfc yiw<Leader>bfs<C-r>"
nmap <Leader>bgc yiw<Leader>bgs<C-r>"
nmap <Leader>ffc yiw<Leader>ffs<C-r>"
nmap <Leader>fgc yiw<Leader>fgs<C-r>"
nmap <Leader>frfc yiw<Leader>frfs<C-r>"
nmap <Leader>frgc yiw<Leader>frgs<C-r>"

" visual mode maps; xmap is only visual mode, vmap is visual and select mode:
" https://vi.stackexchange.com/questions/11852
xmap <Leader>bfc y<Leader>bfs<C-r>"<Space>
xmap <Leader>bgc y<Leader>bgs<C-r>"<Space>
xmap <Leader>ffc y<Leader>ffs<C-r>"<Space>
xmap <Leader>fgc y<Leader>fgs<C-r>"<Space>
xmap <Leader>frfc y<Leader>frfs<C-r>"<Space>
xmap <Leader>frgc y<Leader>frgs<C-r>"<Space>

" Go (i'm feeling lucky): {b,f,fr}{g,f}g

" all maps
map <Leader>bfg <Leader>bfc<Bs><CR>
map <Leader>bgg <Leader>bgc<Bs><CR>
map <Leader>ffg <Leader>ffc<Bs><CR>
map <Leader>fgg <Leader>fgc<Bs><CR>
map <Leader>frfg <Leader>frfc<Bs><CR>
map <Leader>frgg <Leader>frgc<Bs><CR>

"---------------------------------------
" CONFIG FILE BINDINGS
"---------------------------------------

" load .vimrc
map <Leader>feR :source ~/.vimrc<CR>

" edit .vimrc
map <Leader>fed :e ~/.vimrc<CR>

"---------------------------------------
" FILE-RELATED BINDINGS
"---------------------------------------

" open nerdtree
map <Leader>ft :NERDTreeToggle<CR>

" save a file
map <Leader>fs :w<CR>

" save all files
map <Leader>fS :wa<CR>

" move the current file relative to PWD (eunuch)
map <Leader>fR :Rename<Space>

" change working directory to the directory containing this file
map <Leader>fd :cd %:p:h<CR>:pwd<CR>

" remove the buffer and delete the file (eunuch)
map <Leader>fD :Delete<CR>

" copy file somewhere
map <Leader>fc :w<Space>

" save file as
map <Leader>fa :saveas<Space>

" open file as sudo
map <Leader>fE :SudoEdit<CR>

"---------------------------------------
" WINDOW-RELATED BINDINGS
"---------------------------------------

" access all window-prefix stuff
map <Leader>w <C-w>

" delete window (from current emacs version, by analogy to SPC b d)
map <Leader>wd <C-w>c

"---------------------------------------
" TAB-RELATED BINDINGS
"---------------------------------------

" nnoremap <C-n> :tabnew<CR>
" nnoremap <C-w> :tabc<CR>

"---------------------------------------
" BUFFER-RELATED BINDINGS
"---------------------------------------

" unload current buffer and delete from buffer list the way it would be done in
" emacs, i.e. don't delete the window, just the buffer; requires a hacky
" approach that used :bd#<CR> to delete the most recent buffer.
map <Leader>bd :bp<CR>:bd#<CR>

" this command refreshes the buffer list in airline after deleting a buffer.
autocmd BufDelete * call airline#extensions#tabline#buflist#invalidate()

"---------------------------------------
" QUITTING
"---------------------------------------

" quit all, don't force
map <Leader>qq :qa<CR>

" quit all, losing unsaved changes
map <Leader>qQ :qa!<CR>

" e(x)it after saving all files
map <Leader>qs :wqa<CR>

"==============================================================================
" NEOVIM SHORTCUTS
"==============================================================================

if has('nvim')
    " <Esc> enters normal mode in term mode instead of sending <Esc> to term
    "tnoremap <Leader><Esc> <C-\><C-n>

    " Launch term with leader keys
    noremap <Leader>tv :vsp<CR>:term<CR>
    noremap <Leader>ts :sp<CR>:term<CR>
endif

"==============================================================================
" SPELLCHECK
"==============================================================================
" :set spell spelllang=en_us          " all bufs
" :setlocal spell spelllang=en_us     " current buf
" :set nospell                        " deactivate

"==============================================================================
" COC (Conquerer of Completion)
"==============================================================================

" https://github.com/neoclide/coc.nvim#example-vim-configuration

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

if has('nvim')
    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    set signcolumn=yes

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
    " position. Coc only does snippet and additional edit on confirm.
    if has('nvim')
        if has('patch8.1.1068')
            " Use `complete_info` if your (Neo)Vim version supports it.
            inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
        else
            imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        endif
    endif

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocActionAsync('doHover')
    endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <Leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    " xmap <Leader>f  <Plug>(coc-format-selected)
    " nmap <Leader>f  <Plug>(coc-format-selected)
    xmap gqf  <Plug>(coc-format-selected)
    nmap gqf  <Plug>(coc-format-selected)

    augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying codeAction to the selected region.
    " An example: `<Leader>aap` for current paragraph
    xmap <Leader>a  <Plug>(coc-codeaction-selected)
    nmap <Leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current line.
    nmap <Leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <Leader>qf  <Plug>(coc-fix-current)

    " Introduce function text object
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Use <TAB> for selections ranges.
    " NOTE: Requires 'textDocument/selectionRange' support from the language server.
    " coc-tsserver, coc-python are the examples of servers that support it.
    nmap <silent> <TAB> <Plug>(coc-range-select)
    xmap <silent> <TAB> <Plug>(coc-range-select)

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Mappings using CoCList:
    " Show all diagnostics.
    nnoremap <silent> <Leader>ca  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent> <Leader>ce  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent> <Leader>c<Space>  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent> <Leader>co  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent> <Leader>cs  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <Leader>cj  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <Leader>ck  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent> <Leader>cp  :<C-u>CocListResume<CR>
endif
