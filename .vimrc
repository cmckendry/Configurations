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
set encoding=utf-8 nobomb
" Change mapleader
"let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol

" Centralize backups, swapfiles and undo history
" even when running under sudo
if strlen($SUDO_USER)
  let realuser    = $SUDO_USER
else
  let realuser    = $USER
endif

let userhomedir  = substitute(system('echo ~' . realuser), '\n', '', '')
let &backupdir   = userhomedir . '/.vim/backups'
if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
endif
let &directory   = userhomedir . '/.vim/swaps'
if !isdirectory(&directory)
  call mkdir(&directory, "p")
endif
let &undodir     = userhomedir . '/.vim/undo'
if !isdirectory(&undodir)
  call mkdir(&undodir, "p")
endif
let &runtimepath = userhomedir . '/.vim,' . &runtimepath . ',' . userhomedir . '/.vim/after'
call pathogen#incubate(userhomedir . "/.vim/bundle/{}")

" Set os and user-appropriate directory for custom syntax definitions
let syntaxdir = userhomedir . '/.vim/syntax/'

" PATH O GEN
execute pathogen#infect()

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
" Use spaces for tabs, damn it
set expandtab
" Indent automatically
set smartindent
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
set laststatus=2
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

" Hit option-D to duplicate the current line
noremap ∂ "zyy"zp
noremap d "zyy"zp

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
  :%s/\t/  /e
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

" Hit option-shift-C to clean up the buffer
" turns tabs into spaces and removes trailing white space
noremap <silent> Ç :call CleanUpTabs()<CR>
noremap <silent> C :call CleanUpTabs()<CR>

" Save a file as root (,W)
noremap <buffer> <S-w> :w !sudo tee % > /dev/null<CR>

" Take off and nuke the buffer from orbit
" (It's the only way to be sure)...
nmap <Leader>x 1GdG

" Intelligent newline
function! FancyNewLine()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  let magicline = line('.')-1
  echom magicline
  let searchlead = '/\%'
  execute 'silent normal! ' . searchlead . magicline . "l['\"#]" . "\r"
  let horizalign = col('.')
  let qchar = getline('.')[col('.')-1]
  call setpos('.', save_cursor)
  let @j = qchar
  normal k$"jpj^"jP
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

noremap <Leader> i:call FancyNewLine()<CR>i

" Per-filetype commands

" Automatic commands
if has("autocmd")
  " Enable file type detection
  filetype on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Give a visual indicator of the PEP8 line-length guideline
  autocmd BufNewFile,BufRead *.py match OverLength /\%81v.\+/
endif

au FileType puppet setlocal shiftwidth=2

" Run as python and show results (Shift-P)
noremap <buffer> <Leader>p :w<CR>:!/usr/bin/env python % <CR>
" Run as ruby and show results (Option-R)
noremap <buffer>  :w<CR>:!/usr/bin/env ruby % <CR>
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
let g:syntastic_python_checkers        = ['pylint']
let g:syntastic_python_pylint_args     = '--indent-string="    " --max-line-length=800 --disable=missing-docstring,superfluous-parens --msg-template="{path}:{line}: [{msg_id}] {msg}"'
let g:syntastic_puppet_checkers        = ['puppet','puppetlint']
let g:syntastic_puppet_puppetlint_args = '--no-80chars-check --no-documentation-check --no-autoloader_layout-check'
let g:syntastic_javascript_checkers    = ['eslint']
let g:syntastic_javascript_eslint_exec = '/usr/local/bin/eslint'
let g:syntastic_javascript_eslint_args = '-c ~carter/.eslintrc.js'
let g:syntastic_check_on_open = 1

" Folding
set foldmethod=indent
set foldcolumn=3
set foldlevelstart=99
setlocal shiftwidth=4
highlight Folded ctermfg=DarkGreen ctermbg=Black
nnoremap <space> za
vnoremap <space> zf

" YouCompleteMe
let g:ycm_key_list_select_completion                = ['<S-TAB>', 'Enter', '<Down>']
let g:ycm_key_list_previous_completion              = ['<Up>']
let g:ycm_autoclose_preview_window_after_completion = 1

" Sometimes relative line numbers are useful
function! NumberToggle()
  if(&relativenumber == 1)
    set relativenumber!
    set number
  else
    set number!
    set relativenumber
  endif
endfunc

nnoremap ˜ :call NumberToggle()<cr>
nnoremap N :call NumberToggle()<cr>

" Inserting useful, dynamic filler text
nnoremap Ò :r !curl -s http://loripsum.net/api/plaintext/prude<cr>
nnoremap L :r !curl -s http://loripsum.net/api/plaintext/prude<cr>

let g:EasyMotion_leader_key = '<S-e>'

" Maybe
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute( expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" Make gitgutter calm down
let g:gitgutter_realtime = 0
let g:gitgutter_eager    = 0

" Use UltiSnips but make it leave Tab alone
let g:UltiSnipsSnippetDirectories = [ "UltiSnips" ]
let g:UltiSnipsSnippetsDir        = '~/.vim/snippets/'
let g:UltiSnipsExpandTrigger      = "≈"

" Airline
let g:airline_powerline_fonts = 0
let g:airline_symbols         = {}
" unicode symbols
let g:airline_left_sep           = '▶'
let g:airline_right_sep          = '◀'
let g:airline_symbols.linenr     = 'Þ'
let g:airline_symbols.branch     = '⎇'
let g:airline_symbols.paste      = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
function! AirlineInit()
  let g:airline_section_y = airline#section#create(['ffenc', '%{strftime("%H:%M:%S")}'])
endfunction
autocmd VimEnter * call AirlineInit()

" Lines that are too long get colored red
highlight OverLength ctermbg = red ctermfg = white guibg = #592929

" Don't use arrow keys
noremap OA <Nop>
noremap <Up> <Nop>
noremap OB <Nop>
noremap <Left> <Nop>
noremap OC <Nop>
noremap <Down> <Nop>
noremap OD <Nop>
noremap <Right> <Nop>

" VCL highlighting
au BufRead,BufNewFile *.vcl :set ft=vcl
exec 'au! Syntax vcl source '.syntaxdir . 'vcl.vim'

