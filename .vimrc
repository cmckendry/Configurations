let os=substitute(system('uname'), '\n', '', '')
" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
"set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
"set encoding=utf-8 nobomb
" Change mapleader
"let mapleader=","
" Don’t add empty newlines at the end of files
"set binary
"set noeol
" Centralize backups, swapfiles and undo history

if os == 'Darwin' || os == 'Mac'
  set backupdir=/Users/carter/.vim/backups
  set directory=/Users/carter/.vim/swaps
  call pathogen#incubate('/Users/carter/.vim/bundle/{}')
else
  set backupdir=/home/carter/.vim/backups
  set directory=/home/carter/.vim/swaps
  set runtimepath+=/home/carter/.vim
  call pathogen#incubate('/home/carter/.vim/bundle/{}')
endif
" PATH O GEN
execute pathogen#infect()
"if exists("&undodir")
"  set undodir=/home/carter/.vim/undo
"endif

" Respect modeline in files
"set modeline
"set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
"set exrc
"set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=2
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
"set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
"set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
"if exists("&relativenumber")
"  set relativenumber
"  au BufReadPost * set relativenumber
"endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Convert tabs into spaces
function! CleanUpTabs()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\t/  /
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap Ç :call CleanUpTabs()<CR>

" Save a file as root (,W)
noremap <buffer> <S-w> :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
  " Enable file type detection
  filetype on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
endif

" Run as python and show results (Shift-P)
noremap <buffer> <S-p> :w<CR>:!/usr/bin/env python % <CR>
let g:neocomplcache_enable_at_startup = 1

" Use tab key as escape to switch modes
nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc>gV
onoremap <Tab> <Esc>
inoremap <Tab> <Esc>`^
inoremap <Leader><Tab> <Tab>
imap <tab> <esc>

" Make crontab actually work
if $VIM_CRONTAB == 'true'
  set nobackup
  set nowritebackup
endif

" Syntastic
let g:syntastic_python_checkers=['pylint']
let g:syntastic_puppet_checkers=['puppet','puppetlint']
" let g:syntastic_puppet_puppetlint_args=[' --no-autoloader_layout-check ']
