set encoding=utf-8
set number relativenumber
set notermguicolors
set nohlsearch
set scrolloff=5

" Tab Settings "
set tabstop=3
set shiftwidth=3 " # Indenting "
set expandtab " When tab is pressed, use tabstop number of whitespaces "
filetype indent on

" Enable auto completion menu by pressing TAB "
set wildmenu
set wildmode=longest,list,full

" Ignore files to edit using vim "
set wildignore=*.docx,*.jpg,*.png,*.pdf,*.swp

" == Splits =="
set splitbelow
set splitright

" = Navigation = "
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Close a window with Ctrl+q "
nnoremap <C-Q> :close<CR>

" == Changing Sizes =="
nnoremap <silent> <C-Left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>

" = Buffer Navigation = "
nnoremap <Leader>b :ls<CR>:b!<Space> 

" Alias S to global substitution "
nnoremap S :%s///g<Left><Left><Left>

" = Plugins =" 
call plug#begin()

Plug 'itchyny/lightline.vim' "Status Line"
Plug 'vimwiki/vimwiki'
Plug 'ap/vim-css-color'

call plug#end()

" == VimWiki Settings =="
set nocompatible
filetype plugin on
syntax on

let wiki_1 = {}
let wiki_1.path = '~/Sync/Documents/VimWiki/Personal/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'
let wiki_1.links_space_char = '-'

let wiki_2 = {}
let wiki_2.path = '~/Sync/Documents/VimWiki/Cooking/'
let wiki_2.syntax = 'markdown'
let wiki_2.ext = '.md'
let wiki_2.links_space_char = '-'

" === Global VimWiki Settings === "
let g:vimwiki_use_calendar = 0
let g:vimwiki_auto_chdir = 1 " Change directory to wiki root "
let g:vimwiki_markdown_link_ext = 0
let g:vimwiki_auto_header = 0
let g:vimwiki_list = [wiki_1, wiki_2]

" == Lightline Settings =="
"set noshowmode"
"set laststatus=2"
"let g:lightline = { 'colorscheme': 'powerlineish' }"

nmap Y y$

" Copy and Paste to and from the system clipboard "
" E.g Visually select lines and press leader y to copy the text (paste with Ctrl+v)"
nnoremap <leader>p "+p
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" Spell Checking "
set spelllang=en_gb
nnoremap <leader>s :setlocal spell<CR>
nnoremap <leader>S :setlocal nospell<CR>

" Remain in visual block to allow for successive indentation "
vmap < <gv
vmap > >gv

" Ensure files are read properly "
autocmd BufRead,BufNewFile *.py set filetype=python
autocmd BufRead,BufNewFile *.sh set filetype=sh
autocmd BufRead,BufNewFile *.svm set filetype=sh

" Compile and open a compiled document (PDFs) "
map <leader>w :w! \| ! compiler <c-r>%<CR><CR>
map <silent> <leader>o :! opout <c-r>%<CR><CR>

" Shortcut for inserting single-line comments "
autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>
autocmd FileType sh nnoremap <buffer> <localleader>c I# <esc>
autocmd FileType vim nnoremap <buffer> <localleader>c I" <esc>A "<esc>
