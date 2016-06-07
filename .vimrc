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

"Move vim-runtime-path if we're on windows. This helps me keep all my files in
"the same place.
if s:OS == "windows"
  exe 'set rtp+=' . expand('$HOME/.vim/after')
  exe 'set rtp+=' . expand('$HOME/.vim')
end

"Sanity options
syntax on
set backspace=2
set number
set ruler
set showmode
set showcmd
set guioptions=
set autoread
set autochdir

"Colorscheme
if has("gui")
  colorscheme gotham
"else
"  colorscheme apprentice
end

"Show trailing spaces
set listchars=trail:-
set list

"Filetype plugin
filetype plugin on
runtime macros/matchit.vim
set filetype+=plugin

"We must manually detect 'v' files, since verilog files also have a 'v'
"extension.
au BufRead,BufNewFile *.v   set filetype=v

"Search settings
set incsearch
set hlsearch

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

"Indent settings
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4

"Shortcut to commands I use frequently
nnoremap <leader>/ :set hls!<cr>
inoremap <leader>/ <C-o>:set hls!<cr>
xnoremap <leader>/ <esc>:set hls!<cr>gv

nnoremap <leader>= :retab<cr>
inoremap <leader>= <C-o>:retab<cr>
xnoremap <leader>= <esc>:retab<cr>gv

nnoremap <leader>b :Ebo<cr>
nnoremap <leader>o :browse old<cr>
nnoremap <leader><space> :%s/ \+$<cr>

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

xnoremap # :norm 0i<C-r>=Comment<CR><CR>
xnoremap & :norm ^<C-r>=len(Comment)<CR>x<CR>

"So that I don't have to hit esc
inoremap jk 
inoremap kj 

"So I can move around in insert
inoremap <C-k> gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> gj

"Make working with multiple buffers less of a pain
set splitright
set splitbelow
nnoremap v :vnew<cr>
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j

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

"Center view on the search result
nnoremap N Nzz
nnoremap n nzz

"Make vim behave (slightly more) like a traditional editor
inoremap  :w<cr>
nnoremap  :w<cr>
inoremap  u

set selectmode+=mouse
snoremap <C-v> "+y
snoremap <C-x> "+d

xnoremap <C-c> "+y

nnoremap <C-i> bi
nnoremap <C-I> Bi

"Black hole shortcut
nnoremap     "_d
xnoremap     "_d
inoremap     "_dd

"Fun macros:
"qqfca[0]lyT(f"r'la' || pa == 'f"r'jj0@qq

"Make visual selection more visible
hi visual term=reverse cterm=reverse guibg=darkGray

"ex commands
cnoreabbrev rc ~/.vimrc
cnoreabbrev et tabedit
cnoreabbrev bo browse old

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

"Execute a motion on the 'next' text object
"Thanks https://gist.github.com/AndrewRadev/1171559#file-next_motion_mapping-vim
onoremap an :<c-u>call <SID>NextTextObject('a')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i')<cr>

function! s:NextTextObject(motion)
  echo
  let c = nr2char(getchar())
  exe "normal! f".c."v".a:motion.c
endfunction
