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
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Fast editing of the .vimrc
map <leader>e :e! ~/.vim_runtime/vimrc<cr>

" When vimrc is edited, reload it
"autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc
autocmd! bufwritepost vimrc source %

" Turn on line numbers:
set number
" Toggle line numbers with F2 and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl

" Set font according to system
if MySys() == "mac"
	set gfn=Bitstream\ Vera\ Sans\ Mono:h13
	set shell=/bin/bash
elseif MySys() == "windows"
	set gfn=Bitstream\ Vera\ Sans\ Mono:h10
elseif MySys() == "linux"
	set gfn=Monospace\ 10
	set shell=/bin/bash
endif

if has("gui_running")
	set guioptions-=T
	set background=dark
	set t_Co=256
	set background=dark
	colorscheme peaksea

	set nu
else
	colorscheme zellner
	set background=dark

	set nonu
endif

set encoding=utf8
try
	lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 10 lines of scroll space when scrolling
set so=10
set wildmenu 	"Turn on WiLd menu
set mouse=a		" Enable mouse usage (all modes) in terminals
set ruler 		"Always show current position
set cmdheight=2 "The commandbar height
set hid 		"Change buffer - without saving
" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
"set ignorecase "Ignore case when searching
set smartcase 	"Smart case matching
set showcmd		" Show (partial) command in status line.
set hlsearch 	"Highlight search things
set incsearch 	"Make search act like search in modern browsers
set magic 		"Set magic on, for regular expressions
set showmatch 	"Show matching bracets when text indicator is over them
set mat=2 		"How many tenths of a second to blink
" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
" Have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" ==================================================================
" Insert blank lines above, below without changing cursor (ranges allowed)
" ==================================================================
map <Leader>O :<C-U>call append(line(".") -1, repeat([''], v:count1))<CR>
map <Leader>o :<C-U>call append(line("."), repeat([''], v:count1))<CR>

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
"set smarttab
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
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

function! CmdLine(str)
	exe "menu Foo.Bar :" . a:str
	emenu Foo.Bar
	unmenu Foo
endfunction 

" From an idea by Michael Naumann
function! VisualSearch(direction) range
	let l:saved_reg = @"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "")

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
let g:proj_flags="isg"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wrap stuff around visual text
" Typing a comma + the punctutation will wrap selection with punctuation
vnoremap <leader>( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>[ <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>{ <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>< <esc>`>a><esc>`<i<<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader><space> <esc>`>a<space><esc>`<i<space><esc>
nnoremap <leader><space> i<space><esc>la<space><esc>l
" This bad boy will let you wrap a visual selection with a {, but with a twist:
"   it will place a newline before both the opening and closing brace
"   all lines are also reindented to make them pretty
vnoremap ,.{ <esc>`>a<cr>}<esc>`<i{<cr><esc>gvj=

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i

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
let g:tagbar_singleclick=1

" ==================================================================
" MinibufExplorer Plugin
" ==================================================================
"let g:miniBufExplMapWindowNavVim = 1 
"let g:miniBufExplMapWindowNavArrows = 1 " Use CTL-arrows to move between windows
"let g:miniBufExplMapCTabSwitchBufs = 1 
" Map Ctrl-h, Ctrl-l to move left/right between buffers
nnoremap <silent> <C-l> :bn<CR>
nnoremap <silent> <C-h> :bp<CR>
" Delete the current buffer with ctrl-c
nnoremap <silent> <C-c> :bd<CR>
" <,,b> toggles minibufexplorer
map <Leader>b :TMiniBufExplorer<cr>

let g:miniBufExplModSelTarget = 1	" Dont put new windows in non-modifiable
									"  buffers.	

let g:miniBufExplorerMoreThanOne = 2	" Don't start minibufexpl till 2 or more windows
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplSplitBelow=0 	" Open minibuf above/left of current window
let g:miniBufExplMaxSize=3  "Maximum size in lines

" ==================================================================
" Custom NERDTree commands
" ==================================================================
nnoremap TR :NERDTreeToggle<CR>

" ==================================================================
" SuperTab Settings
" ==================================================================
"let g:SuperTabDefaultCompletionType = "context"

" ==================================================================
" C/C++ Section
" ==================================================================
au FileType c,cpp highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au Filetype c,cpp match OverLength /\%81v.\+/

" ==================================================================
" Python Section
" ==================================================================
au FileType python set nocindent
au FileType python highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au FileType python match OverLength /\%81v.\+/
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

autocmd FileType python set omnifunc=pythoncomplete#Complete

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
" Search for 'class xxx' and 'def xxx'
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 

" Use pysmell tags for omnicomplete
autocmd FileType python set omnifunc=pythoncomplete#Complete
" Prevent from inserting first match
set completeopt+=longest
" Ctrl-Space launches omnicomplete
inoremap <Nul> <C-x><C-o>

" ==================================================================
" Save and restore folds on file open
" ==================================================================
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview


