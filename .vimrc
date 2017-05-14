set nocompatible
:let mapleader = "\<Space>"

"Charset, Line Ending
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8
set ffs=unix,dos,mac

" #### dein.vim start ####
" dein.vim のホームディレクトリ
let s:dein_dir = expand('$HOME/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" rtp に加える
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" plugin load
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " TOMLファイルを読み込む
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  if dein#check_install()
    call dein#install()
  endif

  call dein#end()
  call dein#save_state()
endif
" #### dein.vim end ####

filetype plugin indent on
colorscheme hybrid

" Plugin ------
" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*'
" NeoComplCache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

"autocmd FileType python setlocal omnifunc=jedi#completions
"let g:jedi#completions_enabled = 0
"let g:jedi#auto_vim_configuration = 0
"if !exists('g:neocomplete#force_omni_input_patterns')
"    let g:neocomplete#force_omni_input_patterns = {}
"endif
"
"g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'

" Unite
nnoremap [Unite] <Nop>
nmap <leader>u [Unite]
nnoremap [Unite]b   :<C-u>Unite buffer<CR>
nnoremap [Unite]mr  :<C-u>Unite file_mru buffer<CR>
nnoremap [Unite]y   :<C-u>Unite history/yank<CR>
nnoremap [Unite]gr  :<C-u>Unite grep:.<CR>

" VimFiler
:let g:vimfiler_as_default_explorer = 1
nnoremap <C-e> :VimFilerBufferDir<CR>
nnoremap <leader><C-e> :VimFilerBufferDir -tab<CR>

" vim-easy-align
vmap ga <Plug>(EasyAlign)
" ---- Plugin

" Key mappings
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap Y y$
nnoremap <ESC><ESC> :noh<CR><ESC>
nmap <F6> <ESC>a<C-R>=strftime("%Y/%m/%d (%a) %H:%M:%S")
"Open .vimrc with space + dot
nnoremap <Space>. :<C-u>tabedit $MYVIMRC<CR>
nnoremap <Space>, :<C-u>tabedit $MYGVIMRC<CR>
nnoremap <Space>/ :<C-u>tabedit $HOME/.vim/rc/dein.toml<CR>
nnoremap <Space>? :<C-u>tabedit $HOME/.vim/rc/dein_lazy.toml<CR>

" Move
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescrolloff=16
set sidescroll=1

" File
set confirm
set nobackup
set noswapfile
set undodir=$HOME/.vim/undo
set undofile
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden " バッファが編集中でもその他のファイルを開けるように
colorscheme hybrid
syntax enable
set background=dark

" Search/Replace
set incsearch
set ignorecase
set smartcase
set wrapscan
set gdefault
set hlsearch

" View
set cmdheight=2
set columns=85
set nocursorline
set laststatus=2
set list
set listchars=tab:>.,trail:_,eol:$
set matchpairs=(:),{:},<:>,[:]
set matchtime=3
set number
set ruler
set showcmd
set showmatch
set title
hi ZenkakuSpace gui=underline guibg=DarkBlue cterm=underline ctermfg=LightBlue " 全角スペースの定義
match ZenkakuSpace /　/ " 全角スペースの色を変更


" Input
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set textwidth=0

" Operate
set clipboard=unnamed,unnamedplus
set mouse=a
set history=1000

" for Python ---------------------------
filetype plugin on
autocmd Filetype python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=4 shiftwidth=4 softtabstop=0

