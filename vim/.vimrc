set nocompatible
set t_Co=256 "config vim to use 256 colors set background=dark "to fix tmux wird colors problem
syntax on "basic python syntax

filetype plugin on "??
set completeopt+=menuone,noselect " always add autocomplete menu and dot select first match
set path+=** "search file in all subdirectory
set wildmenu "set menu to select if multible files match
set wildignore+=*.pyc "ignore python run files in search
set tabstop=4 "replace tab with 4 spaces
set shiftwidth=4 "number of spaces to auto indent
set expandtab " enter spaces when tab is presed
set number "line numbers
filetype indent on " indent script by file type
set showmatch

let mapleader = " "

augroup python_auto
    " run pylint every file save
    autocmd filetype python setlocal formatprg=autopep8\ -
    autocmd filetype python autocmd BufWritePre * silent execute "keepjumps normal mA \<C-Home>gq\<C-End>'A"
    autocmd filetype python autocmd BufWritePost *  silent call Pylint()
    autocmd FileType python set errorformat+=%f:%l:%c:\ %m " python compilation problems
    autocmd FileType python set errorformat+=%f:%l:\ %m " python pyflake format
augroup END

let my#file_name=''
function Pylint()
    let my#file_name='cach/' . expand('%:t:r') . '.err'
    let line='!pyflakes ' . expand('%') . ' &> ' . my#file_name
    execute line
    execute 'lfile ' . my#file_name
endfunction


" set tabname to filename
let &titlestring = @%
set title


" plagin support, initialize plagin meneger
call plug#begin('~/.vim/plugged')
Plug 'kh3phr3n/python-syntax'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-mucomplete'
Plug 'itchyny/lightline.vim'
Plug 'davidhalter/jedi-vim'
call plug#end()

" config light line
set laststatus=2 " uncrese line size recwiered for plugin
let g:my#pylint_len=''
function QuickFixLen()
    if &filetype=='python'
        let file_name='cach/' . expand('%:t:r') . '.err'
        if filereadable(file_name)
            let g:my#pylint_len=system('wc -l ' . file_name . ' | grep -o [0-9]* | head -1')
        else
            let g:my#pylint_len='NF'
        endif
    endif
    return g:my#pylint_len
endfunction

"config lightline
let g:lightline = {
            \ 'colorscheme': 'seoul256',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'readonly', 'filename', 'modified'] ],
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype', 'quickfix'] ]
            \},
            \ 'component_function': {
            \   'quickfix': 'QuickFixLen'
            \ },
            \ }

if strftime("%H") < 16
  set background=light
else
  set background=dark
endif
colorscheme solarized

" python-syntux plagin config
let g:python_highlight_all = 1 " enable python highlight from python syntax plugin


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

"config autocomplete
set completeopt-=preview
set completeopt+=menuone,noselect,noinsert
let g:jedi#popup_on_dot = 0 " dot autoto popup afterter dot
let g:mucomplete#enable_auto_at_startup = 0 "storeart autotocomplete autotomaticly
let g:jedi#show_call_signatures ="0" "dont show function arguments
"jedi shortcuts
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "gA"
let g:jedi#goto_definitions_command = "gD"
let g:jedi#goto_stubs_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "<leader>r"

" dearch highlight
set hlsearch

" fix higlight colors for search and jedi
highlight! default link jediUsage Visual
highlight! default link Search Visual 

"set t_ut="" "fix win 10 bag https://github.com/microsoft/terminal/issues/832
"set ttyscroll=1


" set relative number in command mode and absulote number when lose focus or
" insert mode
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


" pdb tools
au FileType python map <silent> <leader>o oimport pdb; pdb.set_trace()<esc>
au FileType python map <silent> <leader>O Oimport pdb; pdb.set_trace()<esc>
au filetype python map <silent> <leader>x :g/pdb/d<esc>
