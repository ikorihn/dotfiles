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
  let s:nvim_toml = g:rc_dir . '/nvim.toml'
  call dein#load_toml(s:toml,      {'lazy': 0})
  if has("nvim")
    call dein#load_toml(s:nvim_toml, {'lazy': 1})
  else
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
  endif

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

" #### Plugin ####

" -- NeoSnippet --
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" -- Unite --
nnoremap [Unite] <Nop>
nmap <leader>u [Unite]
nnoremap [Unite]b   :<C-u>Unite buffer<CR>
nnoremap [Unite]mr  :<C-u>Unite file_mru buffer<CR>
nnoremap [Unite]y   :<C-u>Unite history/yank<CR>
nnoremap [Unite]gr  :<C-u>Unite grep:.<CR>

" -- VimFiler --
let g:vimfiler_as_default_explorer = 1
nnoremap <C-e> :VimFilerBufferDir -explorer -find<CR>
"let g:vimfiler_edit_action = 'tabopen'

" -- vim-easy-align --
vmap ga <Plug>(EasyAlign)

" -- Previm --
let g:previm_open_cmd = ''
nnoremap [previm] <Nop>
nmap <Space>p [previm]
nnoremap <silent> [previm]o :<C-u>PrevimOpen<CR>
nnoremap <silent> [previm]r :call previm#refresh()<CR>
" #### Plugin ####

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
nnoremap <Space>_ :<C-u>tabedit $HOME/.vim/rc/nvim.toml<CR>

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
autocmd Filetype python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=4 shiftwidth=4 softtabstop=0

