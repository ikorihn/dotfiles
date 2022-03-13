"Vi互換をオフ
if &compatible
    set nocompatible
endif

language en_US.UTF-8

let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Load python3
let g:python3_host_prog = expand('$HOME/.pyenv/shims/python')

runtime! rc/options.rc.vim
runtime! rc/filetype.rc.vim
runtime! rc/mappings.rc.vim

if exists('g:vscode')
  call plug#begin(stdpath('data') . '/plugged')
  Plug 'junegunn/vim-easy-align'
  Plug 'asvetliakov/vim-easymotion'
  call plug#end()

  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)

  finish
endif

" Load dein.
let s:dein_dir = expand('$CACHE/vim/dein')
let s:dein_repo_dir = s:dein_dir .'/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml('~/.vim/rc/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/rc/dein_coc.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/rc/dein_lazy.toml', {'lazy': 1})
  call dein#load_toml('~/.vim/rc/dein_programming.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" "プラグインアップデート
" let g:dein#install_github_api_token = expand('$GITHUB_ACCESS_TOKEN_DEIN')
" call dein#check_update(v:true)

" プラグイン削除
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

" Colors
set t_Co=256
set background=dark
syntax on
filetype plugin indent on
colorscheme gruvbox-material
