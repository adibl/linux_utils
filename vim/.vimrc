set nocompatible
filetype on
set t_Co=256 "config vim to use 256 colors set background=dark "to fix tmux wird colors problem
syntax on "basic python syntax
filetype plugin on "??
set showmatch
let mapleader = " "

" search
set path+=** "search file in all subdirectory
set wildmenu "set menu to select if multible files match
set wildignore+=*.pyc "ignore python run files in search
set wildignore+=*.err "ignore err files creted by pyflakes

"tabs and indent
set tabstop=4 "replace tab with 4 spaces
set shiftwidth=4 "number of spaces to auto indent
set expandtab " enter spaces when tab is presed
filetype indent on " indent script by file type

" python autocommand
augroup python_auto
    autocmd!
    autocmd filetype python autocmd BufWritePre * silent LspDocumentFormatSync
augroup END


" set tabname to filename
let &titlestring = @%
set title

" add .profile configs to vim shell
" open bag: alias dont work
set shell=/bin/bash\ --rcfile\ ~/.profile

" vim temporery files
set backupdir=~/.vim/cache " Directory to store backup files.
set confirm " Display a confirmation dialog when closing an unsaved file.
set dir=~/.vim/cache " Directory to store swap files.
set undofile "save undo history even when file is closed
set undodir=~/.vim/undo " undo files path

" diff config
set diffopt+=indent-heuristic "see if line that was deleted is few lines after
set diffopt+=algorithm:histogram "change to best algiruithem
set diffopt+=iwhiteall " ignore all white spaces

" search highlight
set hlsearch

" fix higlight colors for search 
highlight! default link Search Visual 

"set t_ut="" "fix win 10 bag https://github.com/microsoft/terminal/issues/832
"set ttyscroll=1


"numbers
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

" plagin support, initialize plagin meneger
call plug#begin('~/.vim/plugged')
Plug 'kh3phr3n/python-syntax'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-mucomplete'
Plug 'itchyny/lightline.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
call plug#end()

"lightline config
" see error file length function
set laststatus=2 " uncrese line size recwiered for plugin
let g:my#pylint_len=''
let g:my#prev_pylint_len=''
function! LocalListLen() abort
    let l:dict = lsp#get_buffer_diagnostics_counts()
    let l:sum =  l:dict.error + l:dict.warning
    if g:my#pylint_len != l:sum 
        let g:my#prev_pylint_len=g:my#pylint_len
        let g:my#pylint_len=l:sum
    endif
    return g:my#pylint_len . '<-' . g:my#prev_pylint_len
endfunction
" lightline config
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
            \   'quickfix': 'LocalListLen'
            \ },
            \ }

" colorscheme config
if strftime("%H") < 16
  set background=light
else
  set background=dark
endif
colorscheme solarized

" python-syntux plagin config
let g:python_highlight_all = 1 " enable python highlight from python syntax plugin


" lsp config
if executable('pyls')
    autocmd! User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ 'root_uri':{server_info->lsp#utils#path_to_uri(
                \	lsp#utils#find_nearest_parent_file_directory(
                \		lsp#utils#get_buffer_path(),
                \		'.git/'
                \ ))},
                \ })
endif
let g:lsp_signs_enabled = 0
let g:lsp_preview_float = 1 " dont use float window to hover
nnoremap <leader>d :LspDefinition<CR>
nnoremap <leader>r :LspRename<CR>
nnoremap K :LspHover<CR>
nnoremap [e :LspNextDiagnostic<CR>
nnoremap ]e :LspPreviousDiagnostic<CR>
let g:lsp_diagnostics_echo_cursor = 1
setlocal omnifunc=lsp#complete
let g:lsp_textprop_enabled = 0 " disable color errors
let g:lsp_signature_help_enabled = 0 " unable float woindow of current function argument data


"config autocomplete
set completeopt-=popup
set completeopt-=preview
set completeopt+=menuone,noselect,noinsert
let g:mucomplete#enable_auto_at_startup = 0 "storeart autotocomplete autotomaticly

