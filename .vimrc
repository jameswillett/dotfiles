set nocompatible              " be iMproved, required
filetype plugin on

let mapleader = ","

autocmd!
runtime macros/matchit.vim

call plug#begin('~/.vim/plugged')
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'
Plug 'Valloric/MatchTagAlways'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dikiaap/minimalist'
Plug 'morhetz/gruvbox'
Plug 'elmcast/elm-vim'
Plug 'heavenshell/vim-jsdoc'
Plug 'inkarkat/vim-SyntaxRange'
Plug 'junegunn/gv.vim'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-node'
Plug 'mxw/vim-jsx'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'neoclide/coc.nvim'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/yajs.vim'
Plug 'ruanyl/vim-gh-line'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'supercollider/scvim'
Plug 'tidalcycles/vim-tidal'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-abolish'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rails'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'sirosen/vim-rockstar'
Plug 'dense-analysis/ale'
Plug 'neovimhaskell/haskell-vim'
Plug 'mityu/vim-applescript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'leafgarland/typescript-vim'
Plug 'ap/vim-css-color'
Plug 'xavierchow/vim-swagger-preview'
Plug 'yardnsm/vim-import-cost', { 'do': 'npm install --production' }
Plug 'digitaltoad/vim-pug'
Plug 'andweeb/presence.nvim'
Plug 'ElijahLynn/sourcegraph-vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" plugins to extend text objects
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object' " dii
Plug 'nelstrom/vim-textobj-rubyblock' " dir
Plug 'vim-scripts/argtextobj.vim' " dia
Plug 'vim-scripts/BufOnly.vim'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting
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
let g:NERDTreeShowIgnoredStatus = 1

"""
" fugitive
"""

set statusline+=%{FugitiveStatusLine()}

"""
" ale
"""

let g:ale_sign_error = "💩"
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_offset = 1000000
let g:ale_sign_warning = '🤔'
let g:ale_statusline_format = ['💣 %d', '🚩 %d', '']
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tslint', 'tsserver'],
\   'typescriptreact': ['eslint', 'tslint', 'tsserver'],
\   'python': ['flake8', 'pylint'],
\   'ruby': ['standardrb'],
\   'haskell': ['brittany', 'hlint'],
\}
let g:ale_fixers = {
\   'javascript': ['eslint', 'prettier'],
\   'typescript': ['eslint', 'prettier'],
\   'typescriptreact': ['eslint', 'prettier'],
\   'haskell': ['brittany', 'hlint'],
\   'ruby': ['standardrb'],
\}

let g:ale_haskell_ghc_options = '-package random -package xmonad-contrib -package X11 -package xmonad'
let g:ale_typescript_tsserver_use_global = 1

"""
" airline
"""

let g:airline_powerline_fonts = 1
let g:filetype_icons = {
      \ 'vim': '',
      \ 'haskell': '',
      \ 'tidal': '',
      \ 'javascript.jsx': '',
      \ 'ruby': '',
      \ 'python': '',
    \}

function! AddFTGlyph(...)
  if has_key(g:filetype_icons, &ft)
    let w:airline_section_x = g:filetype_icons[&ft]
  endif
endfunction

autocmd VimEnter * call airline#add_statusline_func('AddFTGlyph')

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
" vim-jsdoc
"""

let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1
let g:jsdoc_allow_shorthand = 1

"""
" vim-indent-guides
"""

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
autocmd FileType isml setlocal shiftwidth=4 tabstop=4

"""
" tidal vim stuff
"""

autocmd FileType tidal inoremap <C-e> <C-e><esc>

"""
" scvim
"""

au BufEnter,BufWinEnter,BufNewFile,BufRead *.sc,*.scd set filetype=supercollider
au Filetype supercollider packadd scvim
let g:scFlash = 1

"""
" leaderf
"""

let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_CommandMap = {'<Up>': [], '<C-Up>': ['<Up>'], '<Down>': [], '<C-Down>': ['<Down>']}

"""
" ack
"""

let g:ackhighlight = 1
let g:ack_use_dispatch = 1

"""
" vim-jsdoc
"""

nmap <silent> <leader>jd <Plug>(jsdoc)

"""
" LSP stuff
"""

let g:LanguageClient_serverCommands = {
    \ 'haskell': ['haskell-language-server-9.0.2']
    \ }


let g:gh_trace=1
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

" inoremap <silent> <cr> <cr><esc>:Start! echo -e '\a'<cr>i

set path+=**
set number relativenumber
syntax enable
set autoread

set backup
set backupdir=~/.vim/backupfiles//
set dir=~/.vim/swapfiles//
set undodir=~/.vim/undodir
set undofile

set hlsearch
set ignorecase
set incsearch
set magic
set nolazyredraw
set smartcase

set colorcolumn=100
set visualbell

set autoindent
set cursorline
set cursorcolumn
set linebreak
set showbreak=…
set showcmd
set showmatch
set ttyfast
set wildmenu

set wrap
set wrapmargin=0
set textwidth=0

set complete+=kspell

autocmd VimEnter * :Dispatch bash ~/configs/scripts/initvimstuff
set thesaurus+=~/.vim/thesaurus/mthesaur.txt

nmap Q :echo "i bet you didnt want to go to EX mode... hit alt-Q to actually enter EX mode"<cr>
nnoremap Œ Q
nnoremap q: q::echo "its cuz you typed q: ya dummy"<cr>
command! Q :q
command! Qa :qa
command! QA :qa

" spell check off by default
autocmd VimEnter * :set nospell
nnoremap <silent> <leader>sp :set spell!<cr>

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif


function s:SetTheme()
  try
    colorscheme gruvbox
  catch
  endtry
endfunction

set t_ZH=[3m
set t_ZR=[23m

function! AltHighlight()
  call SyntaxRange#Include('\vQueryService(\n\s*)?\.query(One)?\((\n\s*)?`', '\v`(\n\s*)?(,|\))', 'sql')
  call SyntaxRange#Include('\vQueryService(\n\s*)?\.query(One)?\((\n\s*)?''', '\v''(\n\s*)?(,|\))?', 'sql')
  call SyntaxRange#Include('\vuery \= `', '`', 'sql')
  call SyntaxRange#Include('\vsql \= `', '`', 'sql')
  call SyntaxRange#Include('\v(pool(\n\s*)?\.)?query\((\n\s*)?`', '\v`(\n\s*)?(,|\))', 'sql')
  call SyntaxRange#Include('\v(pool(\n\s*)?\.)?query\((\n\s*)?''', '\v''(\n\s*)?(,|\))?', 'sql')
  call SyntaxRange#Include('\v\<style(.*)jsx','\v(`)?\<\/style', 'css', 'xmlTagName')
  call SyntaxRange#Include('\v\:\{(\n)?','\v(\n)?\:\}', 'haskell')
endfunction

autocmd BufReadPost * call AltHighlight()

function s:Colors(bg, ...)
  call s:SetTheme()
  set background=dark

  if a:bg == 'dark'
    if exists(':AirlineTheme')
      AirlineTheme gruvbox
    endif
  elseif a:bg == 'light'
    hi Normal ctermfg=245 cterm=NONE guifg=NONE gui=NONE ctermbg=black
    AirlineTheme base16_twilight
  endif
  hi clear SignColumn
  hi Pmenu ctermfg=15 ctermbg=234
  hi ColorColumn ctermbg=60 ctermfg=7
  hi IndentGuidesOdd ctermbg=236
  hi IndentGuidesEven ctermbg=237
  hi NonText ctermfg=darkgrey guifg=grey70
  hi SpecialKey ctermfg=darkgrey guifg=grey70
  hi Comment gui=italic cterm=italic
  hi CursorLineNr ctermfg=34 cterm=italic

  " vanilla hs gruvbox colors are a little bland
  hi! link hsVarSym GruvboxBlue
  hi! link hsDelimiter GruvboxYellow 
  hi! link ConId GruvboxFg4
endfunction

autocmd VimEnter * call s:Colors('dark', 'init')
autocmd BufReadPost *.tsx,*.ts,*.js,*.jsx :ImportCost


" this was cool while it lasted but working in big files would make nvim chug
" if exists('$TMUX')
"   autocmd FocusGained * call s:Colors('dark')
"   autocmd FocusLost * call s:Colors('light')
" else
" endif


"Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
  try
    set guifont=JetBrainsMono\ Nerd\ Font:h11
  catch
  endtry
endif

if has('nvim-0.4.3') || has('patch-8.2.0750')
          nnoremap <nowait><expr> <C-p> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <nowait><expr> <C-p> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <nowait><expr> <C-n> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
endif

nmap <leader>so :source ~/.vimrc<cr>
set encoding=utf8

set expandtab
set shiftwidth=2
set tabstop=2

set ai
set si
set backspace=indent,eol,start

ab flase false
ab ms2p mapStateToProps
ab md2p mapDispatchToProps

function GetRule()
  return substitute(execute("1 messages"), ":.*$", "", "")
endfunction

let g:workingWithjsxComment = 0

function GetCommentType(flag)
  if index(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")'), "jsxRegion") >= 0
    let g:workingWithjsxComment = 1
    let suffix = ' '
    if a:flag == 'l'
      let suffix = '-next-line '
    endif
    return 'O{/* eslint-disable' . suffix
  else
    return 'A // eslint-disable-line'
  endif
endfunction

function MaybeCloseComment()
  if g:workingWithjsxComment == 1
    let g:workingWithjsxComment = 0
    return ' */}'
  else
    return ''
  endif
endfunction


map <silent> <leader>_dl mei<c-r>=GetCommentType('l')<cr>
map <silent> <leader>_dr mei<c-r>=GetCommentType('r')<cr>
map <silent> <leader>dr ,_dr <c-r>=GetRule()<cr><c-r>=MaybeCloseComment()<cr><esc>kJ`e:delmark e<cr>
map <silent> <leader>dl ,_dl<c-r>=MaybeCloseComment()<cr><esc>`e:delmark e<cr>
map <space> /
map <c-space> ?

map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

map <silent> <leader>bd :Bclose<cr>:tabclose<cr>gT
map <silent> <leader>bo :Bonly<cr>
map <silent> <leader>tn :tabnew<cr>
map <silent> <leader>to :tabonly<cr>
map <silent> <leader>tc :tabclose<cr>
map <silent> <leader>tm :tabmove<cr>
map <silent> <leader>tt :tabnext<cr>

" open vimrc in new buffer
map <silent> <leader>ev ,tn:e ~/configs/.vimrc<cr>

" open vimrc in new split
map <silent> <leader>sv :split ~/configs/.vimrc<cr>

map <silent> <leader>sy :syntax sync minlines=20<cr>

let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

map <leader>cd :cd %:p:h<cr>:pwd<cr>

" “ is alt-[, ‘ is alt-]
" better remap for me to move by hunk
nmap “ <Plug>(GitGutterPrevHunk)
nmap ‘ <Plug>(GitGutterNextHunk)

nnoremap <leader>% :MtaJumpToOtherTag<cr>

" "complicated" mapping to get into and out of insert mode
" with a clutch
nmap <S-F1> i
imap <S-F2> <esc>

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
nmap <silent> ∆ ]e
nmap <silent> ˚ [e
nmap <silent> ¬ @='xp'<cr>
nmap <silent> ˙ @='xhP'<cr>
vmap <silent> ∆ @=':m''>+<C-V><C-M>`<my`>mzgv`yo`z'<cr>
vmap <silent> ˚ @=':m''<-2<C-V><C-M>`>my`<mzgv`yo`z'<cr>
vmap <silent> ¬ @='xp`[v`]'<cr>
vmap <silent> ˙ @='xhP`[v`]'<cr>

" scroll window faster
nmap <silent> <C-E> @='4<C-V><C-E>'<cr>
nmap <silent> <C-Y> @='4<C-V><C-Y>'<cr>

" ø is alt-o
" pad line(s) with blank lines
nmap <silent> ø @='moO<C-V><esc>jo<C-V><esc>`o:delmark o<C-V><C-M>'<cr>
vmap <silent> ø @='<C-V><esc>`<O<C-V><esc>`>o<C-V><esc>gv'<cr>

vmap <silent> u <esc>u

" Ô is shift-alt-j,  is shift-alt-k
" move forward or back eslint errors. works with counts
nmap <silent> Ô @=':ALENext<C-V><C-M>'<cr>
nmap <silent>  @=':ALEPrevious<C-V><C-M>'<cr>
nmap <silent> <leader>af :ALEFix<CR>

" map alt-a/alt-x to ctrl-a/ctrl-x, respectively
nmap å <C-a>
nmap ≈ <C-x>

" bootleg ass inner _ text objects
nmap ci_ T_ct_
nmap ca_ T_cf_
nmap da_ T_df_

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

let g:binary_words = {
\   "false": "true", "False": "True", "FALSE": "TRUE",
\   "0": "1", "f": "t", "F": "T",
\   "pickup": "delivery", "Pickup": "Delivery",
\   "&&": "||", "and": "or", "AND": "OR",
\   "yes": "no", "Yes": "No", "Y": "N", "YES": "NO",
\   "on": "off", "On": "Off", "ON": "OFF",
\   "!=": "==", "!==": "===", ">": "<", ">=": "<=", "!": "!!",
\}

let g:ternary_words = {
\   "map": "reduce",
\   "reduce": "filter",
\   "filter": "map",
\   "soup": "salad",
\   "salad": "sandwich",
\   "sandwich": "soup",
\   "Soup": "Salad",
\   "Salad": "Sandwich",
\   "Sandwich": "Soup",
\   "<$>": "<*>",
\   "<*>": ">>=",
\   ">>=": "<$>",
\   "xxs": "xs",
\   "xs": "sm",
\   "sm": "md",
\   "md": "lg",
\   "lg": "xl",
\   "xl": "xxl",
\   "xxl": "xxs",
\   "monday": "tuesday",
\   "tuesday": "wednesday",
\   "wednesday": "thursday",
\   "thursday": "friday",
\   "friday": "saturday",
\   "saturday": "sunday",
\   "sunday": "monday",
\   "Monday": "Tuesday",
\   "Tuesday": "Wednesday",
\   "Wednesday": "Thursday",
\   "Thursday": "Friday",
\   "Friday": "Saturday",
\   "Saturday": "Sunday",
\   "Sunday": "Monday",
\   "mon": "tues",
\   "tues": "wed",
\   "wed": "thurs",
\   "thurs": "fri",
\   "fri": "sat",
\   "sat": "sun",
\   "sun": "mon",
\   "Mon": "Tues",
\   "Tues": "Wed",
\   "Wed": "Thurs",
\   "Thurs": "Fri",
\   "Fri": "Sat",
\   "Sat": "Sun",
\   "Sun": "Mon",
\}

let g:haskell_binary_words = {
\   "==": "/=",
\}

for [k,v] in items(g:binary_words)
  let g:binary_words[v] = k
endfor

for [k,v] in items(g:haskell_binary_words)
  let g:haskell_binary_words[v] = k
endfor

let g:reversed_ternary_words = {}
for [k,v] in items(g:ternary_words)
  let g:reversed_ternary_words[v] = k
endfor

let g:toggle_words_forward = extend(g:ternary_words, g:binary_words)
let g:toggle_words_reverse = extend(g:reversed_ternary_words, g:binary_words)

function! ToggleBool(dir)
  let WORD = expand("<cWORD>")
  let word = expand("<cword>")

  if a:dir == 'r'
    let words = g:toggle_words_reverse
  else
    let words = g:toggle_words_forward
  endif

  if &ft == "haskell" || &ft == "tidal"
    let words = extend(words, g:haskell_binary_words)
  endif

  let opposite = 0
  if has_key(words, WORD)
    let opposite = words[WORD]
  elseif has_key(words, word)
    let opposite = words[word]
  else
    echo ""
    return
  endif

  execute "normal! ciw" . opposite
  if len(opposite) > 1
    execute "normal! b"
  endif
endfunction

nmap <silent> <leader>~ :<C-u>call ToggleBool('r')<CR>
nmap <silent> <leader>` :<C-u>call ToggleBool('f')<CR>

vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

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

" ≠ is alt =
" Output the current syntax group
nnoremap ≠ :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .  '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

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
" set ttymouse=






" this is just the default coc code from the readme



let g:coc_global_extensions = ['coc-solargraph']





" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>ca  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>oc  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>cj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>ck  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>cp  :<C-u>CocListResume<CR>)
