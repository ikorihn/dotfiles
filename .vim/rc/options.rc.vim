set shell=bash\ -l

" File encoding
if !exists ('g:encoding_set') || !has('nvim')
    set encoding=utf-8
    set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp
    set fileencoding=utf-8
    let g:encoding_set=1
endif
scriptencoding utf-8

" Don't create swp file
set backup
set backupdir=$HOME/.vim/backup
set noswapfile
set undodir=$HOME/.vim/undo
set undofile

set autochdir

" Show column number
set number

" Long text
set wrap
set textwidth=0
set colorcolumn=256

"Move
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]

" Highlight cursor line
set cursorline
set cursorcolumn

" Invisible stirng
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲,trail:~

" Don't unload buffer when it is abandones
set hidden

" New load buffer is use open
set switchbuf=useopen

" Smart insert tab setting.
set smarttab
set expandtab
set autoindent
set smartindent
set softtabstop=2
set shiftwidth=2
set shiftround
set tabstop=2
set scrolloff=15

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways
" Adjust window size of preview and help.
set previewheight=8
set helpheight=12

" show tab line
set showtabline=2

" Replace incremental
if exists('&inccommand')
  set inccommand=split
endif

" Search
set hlsearch
set ignorecase
set smartcase
set incsearch
set wrapscan

" Share clipborad with system
set clipboard+=unnamedplus

" Disable fold
set nofoldenable

" Use extend grep
if executable('rg')
    let &grepprg = 'rg --vimgrep --hidden'
    set grepformat=%f:%l:%c:%m
elseif executable('pt')
    let &grepprg = 'pt --nocolor --nogroup --column'
    set grepformat=%f:%l:%c:%m
endif

" jq command
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction

" Number of characters to apply syntax per line
set synmaxcol=512

" Disable sql omni complete
let g:omni_sql_no_default_maps = 1

" View
set cmdheight=2
set laststatus=2    "ステータスラインを常に表示する
set matchpairs=(:),{:},<:>,[:]
set matchtime=1     "showmatchの表示時間
set ruler           "座標を表示する
set showcmd         "入力中のコマンドを表示する
set showmatch       "閉じ括弧の入力時に対応する括弧を表示する
set title           "編集中のファイル名を表示する
hi ZenkakuSpace gui=underline guibg=DarkBlue cterm=underline ctermfg=LightBlue " 全角スペースの定義
match ZenkakuSpace /　/ " 全角スペースの色を変更

