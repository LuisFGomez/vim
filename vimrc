" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=300
" Enable filetype plugin
filetype plugin on
filetype indent on
" Set to auto read when a file is changed from the outside
set autoread
" With a map leader it's possible to do extra key combinations
" like <Leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
" Fast saving
nmap <Leader>w :w!<cr>
" Fast quitting
nmap <Leader>q :q<cr>
" Fast editing of the .vimrc
map <Leader>e :e! ~/.vim/vimrc<cr>
" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vim/vimrc
" Turn on line numbers:
set number
" Toggle line numbers with F2 and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
" Open vertical split windows on the right
set splitright

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Diff options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt=filler,vertical

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl

" Set font according to system
if has("mac") || has("macunix")
    set gfn=Bitstream\ Vera\ Sans\ Mono:h13
    set shell=/bin/bash
elseif has("win16") || has("win32") || has("win64")
    set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
    set gfn=Consolas:h10
    let g:tagbar_ctags_bin="~/.vim/exe/ctags.exe"
    set ffs=dos,unix
elseif has("linux")
    set gfn=Monospace\ 10
    set shell=/bin/bash
endif

if has("gui_running")
    set lines=2000 columns=2000 " maximize gvim window on startup
    set guioptions-=T
endif

"LG make these setting default for console and gui, since
"   running under gnome-terminal supports all this junk
set t_Co=256
colorscheme desert

set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"set cul        "Highlight the cursor line
"set cuc        "Highlight the cursor column
set so=10       " Set 10 lines of scroll space when scrolling
set wildmenu    "Turn on WiLd menu
set mouse=a     " Enable mouse usage (all modes) in terminals
set ruler       "Always show current position
set cmdheight=2 "The commandbar height
set hid         "Change buffer - without saving
" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
"set ignorecase "Ignore case when searching
set smartcase   "Smart case matching
set showcmd     " Show (partial) command in status line.
set hlsearch    "Highlight search things
set incsearch   "Make search act like search in modern browsers
set magic       "Set magic on, for regular expressions
set showmatch   "Show matching bracets when text indicator is over them
set mat=2       "How many tenths of a second to blink

" Disable annoying screen flash and/or bells when you press 'esc'
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Clear all the search highlight terms
nnoremap <Leader>/ :noh<CR>

" ==================================================================
" Insert blank lines above, below without changing cursor (ranges allowed)
" ==================================================================
map <Leader>O :<C-U>call append(line(".") -1, repeat([''], v:count1))<CR>
map <Leader>o :<C-U>call append(line("."), repeat([''], v:count1))<CR>


" ==================================================================
" UltiSnips Options
" ==================================================================
" Luis: Because the default mapping of <C-j> and <C-k> conflict with
" moving lines up/down, remap to tab/shift-tab
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" ==================================================================
" Enable moving lines up/down with CTRL-k/CTRL-j
" ==================================================================
function! MoveLineUp()
    call MoveLineOrVisualUp(".", "")
endfunction
function! MoveLineDown()
    call MoveLineOrVisualDown(".", "")
endfunction
function! MoveVisualUp()
    call MoveLineOrVisualUp("'<", "'<,'>")
    normal gv
endfunction
function! MoveVisualDown()
    call MoveLineOrVisualDown("'>", "'<,'>")
    normal gv
endfunction
function! MoveLineOrVisualUp(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num - v:count1 - 1 < 0
        let move_arg = "0"
    else
        let move_arg = a:line_getter." -".(v:count1 + 1)
    endif
    call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction
function! MoveLineOrVisualDown(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num + v:count1 > line("$")
        let move_arg = "$"
    else
        let move_arg = a:line_getter." +".v:count1
    endif
    call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction
function! MoveLineOrVisualUpOrDown(move_arg)
    let col_num = virtcol(".")
    execute "silent! ".a:move_arg
    execute "normal! ".col_num."|"
endfunction
nnoremap <silent> <C-k> :<C-u>call MoveLineUp()<CR>
nnoremap <silent> <C-j> :<C-u>call MoveLineDown()<CR>
inoremap <silent> <C-k> <C-o>:<C-u>call MoveLineUp()<CR>
inoremap <silent> <C-j> <C-o>:<C-u>call MoveLineDown()<CR>
vnoremap <silent> <C-k> :<C-u>call MoveVisualUp()<CR>
vnoremap <silent> <C-j> :<C-u>call MoveVisualDown()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=4
set tabstop=4
set expandtab
set lbr
set tw=500
set ai "Auto indent
set nosmartindent " NO Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <Leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" In visual mode when you press * or #, search for the current selection
" From an idea by Michael Naumann
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Quickfix window Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always move the quickfix to bottom, full-width
autocmd! FileType qf wincmd J

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Project plugin mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" i: display filename and current working dir in command line when file is selected for opening
" s: use syntax highlighting in project window
" g: map <F12> to toggle project window open/close
" t: toggle size of window with spacebar, rather than increase
" c: automatically close when a file is selected
let g:proj_flags="isgt"
nmap <silent> TP <Plug>ToggleProject

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => cscope options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set csprg=gtags-cscope  "make the :cscope command use the gtags-cscope instead.
                        " This requires the program 'global' to be installed'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wrap stuff around visual text
" Typing a comma + the punctutation will wrap selection with punctuation
vnoremap <Leader>( <esc>`>a)<esc>`<i(<esc>
vnoremap <Leader>[ <esc>`>a]<esc>`<i[<esc>
vnoremap <Leader>{ <esc>`>a}<esc>`<i{<esc>
vnoremap <Leader>< <esc>`>a><esc>`<i<<esc>
vnoremap <Leader>' <esc>`>a'<esc>`<i'<esc>
vnoremap <Leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <Leader><space> <esc>`>a<space><esc>`<i<space><esc>
nnoremap <Leader><space> i<space><esc>la<space><esc>l
" This bad boy will let you wrap a visual selection with a {, but with a twist:
"   it will place a newline before both the opening and closing brace
"   all lines are also reindented to make them pretty
vnoremap <Leader>.{ <esc>`>a<cr>}<esc>`<i{<cr><esc>gvjj=

" ==================================================================
" TaskList Options
" ==================================================================
let g:tlWindowPosition = 1 "open on the bottom
map TL <Plug>TaskList

" ==================================================================
" Tagbar Commands/Variables
" ==================================================================
" Shorter commands to toggle Taglist display
nnoremap TT :TagbarToggle<CR>
let g:tagbar_compact=1 " save screen real estate
let g:tagbar_sort=0
" let g:tagbar_singleclick=1
" let g:tagbar_autoclose=1

" ==================================================================
" Custom NERDCommenter commands
" ==================================================================
let NERDSpaceDelims=1 " Add 1 space between each left/right comment delimiter
let NERDCommentWholeLinesInVMode=2 " whole lines commented out when there is no multipart delimiters but 
                                   " EXACT text that was selected is commented out if there IS multipart delimiters

" ==================================================================
" C/C++ Section
" ==================================================================
au BufRead,BufNewFile *.h,*.hpp,*.c,*.cpp,*.dox set ft=cpp.doxygen

" ==================================================================
" Python Section
" ==================================================================
au FileType python set nocindent
au FileType python highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au FileType python match OverLength /\%81v.\+/
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self
autocmd FileType python set omnifunc=pythoncomplete#Complete
" Prevent from inserting first match
set completeopt=menuone,preview,longest
" Ctrl-Space launches omnicomplete
inoremap <Nul> <C-x><C-o>

" ==================================================================
" Save and restore folds on file open
" ==================================================================
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

" ==================================================================
" Strip trailing whitespace on save
" ==================================================================

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
" TODO: move these into file-specific vimscripts
autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" ==================================================================
" Strip all '^M' characters (for files with mixed dos/unix line endings
" ==================================================================
command! StripCR %s/\%x0d$//g

" ==================================================================
" Toggle showing tabs
" ==================================================================
set list " show tab characters by default
nnoremap <Leader>l :set list!<CR>
set listchars=tab:»\ ,trail:·

" ==================================================================
" Move text from cursor onward to next line
" ==================================================================
nnoremap <Leader><CR> i<CR><Esc>l

" ==================================================================
" Index source code at current directory
" ==================================================================
fun! ExecCtagsRecursive()
    if !exists("g:tagbar_ctags_bin")
        execute '!ctags -R .'
    else
        execute '!' . expand(g:tagbar_ctags_bin) . ' -R'
    endif
endfun
command! Index call ExecCtagsRecursive()
