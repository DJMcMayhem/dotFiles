"Sanity options
syntax on
set backspace=2
set number
set ruler

"Rather than failing an ex command, ask for confirmation
set confirm
"In gvim, don't open a dialog box when asking for confirmation
set guioptions+=c

"Prevents '.swp' files from being placed in the current directory
set backupdir=~/.vimBackups,.
set directory=~/.vimBackups,.

"Indent setting
set autoindent
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4

"Fold settings
nnoremap <space> za

"For quick commenting and uncommenting
let @c='0i//j' 
let @d='^xxj'

"For quick indenting and unindenting
let @t='I    j'    
let @u='0xxxxj'

"removes all consecutive duplicates from the file, and then saves. Very useful since my SimMIndexer likes to write the same 'Hold' command thousands of times in a row.
let @h=':%s/^\(.*\)\(\n\1\)\+/\1' 

"So that I don't have to hit esc
inoremap jk    
inoremap kj 

"So I can move around in insert
inoremap <C-k> gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> gj

"Makes 'hjkl' work better with wrapped lines
nnoremap j gj
nnoremap gj j 
nnoremap k gk
nnoremap gk k 

"Make backspace delete in normal
nnoremap <BS>    <BS>x
vnoremap <BS>    x

"Center view on the search result
nnoremap N Nzz
nnoremap n nzz

inoremap  :w<cr>
nnoremap  :w<cr>
inoremap  u

nnoremap <C-i> bi
nnoremap <C-I> Bi
nnoremap <C-j> <Down>
nnoremap <C-j> <Down>
nnoremap <C-k> <Up>
nnoremap <C-h> <Left>
nnoremap <C-l> <Right>

"Black hole shortcut
nnoremap     "_d
vnoremap     "_d
inoremap     "_dd

"My favorite regexes:
"\<\d*\.\d*e-\d*                    "Matches all numbers in scientific notation
"%s/\v([a-z])([A-Z])/\1_\l\2/gc     "Replaces 'camelCase' with 'snake_case' Thanks @muru and @Peter Rincker: http://vi.stackexchange.com/a/7026/2920
"s/\( *\)\([a-z]\)\( *\)/\3\2\1/    "Moves the space on one side of a letter to the other side of that letter.
"s/ \([0-9]\|[A-F]\)/ 0x\1/g        "Replaces 00-FF with 0x00-0xFF

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
