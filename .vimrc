set nocompatible
let mapleader = "\<Space>"

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

  " プラグイン設定はすべてTOMLファイルに記載
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

filetype plugin indent on
syntax enable
colorscheme hybrid
" #### dein.vim end ####

" Key mappings
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap Y y$
nnoremap <ESC><ESC> :noh<CR><ESC>
nmap <F6> <ESC>a<C-R>=strftime("%Y/%m/%d (%a) %H:%M:%S")
nnoremap <leader>r :redraw!<CR>
nnoremap <M-n> :tabnew<CR>
nnoremap <M-h> gT
nnoremap <M-l> gt
"Open .vimrc with space + dot
nnoremap <Space>. :<C-u>tabedit $HOME/.vimrc<CR>
nnoremap <Space>, :<C-u>tabedit $MYGVIMRC<CR>
nnoremap <Space>> :<C-u>tabedit $MYVIMRC<CR>
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
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set textwidth=0

" Operate
set clipboard=unnamed,unnamedplus
set mouse=a
set history=1000

" for Markup ---------------------------
augroup MyML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype eruby inoremap <buffer> </ </<C-x><C-o>
augroup END

" for Python ---------------------------
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

