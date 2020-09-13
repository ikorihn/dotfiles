"Vi互換をオフ
if &compatible
    set nocompatible
endif

let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Load python3
let g:python3_host_prog = expand('$HOME/.pyenv/shims/python')

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

  call dein#load_toml('~/.vim/rc/dein.toml',          {'lazy': 0})
  call dein#load_toml('~/.vim/rc/dein_lazy.toml',     {'lazy': 1})
  call dein#load_toml('~/.vim/rc/dein_syntax.toml',   {'lazy': 1})
  call dein#load_toml('~/.vim/rc/dein_neo.toml',      {'lazy': 1})
  call dein#load_toml('~/.vim/rc/dein_python.toml',   {'lazy': 1})
  call dein#load_toml('~/.vim/rc/dein_go.toml',       {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

runtime! rc/options.rc.vim
runtime! rc/filetype.rc.vim
runtime! rc/mappings.rc.vim

" Colors
set t_Co=256
set background=dark
syntax on
filetype plugin indent on
colorscheme wombat256mod
