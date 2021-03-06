" John's Personal VIM settings
" Maintainer: John Weathers <jweathers@gmail.com>

" Activate pathogen
execute pathogen#infect()
execute pathogen#infect('bundle.remote/{}')
execute pathogen#helptags()

"We don't want the vi-compatible version
set nocompatible

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Show matching parentheses
set showmatch

" Make backspace key normal
set bs=2

" Highlight the current line
set cursorline

" We want to wrap long lines but we want
" to show them intelligently
set wrap
set cpoptions+=n
set linebreak
set showbreak=\ ↵\ \

" tab stop and shift width settings
set tabstop=3
set shiftwidth=3
set smarttab

" Don't litter the place with swap files
set directory=~/tmp,/var/tmp,/tmp

" Fine-tune the C/C++/Java indentation options
set cinoptions=:0,g0,(0,j1,p0,t0

" Turn off the annoying bell sounds
set vb t_vb=

set iskeyword+=-

" Eliminate pauses
set timeoutlen=1000 ttimeoutlen=0

" Force myself to use the right motion keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Toggle paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Expand tabs to spaces
set expandtab

set number
set history=50 "Keep 50 lines of command line history
set ruler      "Show the cursor position all the time
set showcmd    "Display incomplete commands

set ic         "Ignore the case in searches
set smartcase  "Override the ignore case for mixed patterns

" We don't want to clutter up things with backup files
set nobackup

" We want the xterm way of doing things instead of M$ Windows
behave xterm

" It's nice to be able to use the mouse in the Terminal
set mouse=a

" It's nice to be able to select with the mouse
set selectmode=mouse

" Which directory to use for the file browser
set browsedir=current

" Don't use Ex mode, use Q for formatting
map Q gq

" Easier than pressing ESC
inoremap jj <ESC>

let mapleader = ","

" Auto completion
set complete+=k

" Turn off folding
set nofoldenable

" XML Plugin settings
let xml_use_xhtml=1

" VIM-Slime settings
let g:slime_target="tmux"
let g:slime_paste_file = tempname()

" Shortcut to rapidly toggel `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Settings for haskell
let g:ghc="/usr/local/bin/ghc"
let g:haddock_browser="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

map <leader>r :NERDTreeFind<CR>

" Search via ack on the current word
map <leader>* :Ack <cword><CR>

"Shortcut for searching with ack
map <leader>a :Ack ""<Left>

" NERD Tree
map <leader>d :NERDTreeToggle<cr>
let NERDTreeIgnore=['\~$','^target$','\.hi','\.o']
let NERDTreeDirArrows=1

" Map shortcut for ZoomWin
map <leader>z :ZoomWin<CR>

" Map shortcut for ConqueTerm
map <leader>e :ConqueTerm zsh<CR>
let g:ConqueTerm_SendVisKey='<F3>'

" Map shortcuts for ctags commands
map <leader>rt :!ctags --extra=+f -R *<CR><CR>
map <leader>g :Tlist<CR>

" Gundo
map <leader>u :GundoToggle<CR>

map <leader>lcd :lcd %:p:h<CR>

map <leader>cp :let @+ = expand("%:p")<cr>

" Mapping for edit/reloading vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  "let g:ackprg = 'ag --nocolor --nogroup --column --ignore=*min.js --ignore=*min.css --ignore=public'
  let g:ackprg = 'ag --nocolor --nogroup --column'

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor --ignore=*min.js --ignore=*min.css --ignore=public  -g ""'
  let g:ctrlp_user_command = 'ag %s -l -g ""'
endif

set grepformat=%f:%l:%m

" Enable fzf
set rtp+=/usr/local/opt/fzf
map <leader>t :FZF<CR>

" Control-P mapping
"map <leader>t :CtrlP<CR>
map <leader>b :CtrlPBuffer<CR>
map <leader>m :CtrlPMRU<CR>
map <leader>k :CtrlPClearCache<CR>
map <leader>. :CtrlPTag<CR>

" Disable some buffer gator keys
let g:buffergator_suppress_keymaps=1
map <leader>f :BuffergatorOpen<CR>
map <leader>F :BuffergatorClose<CR>

" Disable default mappings for scratch
let g:scratch_no_mappings = 1

let g:ctrlp_max_files=0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore={
   \ 'file': '\v(\.class|\.log)$',
   \ 'rep': '\v[\/]\.(git|hg|svn)$',
   \ 'dir': '\v[\/](tmp|coverage|data|log)$',
   \ }

if executable('matcher')
   let g:ctrlp_match_func = { 'match': 'GoodMatch' }

   function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

      " Create a cache file if not yet exists
      let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
      if !( filereadable(cachefile) && a:items == readfile(cachefile) )
         call writefile(a:items, cachefile)
      endif
      if !filereadable(cachefile)
         return []
      endif

      " a:mmode is currently ignored. In the future, we should probably do
      " something about that. the matcher behaves like "full-line".
      let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
      if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
         let cmd = cmd.'--no-dotfiles '
      endif
      let cmd = cmd.a:str

      return split(system(cmd), "\n")

   endfunction
end

" CtrlP auto cache clearing.
" ----------------------------------------------------------------------------
"function! SetupCtrlP()
  "if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    "augroup CtrlPExtension
      "autocmd!
      ""autocmd FocusGained  * CtrlPClearCache
      "autocmd BufWritePost * CtrlPClearCache
    "augroup END
  "endif
"endfunction

"if has("autocmd")
  "autocmd VimEnter * :call SetupCtrlP()
"endif

" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0

"set wildignore+=*/.git/*,*.class,tmp/*,coverage/*

" Control settings for python highlighting
let python_highlight_all = 1
let python_slow_sync = 1

" Control haskell syntastic settings
map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Control supertab settings for haskell
"let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

"if has("gui_running")
   "imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
"else " no gui
   "if has("unix")
      "inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
   "endif
"endif
"let g:haskellmode_completion_ghc = 1
"autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
   syntax on
   set hlsearch
endif

if $TERM == 'screen'
   set t_Co=256
endif

if &t_Co >= 256
   set background=dark
   colors idlefingers256
else
   set background=dark
   colors default
endif

runtime macros/matchit.vim

" Make windows use a sensible shell for vim
"set shell=powershell

" Only do this part when compiled with support for autocommands.
if has("autocmd")

   " Enable file type detection.
   " Use the default filetype settings, so that mail gets 'tw' set to 72,
   " 'cindent' is on in C files, etc.
   " Also load indent files, to automatically do language-dependent indenting.
   filetype plugin indent on

   " Put these in an autocmd group, so that we can delete them easily.
   augroup vimrcEx
      au!
      autocmd BufWritePre * :%s/\s\+$//e
      autocmd BufEnter Gemfile set filetype=ruby
      autocmd BufEnter .gitconfig_local set filetype=gitconfig
      autocmd FileType haskell,ruby,yaml,jade,javascript,coffee,coffeescript,scala,html.handlebars setlocal ts=2 sw=2
      autocmd FileType java setlocal ts=2 sw=2 tw=100
      autocmd FileType xml,xhtml,html,htm,html.handlebars setlocal autoindent
      autocmd FileType xml,xhtml,html,htm,html.handlebars let b:delimitMate_matchpairs="(:),{:},[:]"
      autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
      au BufRead,BufNewFile SCons* set filetype=python
      au BufRead,BufNewFile *.hamlc set filetype=haml

      au FileType lisp let b:delimitMate_quotes="\""

      "au BufWinEnter * let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
      "au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

      " When editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      autocmd BufReadPost *
               \ if line("'\"") > 0 && line("'\"") <= line("$") |
               \   exe "normal g`\"" |
               \ endif

      au FilterWritePre * if &diff | set background=light | colorscheme peaksea | endif
   augroup END

else

   set autoindent " always set autoindenting on

endif " has("autocmd")

set diffopt=filler,context:17,iwhite
set diffexpr=MyDiff()
function! MyDiff()
   let opt = ''
   if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
   if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
   silent execute '!diff -a ' . opt . '"' . v:fname_in . '" "' . v:fname_new . '" > "' . v:fname_out . '"'
endfunction

