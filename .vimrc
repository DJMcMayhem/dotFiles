"Detect OS
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

"Sanity options
syntax on
set backspace=2
set number
set ruler
set showmode
set showcmd

"Move vim-runtime-path if we're on windows. This helps me keep all my files in
"the same place.
if s:OS == "windows"
  exe 'set rtp+=' . expand('$HOME/.vim/after')
end

"Filetype plugin
filetype plugin on
set filetype+=plugin

"We must manually detect 'v' files, since verilog files also have a 'v'
"extension.
au BufRead,BufNewFile *.v   set filetype=v

"Search settings
set incsearch
set hlsearch
nnoremap <leader>/ :set hls!<cr>
inoremap <leader>/ <C-o>:set hls!<cr>
vnoremap <leader>/ <esc>:set hls!<cr>gv

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
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

"Indent setting
set autoindent
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4

"Fold settings
nnoremap <space> za

"Visual commenting
" 'Comment' is a variable that will be loaded from ftplugin, but if this is a new buffer, it won't have a filetype, so default it to '//'
let Comment='//'

vnoremap # :norm 0i<C-r>=Comment<CR><CR>
vnoremap & :norm ^<C-r>=len(Comment)<CR>x<CR>

"Train myself to use vim's already awesome indenting feature.
let @t=':echo "Use >, not @t!"'    
let @u=':echo "Use <, not @u!"'    

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
vnoremap <BS>    x

"Center view on the search result
nnoremap N Nzz
nnoremap n nzz

"Make vim behave like a traditional editor
inoremap  :w<cr>
nnoremap  :w<cr>
inoremap  u

set selectmode+=mouse
snoremap <C-v> "+y
snoremap <C-x> "+d

nnoremap <C-i> bi
nnoremap <C-I> Bi

"Black hole shortcut
nnoremap     "_d
vnoremap     "_d
inoremap     "_dd

"My favorite regexes:
"\<\d*\.\d*e-\d*                    "Matches all numbers in scientific notation
"%s/\v([a-z])([A-Z])/\1_\l\2/gc     "Replaces 'camelCase' with 'snake_case' Thanks @muru and @Peter Rincker: http://vi.stackexchange.com/a/7026/2920
"s/\( *\)\([a-z]\)\( *\)/\3\2\1/    "Moves the space on one side of a letter to the other side of that letter.
"s/ \([0-9]\|[A-F]\)/ 0x\1/g        "Replaces 00-FF with 0x00-0xFF
"s/^\(.*\)\(\n\1\)\+/\1             "removes all consecutive duplicates from the file.
"%s/\v( *\/\/.*)telnet/\1modbus/g   "Replaces 'telnet' with 'modbus' but only in comments.

"Fun macros:
"qqfca[0]lyT(f"r'la' || pa == 'f"r'jj0@qq

"Make visual selection more visible
hi visual term=reverse cterm=reverse guibg=darkGray

"ex commands
cnoreabbrev rc ~\.vimrc
cnoreabbrev et tabedit

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
