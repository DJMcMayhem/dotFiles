"Detect O
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

"Move vim-runtime-path if we're on windows. This helps me keep all my files in
"the same place.
if s:OS == "windows"
  exe 'set rtp+=' . expand('$HOME/.vim/after')
  exe 'set rtp+=' . expand('$HOME/.vim')
end

"Sanity options
syntax on
set encoding=utf-8
set fileencoding=utf-8
set backspace=2
set number
set ruler
set showmode
set showcmd
set guioptions=
set autoread
set autochdir
set noerrorbells
set visualbell
set t_vb=

autocmd GUIEnter * set t_vb=

"Plugins
"if exists('g:loaded_plug')
if exists('g:vsvim') == 0 && exists('nvim') == 0
  call plug#begin()

  command PU PlugUpgrade | PlugInstall | PlugClean | PlugUpdate | q
  command PI PlugInstall | q
  command PC PlugClean | q

  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-speeddating'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'mattn/gist-vim'
  Plug 'tommcdo/vim-exchange'
  Plug 'wellle/targets.vim'
  Plug 'matze/vim-move'
  Plug 'ararslan/license-to-vim'

  Plug 'flazz/vim-colorschemes'
  let g:loaded_colorschemes = 1

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

  call plug#end()
else
  "For whatever reason, vim-plug isn't installed.
  "Load some basic settings.
  set hlsearch
  set incsearch
  nnoremap n nzz
  nnoremap N Nzz
endif

if has("gui_running") && g:loaded_colorschemes
  colorscheme gotham
else
  colorscheme candycode
end

hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline

"Filetype plugin
filetype plugin on
runtime macros/matchit.vim
set filetype+=plugin

"We must manually detect 'v' files, since verilog files also have a 'v'
"extension.
au BufRead,BufNewFile *.v   set filetype=v

"Rather than failing a command, ask for confirmation
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

"Shortcut to commands I use frequently
nnoremap <leader>/ :set hls!<cr>
nnoremap <leader>= :retab<cr>

"Mnemonic '(S)trip trailing spaces'
nnoremap <leader>s :%s/\s\+$<cr>

"Mnemonic '(D)os to unix'
nnoremap <leader>d :%s/<C-v><cr>$<cr>

"Mnemonic '(B)rowse'
nnoremap <leader>b :Ebo<cr>
nnoremap <leader>o :browse old<cr>

"Select everything with 'vv'
xnoremap v ggoG$

"Train myself to use vim's already awesome indenting feature.
let @t=':echo "Use >, not @t!"'
let @u=':echo "Use <, not @u!"'

"Make it easier to indent a visual selection several times.
xnoremap > >gv
xnoremap < <gv

"Fold settings
nnoremap <space> za

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
nnoremap $ g$
nnoremap g$ $
nnoremap 0 g0
nnoremap g0 0

"Make backspace delete in normal
nnoremap <BS>    <BS>x
xnoremap <BS>    x

""Center view on the search result
"nnoremap N Nzz
"nnoremap n nzz

"Make vim behave (slightly more) like a traditional editor
inoremap <C-s> <C-o>:w<cr>
nnoremap <C-s> :w<cr>
inoremap <C-z> <C-o>u

set selectmode+=mouse
snoremap <C-v> <C-o>"+y
snoremap <C-x> <C-o>"+d

xnoremap <C-c> "+y

nnoremap <C-i> bi
nnoremap <C-I> Bi

"Black hole shortcut
nnoremap <C-d> "_d
xnoremap <C-d> "_d
inoremap <C-d> <C-o>"_dd

"Fun macros:
"qqfca[0]lyT(f"r'la' || pa == 'f"r'jj0@qq

"Make visual selection more visible
hi visual term=reverse cterm=reverse guibg=darkGray

"ex commands
cnoreabbrev rc ~/.vimrc
cnoreabbrev et tabedit
cnoreabbrev bo browse old
cnoreabbrev cs colorscheme

function! s:TabMode()
  let g:IndentMode = "Tabs"
  set noexpandtab
  exec "set listchars+=tab:\\ \\ "

  inoremap <C-BS> <BS>
  nnoremap <C-BS> <BS>
endfunction

function! s:SpaceMode()
  let g:IndentMode = "Spaces"
  set autoindent
  set expandtab
  set tabstop=4
  set shiftwidth=4

  inoremap <expr> <C-BS> repeat("\<Left>", &tabstop)."\<C-o>".&tabstop."x"
  nnoremap <expr> <C-BS> repeat("\<Left>", &tabstop).&tabstop."x"

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
