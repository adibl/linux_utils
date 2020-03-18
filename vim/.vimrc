set nocompatible
set t_Co=256 "config vim to use 256 colors set background=dark "to fix tmux wird colors problem
syntax on "basic python syntax
filetype plugin indent on " activate filetype based plugin and indentation
set showmatch
let mapleader = " "

set path+=** "search file in all subdirectory
set wildmenu "set menu to select if multible files match
set wildignore+=*.pyc "ignore python run files in search
set wildignore+=*.err "ignore err files creted by pyflakes

"tabs and indent
set tabstop=4 "replace tab with 4 spaces
set shiftwidth=4 "number of spaces to auto indent
set expandtab " enter spaces when tab is presed

" add some emacs keybindings to insert and command modes
inoremap <C-A> <C-o>^
cnoremap <C-A> <Home>
inoremap <C-e> <End>

" python autocommand
augroup python_auto
    autocmd!
    " pdb tools
    autocmd filetype python map <silent> <leader>o oimport pdb; pdb.set_trace()<esc>
    autocmd filetype python map <silent> <leader>O Oimport pdb; pdb.set_trace()<esc>
    autocmd filetype python map <silent> <leader>x :g/pdb/d<esc>
    " lsp shortcats
    autocmd filetype python nnoremap <leader>d :LspDefinition<CR>
    autocmd filetype python nnoremap <leader>f :LspDocumentFormatSync<CR>
    autocmd filetype python nnoremap <leader>r :LspRename<CR>
    autocmd filetype python nnoremap K :LspHover<CR>
setlocal omnifunc=lsp#complete
augroup END

" c autocommand
augroup c_auto
    autocmd!
    autocmd filetype c set makeprg=cc\ % 
    " indent all file without moving curresor, use marks
    autocmd filetype c map <leader>f ma:call Format()<CR>:w<CR> 'a
    autocmd filetype c set formatprg=indent\ -kr\ --no-tabs
augroup END

function Format()
    silent :%!indent -kr --no-tabs
    call UndoIfShellError()
endfunction

function! UndoIfShellError()
    if v:shell_error
        undo
    endif
endfunction

" copy filetype
nmap <leader>cn :let @+=expand("%")<CR>
nmap <leader>cp :let @+=expand("%:p")<CR>

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

" search highlight disabled
" set hlsearch
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


" plagin support, initialize plagin meneger
call plug#begin('~/.vim/plugged')
Plug 'kh3phr3n/python-syntax'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-mucomplete'
Plug 'itchyny/lightline.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'takac/vim-hardtime'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

"diable thingw with hardtime
let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
let g:hardtime_ignore_quickfix = 1
let g:hardtime_allow_different_key = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
" let g:list_of_insert_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_disabled_keys = []

"lightline config
" see error file length function
set laststatus=2 " uncrese line size recwiered for plugin
let g:my#pylint_len=''
let g:my#prev_pylint_len=''
let g:my#time=reltime()
function LocalListLen()
    if(&ft=='python')
        silent! call UpdatLen()
        return g:my#pylint_len . '<-' . g:my#prev_pylint_len
    endif
endfunction

function UpdatLen()
    if reltimefloat(reltime(g:my#time)) < 5.0
        if (g:my#pylint_len != len(getloclist(0)))
            let g:my#prev_pylint_len = g:my#pylint_len
            let g:my#pylint_len = len(getloclist(0))
        endif
    else
        LspDocumentDiagnostics
        let g:my#time = reltime()
    endif
endfunction
" lightline config
let g:lightline = {
            \ 'colorscheme': 'solarized',
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
                \ 'workspace_config': {'pyls': {'plugins': {'pycodestyle': {'enabled': v:false}}}},
                \ 'root_uri':{server_info->lsp#utils#path_to_uri(
                \	lsp#utils#find_nearest_parent_file_directory(
                \		lsp#utils#get_buffer_path(),
                \		'.git/'
                \ ))},
                \ })
endif
let g:lsp_signs_enabled = 0
let g:lsp_preview_float = 1 " dont use float window to hover
let g:lsp_textprop_enabled = 0 " enfable
let g:lsp_signature_help_enabled = 0 " unable float woindow of current function argument data


"config autocomplete
set completeopt-=popup
set completeopt-=preview
set completeopt+=menuone,noselect,noinsert
let g:mucomplete#enable_auto_at_startup = 0 "storeart autotocomplete autotomaticly


" vim-sandwich resapoes
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
autocmd filetype c let g:sandwich#recipes += [
            \   {
            \     'buns'        : ['{', '}'],
            \     'motionwise'  : ['line'],
            \     'kind'        : ['add'],
            \     'command'     : ["normal '[=']'", "'[-1normal J"],
            \   },
            \ ]
