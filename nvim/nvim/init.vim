set encoding=utf-8
colorscheme badwolf
set number " show line numbers
syntax enable " enable syntax highlighting
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab " tabs are spaces
set cursorline " highlight current line
filetype indent on " load filetype-specific indent files
set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when we need to
set showmatch " highlight matching [{()}]
set shortmess+=I " remove startup message
set listchars=tab:→\ ,nbsp:␣,trail:•,eol:¬,precedes:«,extends:»
set list
set updatetime=100

set hlsearch

" spellchecking
autocmd BufRead,BufNewFile *.md setlocal spell
set complete+=kspell " Autocomplete with dictionary words when spell check is on
set spellfile=$HOME/.vim/spell-en.utf-8.add

let g:indentLine_char = '┆'

call plug#begin('~/.vim/vim-plug')
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-sleuth.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/editorconfig/editorconfig-vim.git'
Plug 'https://github.com/janko/vim-test.git'
Plug 'https://github.com/Yggdroot/indentLine.git'
Plug 'https://github.com/junegunn/fzf.git'
Plug 'https://github.com/junegunn/fzf.vim.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/sheerun/vim-polyglot'
Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/w0rp/ale.git'
Plug 'https://github.com/nathangrigg/vim-beancount.git'
Plug 'https://github.com/ryanoasis/vim-devicons.git'
Plug 'https://github.com/ActivityWatch/aw-watcher-vim.git'
call plug#end()

" keyboard shortcuts
nmap <silent> <leader>p :Files<CR>
nmap <silent> <C-p> :Files<CR>

" ale
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_linters = {}
let g:ale_linters.elixir = ['elixir-ls']
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'elixir': ['mix_format'],
\   'javascript': ['standard'],
\   'scss': ['stylelint'],
\}
let g:ale_elixir_elixir_ls_release = '/data/proj/forks/elixir-ls/rel'

" airline
set ttimeoutlen=50
set noshowmode " mode is shown by airline

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''

" allow ctrl + backspace to remove an entire word
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" use system clipboard for everything
set clipboard=unnamedplus

" use fzf for spelling suggestions

function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction
function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
endfunction
nnoremap z= :call FzfSpell()<CR>
