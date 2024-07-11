" Lock screen to prevent editing of files
if has("unix")
  let s:uname = system("uname -s")
  if s:uname == "Darwin\n"
    let s:OS = "OSX"
  else
    let s:OS = "linux"
  endif
else
  let s:OS = "windows"
endif

" Did we open an empty vim? If so, change our working directory to 'HOME'
function! ChangeDirHome()
  if eval("@%") == ""
    cd $HOME
  endif
endfunction
autocmd VimEnter * call ChangeDirHome()

" Windows specific settings
if s:OS == "windows"
  " Move vim-runtime-path if we're on windows. This helps me keep all my files in
  " the same place.
  exe 'set rtp+=' . expand('$HOME/.vim/after')
  exe 'set rtp+=' . expand('$HOME/.vim')

  if has('nvim')
    set guifont="Lucida Console"
  else
    set guifont=Consolas:h11:cANSI:qDRAFT
  endif

  inoremap <C-s> <C-o>:w<cr>
  nnoremap <C-s> :w<cr>
endif

" Gui specific settings (TODO: test on linux!)
if has("gui_running")
  function! ToggleFullscreen()
    if &lines < 26 || &columns < 80
      " TODO: Check for linux version
      simalt ~x
    else
      set lines=25 columns=80
    endif
    redraw
  endfunction

  if !has('nvim')
    nnoremap <C-z> :call ToggleFullscreen()<cr><esc>
    inoremap <C-z> <C-o>:call ToggleFullscreen()<cr><esc>
  endif

  " Are we running vim-diff? If so, change gvim to fullscreen
  autocmd VimEnter * exec &diff ? "simalt ~x" : ""
endif

" Sanity options
syntax on
set encoding=utf-8
set fileencoding=utf-8
set backspace=2
set number
set ruler
set wildmenu
set showmode
set showcmd
set guioptions=
set autoread
set matchpairs+=<:>
set formatoptions-=t
set nohidden

set expandtab
set shiftwidth=4
set tabstop=4
set nosmartindent
set textwidth=120

set noerrorbells
set visualbell
set t_vb=

set nrformats-=octal

set laststatus=2

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{getcwd()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\


autocmd GUIEnter * set t_vb=

" Plugins
" if exists('g:loaded_plug') == 1 &&
if exists('g:vsvim') == 0 && exists('nvim') == 0
  call plug#begin()

  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  " Plug 'tpope/vim-endwise'
  " Currently has a lua error
  Plug 'tpope/vim-speeddating'
  Plug 'mattn/gist-vim'
  Plug 'mattn/webapi-vim'
  Plug 'tommcdo/vim-exchange'
  Plug 'wellle/targets.vim'
  Plug 'wellle/context.vim'
  Plug 'matze/vim-move'
  Plug 'ararslan/license-to-vim'
  Plug 'vim-utils/vim-husk'
  Plug 'nessss/vim-gml'
  Plug 'artnez/vim-wipeout'

  Plug 'sheerun/vim-polyglot'
  Plug 'peterhoeg/vim-qml'

  " The most beautiful colorscheme I have ever seen. This is truly a work of
  " art. Angels weep the tears of a thousand virgins everytime a new vimmer
  " finds this <s>colorscheme</s> work of art.
  Plug 'KeyboardFire/hotdog.vim'

  Plug 'scrooloose/nerdtree'
  " Show hidden files in NERDTree
  let NERDTreeShowHidden=1
  let NERDTreeIgnore = ['\.pyc$', '\.dll$', '\.qmlc$', '\.jsc$']

  Plug 'flazz/vim-colorschemes'
  let g:loaded_colorschemes = 1

  Plug 'kshenoy/vim-signature'

  Plug 'ntpeters/vim-better-whitespace'
  hi link pythonSpaceError NONE

  Plug 'haya14busa/incsearch.vim'
  set hlsearch
  let g:incsearch#auto_nohlsearch = 1
  map n  <Plug>(incsearch-nohl-n)zz
  map N  <Plug>(incsearch-nohl-N)zz
  map *  <Plug>(incsearch-nohl-*)zz
  map #  <Plug>(incsearch-nohl-#)zz
  map g* <Plug>(incsearch-nohl-g*)zz
  map g# <Plug>(incsearch-nohl-g#)zz

  map / <Plug>(incsearch-forward)\v
  map ? <Plug>(incsearch-backward)\v
  map g/ <Plug>(incsearch-stay)\v

  Plug 'habamax/vim-godot'

  if has('nvim')
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'prabirshrestha/vim-lsp'
  endif

  call plug#end()
else
  " For whatever reason, vim-plug isn't installed.
  " Load some basic settings.
  set hlsearch
  set incsearch
  nnoremap n nzz
  nnoremap N Nzz
  let g:loaded_colorschemes = 0
endif

set ignorecase
set smartcase

if has("gui_running") && g:loaded_colorschemes
  colorscheme badwolf
elseif s:OS == "linux"
  " Compensate for Window's abysmally shitty terminal
  colorscheme gotham256
end

" Turn the mouse on, but don't move the cursor when refocusing
if has('timers')
  set mouse=a

  augroup MouseHack
    autocmd!
    autocmd FocusLost * set mouse=
    autocmd FocusGained * call timer_start(50, 'ReenableMouse')
  augroup END

  function! ReenableMouse(timer_id)
    set mouse=a
  endfunction
else
  set mouse=
endif

" Highlight search matches with an underscore (this is nice because it keeps
" the matched text very readable still)
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline

" Filetype plugin
filetype plugin on
runtime macros/matchit.vim

" Rather than failing a command!, ask for confirmation
set confirm

" In gvim, don't open a dialog box when asking for confirmation
set guioptions+=c

" Prevents '.swp' files from being placed in the current directory
set backupdir=~/.vim/Backups,.
set directory=~/.vim/Backups,.

" Set cursor shape (xterm on Linux only)
if s:OS == "linux"
  let &t_SI = "\<Esc>[6 q"
  let &t_EI = "\<Esc>[2 q"
endif


" Set leader to space
let mapleader=" "

if has('nvim')
  nnoremap Y yy
endif

nnoremap <F5> :silent! wall \| :vsplit \| terminal! python.exe main.py<cr>
nnoremap <F6> :silent! wall \| :vsplit \| terminal! python.exe %<cr>

" Shortcut to command!s I use frequently
nnoremap <leader>/ :set hls!<cr>
nnoremap <leader>= :retab<cr>

" Save and source
nnoremap <leader>s :w \| source %<cr>

" Toggle 'spell'
nnoremap <leader>S :setlocal spell!<cr>

" Mnemonic '(B)rowse'
nnoremap <leader>b :Ebo<cr>
nnoremap <leader>o :browse old<cr>
nnoremap <leader>O :browse oldfiles<C-left>filter // <left><left>

nnoremap <expr> <leader>d (&diff ? ":diffoff<cr>" : ":diffthis<cr>")

" Mnemonic '(C)hange directory
nnoremap <leader>c :chdir %:p:h<cr>:pwd<cr>

" Useful for code-golf explanations
nnoremap <leader>j m`Yp<C-o>v$hhr jhv0r ^
nnoremap <leader>J m`Yp<C-o>v$r jhv0r ^

" Faster buffer switchingt
nnoremap <leader>l :ls<cr>:b<space>

" Faster clipboard copying/pasting
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
xnoremap <leader>y "+y
xnoremap <leader>Y "+Y

" Paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>p "+p
xnoremap <leader>P "+P

" Use <expr> so that leading space isn't highlighted :P
nnoremap <expr> <leader>t ":tabedit "
nnoremap <leader>T :NERDTree \| normal B<cr>

nnoremap <leader>q :q<cr>
xnoremap <leader>q :<C-u>q<cr>

" See help options faster
nnoremap <leader>k yi':se <C-r>"?<cr>

" Eval
nnoremap <leader>e ^C<C-r>=<C-r>"<cr><esc>
xnoremap <leader>e s<C-r>=<C-r>"<cr>

" (R)eplace all
nnoremap <leader>r yiw:%s/\<<C-r>"\>//g<left><left>

" Git mappings
nnoremap <leader>gc :w \| !git commit %<cr>
nnoremap <leader>gd :!git diff<cr>
nnoremap <leader>gp :!git push<cr>
nnoremap <leader>gP :!git pull<cr>

" Search for non-ASCII
nnoremap <leader>a /\v[^\x00-\x7f]<cr>

" Fold settings
nnoremap <leader>f za
nnoremap <expr> <leader>F ":e ".expand('%:p')

nnoremap <leader>n :cnext<cr>:call histdel('cnext', 1)<cr>
nnoremap <leader>N :cprev<cr>:call histdel('cnext', 1)<cr>

" A useful map for decoding V-weirdness
nnoremap <leader>ga yl:echo nr2char(char2nr(getreg('"')) % 128)<cr>

" Select entire line (minus EOL) with 'vv', entire file (characterwise) with 'VV'
xnoremap <expr> V mode() ==# "V" ? "gg0voG$h" : "V"
xnoremap <expr> v mode() ==# "v" ? "0o$h" : "v"

" Make it easier to indent a visual selection several times.
xnoremap > >gv
xnoremap < <gv

" Visual commenting
" 'Comment' is a variable that will be loaded from ftplugin, but if this is a
" new buffer, it won't have a filetype, so default it to '#'
let Comment='#'

"For quick commenting and uncommenting
let @c="0i\<C-r>=g:Comment\<cr>\<esc>gjzz"
let @d=":\<C-u>exec 'norm ^'.strlen(g:Comment).'x'\<cr>gjzz"

xnoremap # :norm 0i<C-r>=Comment<cr><cr>
xnoremap & :norm ^<C-r>=len(Comment)<cr>x<cr>

" So that I don't have to hit esc
inoremap jk <esc>
inoremap kj <esc>

" So I can move around in insert
inoremap <C-k> <C-o>gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <C-o>gj

inoremap <S-Tab> <C-o><<

" Make working with multiple buffers less of a pain
set splitright
set splitbelow
nnoremap <C-w>v :vnew<cr>
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j

" Automagically resize splits when the host is resized
autocmd VimResized * wincmd =

" Wrap options
set nowrap
set nowrapscan
set linebreak
set display+=lastline

" Make basic movements work better with wrapped lines
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" Make backspace delete in normal
nnoremap <BS>    <BS>x
xnoremap <BS>    x

inoremap <C-BS> <C-w>

" Get rid of pesky "ex mode"
nnoremap Q <nop>

" Make re-running macros more convenient (especially useful in vsvim)
nnoremap , @@zz

" Make vim behave (slightly more) like a traditional editor
snoremap <C-v> <C-o>"+y
snoremap <C-x> <C-o>"+d

xnoremap <C-c> "+y

" Black hole shortcut
nnoremap <C-d> "_d
xnoremap <C-d> "_d

" Make visual selection more visible
hi visual term=reverse cterm=reverse guibg=darkGray

" ex command!s
cnoreabbrev rc ~/.vimrc
cnoreabbrev et tabedit
cnoreabbrev bo browse old

function! s:TabBrowseOld()
  tabedit
  browse old
endfunction
com! Ebo call s:TabBrowseOld()
cnoreabbrev ebo Ebo

" Scripts
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function! BuffersList()
  let all = range(0, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction

