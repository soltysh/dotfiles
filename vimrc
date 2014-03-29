" the next 3 lines must come first
filetype off
filetype plugin indent on
syntax on

" default file encoding to utf-8
set encoding=utf-8
set fileencoding=utf-8
" list of file encodings to be matched when opening
set fileencodings=utf-8,latin-2,latin-1

" use vim improvments over vi compatible mode
set nocompatible
" line numbers
set number
" tab size
set tabstop=4
set shiftwidth=4
" autoindent new lines
set autoindent
" insert newlines in C-like languages
set smartindent
" insert some amout of tabs
set smarttab
" show title
set title
" use spaces instead of tabs
set expandtab
" show search matches while typing
set incsearch
" ignore case in search
set ignorecase
" override ignorecase if search contains upper case
set smartcase
" no highlight search matches
set nohlsearch
" show matching brackets
set showmatch
" don't wrap lines
set nowrap
" no backup files
set nobackup
" confirm some actions
set confirm
" show cursor coordinates in bottom right
set ruler
" show current mode
set showmode
" show command character
set showcmd
" mark 80 column red
set colorcolumn=80
" mark current line
set cursorline
" mark nonprintable characters
set listchars=eol:$,tab:»·,
set list

" status line
set laststatus=2
" file contents list on right
let Tlist_Use_Right_Window=1
" list toggle on F8
nnoremap <silent> <F8> :TlistToggle<CR>

let g:EnhCommentifyMultiPartBlocks = 'yes'

" map t<move> for moving between tabs
"map tl :tabnext<CR>
"map th :tabprev<CR>
"map tn :tabnew<CR>
"map td :tabclose<CR>

" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=8

" What to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
" Python: 4 spaces
" C: tabs (pre-existing files) or 4 spaces (new files)
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
fu Select_c_style()
    if search('^\t', 'n', 150)
        set shiftwidth=8
        set noexpandtab
    el
        set shiftwidth=4
        set expandtab
    en
endf
au BufRead,BufNewFile *.c,*.h call Select_c_style()
au BufRead,BufNewFile Makefile* set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.rst match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
" Python: 79
" C: 79
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h set textwidth=79

" Turn off settings in 'formatoptions' relating to comment formatting.
" - c : do not automatically insert the comment leader when wrapping based on
"    'textwidth'
" - o : do not insert the comment leader when using 'o' or 'O' from command mode
" - r : do not insert the comment leader when hitting <Enter> in insert mode
" Python: not needed
" C: prevents insertion of '*' at the beginning of every line in a comment
au BufRead,BufNewFile *.c,*.h set formatoptions-=c formatoptions-=o formatoptions-=r

" Use UNIX (\n) line endings.
" Only used for new files so as to not force existing files to change their
" line endings.
" Python: yes
" C: yes
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

au BufRead,BufNewFile *.g,*.g4 set syntax=antlr
