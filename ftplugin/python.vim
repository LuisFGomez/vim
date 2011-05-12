""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""

" Save and Execute file being edited with <Shift> + e
map <buffer><S-e> :w<CR>:!/usr/bin/env python %	<CR>
source ~/.vim/ftplugin/jpythonfold.vim
