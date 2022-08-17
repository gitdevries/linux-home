" Seems to be needed
set nocompatible

" Vim Plugins
call plug#begin()
 Plug 'dracula/vim'
 Plug 'ryanoasis/vim-devicons'
 Plug 'scrooloose/nerdtree'
 Plug 'mhinz/vim-startify'
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Vim Theme
syntax enable
syntax on
colorscheme dracula

" Vim Commands
set showmatch
set ignorecase
set hlsearch
set incsearch
set tabstop=4               " Columns occupied by tab 
set softtabstop=4
set expandtab               " Tabs to space
set shiftwidth=4
set autoindent
set number
set wildmode=longest,list   " Tab completions
filetype plugin indent on   " Auto indent
set mouse=a                 " Enable mouse click
set clipboard=unnamedplus   " System clipboard
filetype plugin on
set cursorline
set ttyfast

" Vim Autostart
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Vim Keymaps
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

:inoremap ii <Esc>