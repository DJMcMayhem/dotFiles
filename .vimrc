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

"Did we open an empty vim? If so, change our working directory to 'HOME'
function! ChangeDirHome()
  if eval("@%") == ""
    cd $HOME
  endif
endfunction
autocmd VimEnter * call ChangeDirHome()

"Windows specific settings
if s:OS == "windows"
  "Move vim-runtime-path if we're on windows. This helps me keep all my files in
  "the same place.
  exe 'set rtp+=' . expand('$HOME/.vim/after')
  exe 'set rtp+=' . expand('$HOME/.vim')

  inoremap <C-s> <C-o>:w<cr>
  nnoremap <C-s> :w<cr>
endif

"Gui specific settings (TODO: test on linux!)
if has("gui_running")
  function! ToggleFullscreen()
    if &lines < 26 || &columns < 80
      "TODO: Check for linux version
      simalt ~x
    else
      set lines=25 columns=80
    endif
    redraw
  endfunction
  nnoremap <C-z> :call ToggleFullscreen()<cr><esc>
  inoremap <C-z> <C-o>:call ToggleFullscreen()<cr><esc>

  "Are we running vim-diff? If so, change gvim to fullscreen
  autocmd VimEnter * exec &diff ? "simalt ~x" : ""
endif

"Sanity options
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
set autochdir
set matchpairs+=<:>

set noerrorbells
set visualbell
set t_vb=

set nrformats-=octal

autocmd GUIEnter * set t_vb=

"Plugins
"if exists('g:loaded_plug')
if exists('g:vsvim') == 0 && exists('nvim') == 0
  call plug#begin()

  command! PU PlugUpgrade | PlugInstall | PlugClean | PlugUpdate | q
  command! PI PlugInstall | q
  command! PC PlugClean | q

  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-speeddating'
  Plug 'mattn/gist-vim'
  Plug 'mattn/webapi-vim'
  Plug 'tommcdo/vim-exchange'
  Plug 'wellle/targets.vim'
  Plug 'matze/vim-move'
  Plug 'ararslan/license-to-vim'
  Plug 'vim-utils/vim-husk'
  Plug 'nessss/vim-gml'
  Plug 'scrooloose/nerdtree'
  Plug 'artnez/vim-wipeout'
  Plug 'JuliaEditorSupport/julia-vim'

  "The most beautiful colorscheme I have ever seen. This is truly a work of
  "art. Angels weep the tears of a thousand virgins everytime a new vimmer
  "finds this <s>colorscheme</s> work of art.
  Plug 'KeyboardFire/hotdog.vim'

  Plug 'flazz/vim-colorschemes'
  let g:loaded_colorschemes = 1

  Plug 'kshenoy/vim-signature'

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

  "Plugins I don't want anymore
  "Plug 'DJMcMayhem/vim-characterize'
  "Plug 'ntpeters/vim-better-whitespace'


  call plug#end()
else
  "For whatever reason, vim-plug isn't installed.
  "Load some basic settings.
  set hlsearch
  set incsearch
  nnoremap n nzz
  nnoremap N Nzz
endif

set ignorecase
set smartcase

if has("gui_running") && g:loaded_colorschemes
  colorscheme badwolf
elseif s:OS == "linux"
  " Compensate for Window's abysmally shitty terminal
  colorscheme gotham256
end

"Highlight search matches with an underscore (this is nice because it keeps
"the matched text very readable still)
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline

"Filetype plugin
filetype plugin on
runtime macros/matchit.vim

"We must manually detect 'v' files, since verilog files also have a 'v'
"extension.
au BufRead,BufNewFile *.v   set filetype=v

autocmd BufEnter,FileType * :if &filetype == '' | set spell | endif
autocmd BufEnter,FileType * :if &filetype != '' | set nospell | endif

"Rather than failing a command!, ask for confirmation
set confirm

"In gvim, don't open a dialog box when asking for confirmation
set guioptions+=c

"Prevents '.swp' files from being placed in the current directory
set backupdir=~/.vim/Backups,.
set directory=~/.vim/Backups,.

"Set cursor shape (xterm on Linux only)
if s:OS == "linux"
  let &t_SI = "\<Esc>[6 q"
  let &t_EI = "\<Esc>[2 q"
endif

"Set leader to space
let mapleader=" "

"Shortcut to command!s I use frequently
nnoremap <leader>/ :set hls!<cr>
nnoremap <leader>= :retab<cr>

"Save and source
nnoremap <leader>s :w \| source %<cr>

"Toggle 'spell'
nnoremap <leader>S :setlocal spell!<cr>

"Mnemonic '(B)rowse'
nnoremap <leader>b :Ebo<cr>
nnoremap <leader>o :browse old<cr>
nnoremap <leader>O :browse oldfiles<C-left>filter // <left><left>

"Useful for code-golf explanations
nnoremap <leader>j m`Yp<C-o>v$hhr jhv0r ^
nnoremap <leader>J m`Yp<C-o>v$r jhv0r ^

"Duplicate up/down
"Granted, kindof a silly mapping, but why not ¯\_(ツ)_/¯?
nnoremap <leader>dk m`YPVr <C-o>y$kP
nnoremap <leader>dj m`YpVr <C-o>y$jP

"Faster buffer switchingt
nnoremap <leader>l :ls<cr>:b<space>

"Faster clipboard copying/pasting
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
xnoremap <leader>y "+y
xnoremap <leader>Y "+Y

"Paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>p "+p
xnoremap <leader>P "+P

nnoremap <leader>t :tabedit<space>

nnoremap <leader>q :q<cr>
xnoremap <leader>q :<C-u>q<cr>

"See help options faster
nnoremap <leader>k yi':se <C-r>"?<cr>

"(E)xpand (convert a function template into a function definition)
nnoremap <leader>e :s/;$/\r{\r    \r}\r<cr>
xnoremap <leader>e :s/;$/\r{\r    \r}\r<cr>

"(R)eplace all
nnoremap <leader>r yiw:%s/\<<C-r>"\>//g<left><left>

"Git mappings
nnoremap <leader>gc :w \| !git commit %<cr>
nnoremap <leader>gd :!git diff<cr>
nnoremap <leader>gp :!git push<cr>
nnoremap <leader>gP :!git pull<cr>

"Search for non-ASCII
nnoremap <leader>a /\v[^\x00-\x7f]<cr>

"Fold settings
nnoremap <leader>f za
nnoremap <leader>F [[za

nnoremap <leader>n :cnext<cr>:call histdel('cnext', 1)<cr>
nnoremap <leader>N :cprev<cr>:call histdel('cnext', 1)<cr>

"A useful map for decoding V-weirdness
nnoremap <leader>ga yl:echo nr2char(char2nr(getreg('"')) % 128)<cr>


"Select entire line (minus EOL) with 'vv', entire file (characterwise) with 'VV'
xnoremap <expr> V mode() ==# "V" ? "gg0voG$h" : "V"
xnoremap <expr> v mode() ==# "v" ? "0o$h" : "v"

"Train myself to use vim's already awesome indenting feature.
let @t=':echo "Use >, not @t!"'
let @u=':echo "Use <, not @u!"'

"Make it easier to indent a visual selection several times.
xnoremap > >gv
xnoremap < <gv

"Visual commenting
" 'Comment' is a variable that will be loaded from ftplugin, but if this is a
" new buffer, it won't have a filetype, so default it to '#'
let Comment='#'

xnoremap # :norm 0i<C-r>=Comment<cr><cr>
xnoremap & :norm ^<C-r>=len(Comment)<cr>x<cr>

"So that I don't have to hit esc
inoremap jk 
inoremap kj 

"So I can move around in insert
inoremap <C-k> <C-o>gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <C-o>gj

"Make working with multiple buffers less of a pain
set splitright
set splitbelow
nnoremap <C-w>v :vnew<cr>
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j

"Automagically resize splits when the host is resized
autocmd VimResized * wincmd =

"Wrap options
set wrap
set linebreak
set display+=lastline

"Make basic movements work better with wrapped lines
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

"Make backspace delete in normal
nnoremap <BS>    <BS>x
xnoremap <BS>    x

inoremap <C-BS> <C-w>

"Get rid of pesky "ex mode"
nnoremap Q <nop>

"Make re-running macros more convenient (especially useful in vsvim)
nnoremap , @@

"Make vim behave (slightly more) like a traditional editor
set selectmode+=mouse
snoremap <C-v> <C-o>"+y
snoremap <C-x> <C-o>"+d

xnoremap <C-c> "+y

"Black hole shortcut
nnoremap <C-d> "_d
xnoremap <C-d> "_d

"Fun macros:
"qqfca[0]lyT(f"r'la' || pa == 'f"r'jj0@qq

"Make visual selection more visible
hi visual term=reverse cterm=reverse guibg=darkGray

"ex command!s
cnoreabbrev rc ~/.vimrc
cnoreabbrev et tabedit
cnoreabbrev bo browse old
cnoreabbrev cs colorscheme

function! s:TabMode()
  let g:IndentMode = "Tabs"
  set noexpandtab
  exec "set listchars+=tab:\\ \\ "

endfunction

function! s:SpaceMode()
  let g:IndentMode = "Spaces"
  set autoindent
  set expandtab
  set tabstop=4
  set shiftwidth=4

  exec "set listchars-=tab:\\ \\ "
endfunction

call s:SpaceMode()

com! Spaces call s:SpaceMode()
com! Tabs call s:TabMode()
nnoremap <leader>i :echo g:IndentMode<CR>

function! s:TabBrowseOld()
  tabedit
  browse old
endfunction
com! Ebo call s:TabBrowseOld()
cnoreabbrev ebo Ebo

"Scripts
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

function! GrepBuffers (expression)
  exec 'vimgrep/'.a:expression.'/ '.join(BuffersList())
endfunction

command! -nargs=+ GrepBufs call GrepBuffers(<q-args>)

cnoreabbrev GB GrepBufs


