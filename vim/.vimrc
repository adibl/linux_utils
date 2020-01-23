set t_Co=256 "config vim to use 256 colors set background=dark "to fix tmux wird colors problem
syntax on "basic python syntax

filetype plugin on "??
set completeopt+=menuone,noselect " always add autocomplete menu and dot select first match
set path+=** "search file in all subdirectory
set wildmenu "set menu to select if multible files match
set tabstop=4 "replace tab with 4 spaces
set shiftwidth=4 "number of spaces to auto indent
set expandtab " enter spaces when tab is presed
set number "line numbers
filetype indent on " indent script by file type

let mapleader = " "
nnoremap <leader>r <C-c>:w<CR>:!python % 

" set tabname to filename
let &titlestring = @%
set title


" plagin support, initialize plagin meneger
call plug#begin('~/.vim/plugged')
Plug 'kh3phr3n/python-syntax'
Plug 'junegunn/seoul256.vim' 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lifepillar/vim-mucomplete'
Plug 'davidhalter/jedi-vim'
call plug#end()

" python-syntux plagin config
let g:python_highlight_all = 1 " enable python highlight from python syntax plugin

" activate papercolor-theme
let g:seoul256_background = 235
colo seoul256
" set airline theme
let g:airline_theme='angr'

" make :make % run pylint on current file and move to quickfix window
" bag: don't sort by line numbers;
autocmd FileType python set makeprg=pylint\ --reports=n\ --output-format=parseable
autocmd FileType python set errorformat=%f:%l:\ %m
autocmd QuickFixCmdPost [^l]* cwindow


" add .profile configs to vim shell
" open bag: alias dont work
set shell=/bin/bash\ --rcfile\ ~/.profile

set backupdir=~/.vim/cache " Directory to store backup files.
set confirm " Display a confirmation dialog when closing an unsaved file.
set dir=~/.vim/cache " Directory to store swap files.
set undofile "save undo history even when file is closed
set undodir=~/.vim/undo " undo files path

" diff config
set diffopt+=indent-heuristic "see if line that was deleted is few lines after
set diffopt+=algorithm:histogram "change to best algiruithem
set diffopt+=iwhiteall " ignore all white spaces
set diffopt+=iblank " ignore blank lines changes

"config autocomplete
set completeopt-=preview
set completeopt+=longest,menuone,noselect
let g:jedi#popup_on_dot = 0 " dot autoto popup afterter dot
let g:mucomplete#enable_auto_at_startup = 0 "storeart autotocomplete autotomaticly
let g:jedi#show_call_signatures = "0" "dont show function arguments
"jedi shortcuts
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = ""
