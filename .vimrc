"Vi互換をオフ
if &compatible
    set nocompatible
endif
"set shellslash
"
"Charset, Line Ending
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8
set ffs=unix,dos,mac

" #### dein.vim start ####
" dein.vim のホームディレクトリ
let s:dein_dir = expand('~/.cache/vim/dein')
let s:dein_repo_dir = s:dein_dir
                 \ .'/repos/github.com/Shougo/dein.vim'

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
let mapleader = "\<Space>"
inoremap jj <ESC>
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
nnoremap <Space>/ :<C-u>tabedit $HOME/.vim/rc/dein.toml<CR>
nnoremap <Space>? :<C-u>tabedit $HOME/.vim/rc/dein_lazy.toml<CR>
" wrapを切り替える
function! ToggleWrap()
  if &wrap
    set nowrap
  else
    set wrap
  endif
endfunction
nnoremap <Leader>w :call ToggleWrap()<CR>
 

" Move
set backspace=indent,eol,start
set scrolloff=8
set sidescroll=1
set sidescrolloff=16
set whichwrap=b,s,h,l,<,>,[,]

" File
set autoread " 編集中のファイルが変更されたら自動で読み直す
set background=dark
set confirm
set hidden " バッファが編集中でもその他のファイルを開けるように
set nobackup
set noswapfile
set undodir=$HOME/.vim/undo
set undofile

" Search/Replace
set incsearch    "インクリメンタルサーチを行う
set hlsearch     "検索結果をハイライトする
set ignorecase   "検索時に文字の大小を区別しない
set smartcase    "検索時に大文字を含んでいたら大小を区別する
set wrapscan     "検索をファイルの先頭へループする

" View
set cmdheight=2
set cursorline      "カーソル行のハイライト
set laststatus=2    "ステータスラインを常に表示する
set list
set listchars=tab:>.,trail:_,eol:$
set matchpairs=(:),{:},<:>,[:]
set matchtime=1     "showmatchの表示時間
set number          "行番号を表示する
set ruler           "座標を表示する
set showcmd         "入力中のコマンドを表示する
set showmatch       "閉じ括弧の入力時に対応する括弧を表示する
set statusline=%F%m%r%h%w%=[%{&ff}][%{&fenc}][%Y][%v,%l/%L]
set title           "編集中のファイル名を表示する
hi ZenkakuSpace gui=underline guibg=DarkBlue cterm=underline ctermfg=LightBlue " 全角スペースの定義
match ZenkakuSpace /　/ " 全角スペースの色を変更

" Input
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2
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

" for Binary ---------------------------
" バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin ファイルを開くと発動します）
" http://d.hatena.ne.jp/rdera/20081022/1224682665
augroup BinaryXXD
  autocmd!
  " autocmd BufReadPre  *.bin let &bin =1
  autocmd BufReadPost * if &bin && &filetype != 'xxd'
  autocmd BufReadPost * silent %!xxd -g 1
  "autocmd BufReadPost * %!xxd -r
  autocmd BufReadPost * set ft=xxd noeol 
  autocmd BufReadPost * silent %s///g
  autocmd BufReadPost * endif

  autocmd BufWritePre * if &bin
  autocmd BufWritePre * %!xxd -r
  autocmd BufWritePre * endif

  autocmd BufWritePost * if &bin
  autocmd BufWritePost * silent %!xxd -g 1
  autocmd BufWritePost * silent %s///g
  autocmd BufWritePost * endif
augroup END


