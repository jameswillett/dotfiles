set nocompatible              " be iMproved, required
filetype off                  " required

let mapleader = ","

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'SirVer/ultisnips'
Plugin 'Valloric/MatchTagAlways'
Plugin 'Valloric/YouCompleteMe'
Plugin 'VundleVim/Vundle.vim'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'dikiaap/minimalist'
Plugin 'elmcast/elm-vim'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'honza/vim-snippets'
Plugin 'junegunn/gv.vim'
Plugin 'mileszs/ack.vim'
Plugin 'moll/vim-node'
Plugin 'mxw/vim-jsx'
Plugin 'nono/vim-handlebars'
Plugin 'othree/es.next.syntax.vim'
Plugin 'othree/yajs.vim'
Plugin 'ruanyl/vim-gh-line'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-airline'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'vim-syntastic/syntastic'
Plugin 'w0rp/ale'
Plugin 'wikitopian/hardmode'
Plugin 'amadeus/vim-mjml'

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""
" nerdtree 
"""
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>
let NERDTreeShowHidden=1

"""
" syntastic
"""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_warning_symbol = "∆"
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_style_warning_symbol = '💩'


"""
" fugitive
"""

set statusline+=%{FugitiveStatusLine()}

"""
" ale
"""

let g:ale_sign_error = "💩"
let g:syntastic_warning_symbol = "∆"
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_offset = 1000000
let g:ale_sign_warning = '🚩'
let g:ale_statusline_format = ['💣 %d', '🚩 %d', '']

"""
" airline
"""

let g:airline_powerline_fonts = 1

"""
" match tag always
"""

let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'javascript' : 1,
    \}

"""
" vim-jsx
"""

let g:jsx_ext_required = 0

"""
" ultisnips
"""

let g:UltiSnipsEditSplit = 'context'

"""
" vim-jsdoc
"""

let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1
let g:jsdoc_allow_shorthand = 1

"""
" the rest of it
"""

noremap <Up> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <Down> <Nop>
inoremap <Up> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Down> <Nop>

set path+=**
set number relativenumber
syntax enable
set autoread

set ignorecase
set smartcase
set hlsearch
set incsearch
set nolazyredraw
set magic

set visualbell

set wrap
set wrapmargin=8
set linebreak
set showbreak=…
set autoindent
set ttyfast
set wildmenu
set showcmd
set showmatch

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

try
  colorscheme minimalist
catch
endtry

set background=dark

"Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

nmap <leader>gf :CtrlP<CR><C-\>w
nmap <leader>so :source ~/.vimrc<cr>
set encoding=utf8

set nobackup
set nowb
set noswapfile

set expandtab
set shiftwidth=2
set tabstop=2

set ai
set si
set wrap
set backspace=indent,eol,start

ab flase false
ab ms2p mapStateToProps
ab md2p mapDispatchToProps

map <silent> <leader>dr A // eslint-disable-line 
map <silent> <leader>dl me,dr<bs><esc>`e:delmark e<cr>
map <space> /
map <c-space> ?

map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

map <silent> <leader>bd :Bclose<cr>:tabclose<cr>gT
map <silent> <leader>tn :tabnew<cr>
map <silent> <leader>to :tabonly<cr>
map <silent> <leader>tc :tabclose<cr>
map <silent> <leader>tm :tabmove<cr>
map <silent> <leader>tt :tabnext<cr>

highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000

let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

map <leader>cd :cd %:p:h<cr>:pwd<cr>

try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" ∆ is alt-j ˚ is alt-k ˙ is alt-h ¬ is alt-l
" move line or lines up and down and left and right
nmap <silent> ∆ @='mz:m+<C-V><C-M>`z:delmark z<C-V><C-M>'<cr>
nmap <silent> ˚ @='mz:m-2<C-V><C-M>`z:delmark z<C-V><C-M>'<cr>
nmap <silent> ¬ @='xp'<cr>
nmap <silent> ˙ @='xhP'<cr>
vmap <silent> ∆ @=':m''>+<C-V><C-M>`<my`>mzgv`yo`z'<cr>
vmap <silent> ˚ @=':m''<-2<C-V><C-M>`>my`<mzgv`yo`z'<cr>
vmap <silent> ¬ @='xp`[v`]'<cr>
vmap <silent> ˙ @='xhP`[v`]'<cr>

" ø is alt-o
" pad line(s) with blank lines
nmap <silent> ø @='moO<esc>jo<esc>`o:delmark o<C-V><C-M>'<cr>
vmap <silent> ø @='<C-V><esc>`<O<C-V><esc>`>o<C-V><esc>gv'<cr>

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

set list
nmap <leader>l :set list!<CR>
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  endif
  return ''
endfunction

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum    
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

function! CmdLine(str)
  call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ack '" . l:pattern . "' " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

augroup suffixes
    autocmd!

    let associations = [
                \["javascript", ".js,.javascript,.es,.esx,.json"],
                \["python", ".py,.pyw"]
                \]

    for ft in associations
        execute "autocmd FileType " . ft[0] . " setlocal suffixesadd=" . ft[1]
    endfor
augroup END
set mouse=
set ttymouse=
