set encoding=utf-8
set number " show line numbers
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab " tabs are spaces
set cursorline " highlight current line
set lazyredraw " redraw only when we need to
set showmatch " highlight matching [{()}]
set shortmess+=I " remove startup message
set listchars=tab:→\ ,nbsp:␣,trail:•,eol:¬,precedes:«,extends:»
set list
set updatetime=100

set hlsearch

" do a case-sensitive search when the search string contains uppercase characters
" do a case-insensitive search when the search string is entirely lowercase
:set ignorecase
:set smartcase

" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
set swapfile
set directory^=~/.vim/swap//

" protect against crash-during-write
set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
" patch required to honor double slash at end
if has("patch-8.1.0251")
  " consolidate the writebackups -- not a big
  " deal either way, since they usually get deleted
  set backupdir^=~/.vim/backup//
end

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" persist the undo tree for each file
set undofile
set undodir^=~/.vim/undo//

" spellchecking
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell " Autocomplete with dictionary words when spell check is on
set spellfile=$HOME/.vim/spell-en.utf-8.add

call plug#begin('~/.vim/vim-plug')
Plug 'https://github.com/ActivityWatch/aw-watcher-vim.git'
Plug 'https://github.com/Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'https://github.com/Yggdroot/indentLine.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/dense-analysis/ale.git'
Plug 'https://github.com/editorconfig/editorconfig-vim.git'
Plug 'https://github.com/janko/vim-test.git'
Plug 'https://github.com/junegunn/fzf.git'
Plug 'https://github.com/junegunn/fzf.vim.git'
Plug 'https://github.com/luizribeiro/vim-cooklang.git', { 'for': 'cook' }
Plug 'https://github.com/mbbill/undotree.git'
Plug 'https://github.com/mfussenegger/nvim-dap.git'
Plug 'https://github.com/morhetz/gruvbox.git'
Plug 'https://github.com/nathangrigg/vim-beancount.git'
Plug 'https://github.com/ryanoasis/vim-devicons.git'
Plug 'https://github.com/sheerun/vim-polyglot'
Plug 'https://github.com/stsewd/fzf-checkout.vim.git'
Plug 'https://github.com/tpope/vim-abolish.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-eunuch.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-sensible.git'
Plug 'https://github.com/tpope/vim-sleuth.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/vim-airline/vim-airline.git'
call plug#end()

let g:deoplete#enable_at_startup = 1

let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

let g:indentLine_char = '▏'

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" keyboard shortcuts
nmap <silent> <leader>p :Files<CR>
nmap <silent> <C-p> :Files<CR>

" ale
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_linters = {}
let g:ale_linters.elixir = ['elixir-ls', 'credo']
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'cpp': ['clang-format'],
\   'elixir': ['mix_format'],
\   'javascript': ['standard'],
\   'python': ['autopep8'],
\   'ruby': ['rubocop'],
\   'scss': ['stylelint'],
\}
let g:ale_elixir_elixir_ls_release = '/data/proj/forks/elixir-ls/release'
let g:ale_elixir_credo_strict = 1

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

" exclude junk from ctags
let g:fzf_tags_command = 'rg --files | ctags -R --links=no -L -'
