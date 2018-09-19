" Change leader mapping
let g:mapleader = ','
let g:maplocalleader = '\'

"Open .vimrc with space + dot
nnoremap <Space>. :<C-u>tabedit $HOME/.vimrc<CR>
nnoremap <Space>/ :<C-u>tabedit $HOME/.vim/rc/dein.toml<CR>
nnoremap <Space>? :<C-u>tabedit $HOME/.vim/rc/dein_lazy.toml<CR>

" Multi line move
inoremap jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
noremap <Down> gj
noremap <Up> gk

nnoremap Y y$
nnoremap <Space>h :noh<CR>
nmap <F6> <ESC>a<C-R>=strftime("%Y/%m/%d (%a) %H:%M:%S")
nnoremap <Space>r :redraw!<CR>
nnoremap <M-n> :tabnew<CR>
nnoremap <M-h> gT
nnoremap <M-l> gt

" Insert mode emacs like move
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <C-o>^
inoremap <C-e> <End>
inoremap <C-d> <Del>

" Change tab width
nnoremap ts2 :<C-u>setl shiftwidth=2 softtabstop=2<CR>
nnoremap ts4 :<C-u>setl shiftwidth=4 softtabstop=4<CR>
nnoremap ts8 :<C-u>setl shiftwidth=8 softtabstop=8<CR>

" Disable close window
nnoremap <C-w>c <Nop>

" Resize window
noremap <C-w>> 10<C-w>>
noremap <C-w>< 10<C-w><
noremap <C-w>+ 10<C-w>+
noremap <C-w>- 10<C-w>-

" Search yank string
nnoremap <Space>sy /<C-r>"<CR>
" Search of under cousor
vnoremap * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" Indent keybind for shutcut
nnoremap > >>
nnoremap < <<

" Paste explicitly yanked text
nnoremap <Space>p "0p
vnoremap <Space>p "0p

" Paste clipboard text
nnoremap <Space>c "*p
vnoremap <Space>c "*p

" Not yank is delete operation
nnoremap x "_x

" Jump quickfix
nnoremap <C-p> :<C-u>cp<CR>
nnoremap <C-n> :<C-u>cn<CR>
nnoremap [f :<C-u>cp<CR>
nnoremap ]f :<C-u>cn<CR>
nnoremap [F :<C-u>cfirst<CR>
nnoremap ]F :<C-u>clast<CR>

" Toggle quickfix
if exists('g:__QUICKFIX_TOGGLE_jfklds__')
    finish
endif
let g:__QUICKFIX_TOGGLE_jfklds__ = 1

function! ToggleQuickfix()
    let l:nr = winnr('$')
    cwindow
    let l:nr2 = winnr('$')
    if l:nr == l:nr2
        cclose
    endif
endfunction
nnoremap <script> <silent> <Space>q :call ToggleQuickfix()<CR>

" Jump locationlist
nnoremap [t :<C-u>lp<CR>
nnoremap ]t :<C-u>ln<CR>
nnoremap [T :<C-u>lfirst<CR>
nnoremap ]T :<C-u>llast<CR>

" Toggle locationlist
if exists('g:__LOCATIONLIST_TOGGLE_jfklds__')
    finish
endif
let g:__LOCATIONLIST_TOGGLE_jfklds__ = 1

function! ToggleLocationlist()
    let l:nr = winnr('$')
    lwindow
    let l:nr2 = winnr('$')
    if l:nr == l:nr2
        lclose
    endif
endfunction
nnoremap <script> <Space>t :call ToggleLocationlist()<CR>


" Grep astarisk text
nnoremap <Space>gg :<C-u>grep '<C-r>=<SID>convert_pattern(@/)<CR>'<CR>
nnoremap <Space>gl :<C-u>grep '<C-r>=<SID>convert_pattern(@/)<CR>' %<CR>
function! s:convert_pattern(pat)
    let chars = split(a:pat, '\zs')
    let len = len(chars)
    let pat = ''
    let i = 0
    while i < len
        let ch = chars[i]
        if ch ==# '\'
            let nch = chars[i + 1]
            if nch =~# '[vVmM<>%]'
                let i += 1
            elseif nch ==# 'z'
                let i += 2
            elseif nch ==# '%'
                let i += 2
                let pat .= chars[i]
            else
                let pat .= ch
            endif
        else
            let pat .= ch
        endif
        let i += 1
    endwhile
    return escape(pat, '\')
endfunction

" Command line mode mapping emacs like
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
" cnoremap <C-n> <Down>
" cnoremap <C-p> <Up>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>


" Rename current file
function! RenameFile() abort
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name !=# '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
noremap <Space>R :call RenameFile()<cr>

" Toggle relativenumber or norelativenumber
function! ToggleRelativenumber() abort
  if &relativenumber == 1
     setlocal norelativenumber
  else
     setlocal relativenumber
  endif
endfunction
nnoremap <Space>n :call ToggleRelativenumber()<cr>

" let g:toggle_window_size = 0
" function! ToggleWindowFullSize()
"   if g:toggle_window_size == 1
"     exec "normal \<C-w>="
"     let g:toggle_window_size = 0
"   else
"     exec ':resize'
"     exec ':vertical resize'
"     let g:toggle_window_size = 1
"   endif
" endfunction
" nnoremap <Space>u :<C-u>call ToggleWindowFullSize()<CR>

" Toggle wrap or unwrap
function! ToggleWrap()
  if &wrap
    set nowrap
  else
    set wrap
  endif
endfunction
nnoremap \r :call ToggleWrap()<CR>

" Toggle wrap or unwrap
function! ToggleExpandTab()
  if &expandtab
    set noexpandtab
  else
    set expandtab
  endif
endfunction
nnoremap \t :call ToggleExpandTab()<CR>
