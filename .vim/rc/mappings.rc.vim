let mapleader = ","

" Multi line move
inoremap jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
noremap <Down> gj
noremap <Up> gk
nnoremap Y y$

" Dangerous key
nnoremap ZQ    <Nop>
nnoremap ZZ    <Nop>
" Ex mode
nnoremap gQ    gq
inoremap <C-C> <Esc>

" Change tab width
nnoremap ts2 :<C-u>setl shiftwidth=2 softtabstop=2<CR>
nnoremap ts4 :<C-u>setl shiftwidth=4 softtabstop=4<CR>
nnoremap ts8 :<C-u>setl shiftwidth=8 softtabstop=8<CR>
function! ToggleExpandTab()
    if &expandtab
        set noexpandtab
    else
        set expandtab
    endif
endfunction
nnoremap tst :<C-u>call ToggleExpandTab()<CR>

" Tab
nnoremap tn :tabnew<CR>

" Indent keybind for shutcut
nnoremap > >>
nnoremap < <<

" Register
"vnoremap x "_x
"nnoremap x "_x
"vnoremap s "_s
"nnoremap s "_s
vnoremap <Leader>p "0p
nnoremap <Leader>p "0p
vnoremap <Leader>P "0P
nnoremap <Leader>P "0P

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
nnoremap <script> <silent> <Leader>q :call ToggleQuickfix()<CR>

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
nnoremap <script> <Leader>t :call ToggleLocationlist()<CR>

" Grep astarisk text
nnoremap <Leader>gg :<C-u>grep '<C-r>=<SID>convert_pattern(@/)<CR>'<CR>
nnoremap <Leader>gl :<C-u>grep '<C-r>=<SID>convert_pattern(@/)<CR>' %<CR>
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

" xmllint command
command! -nargs=? XmlFormat call Xmllint('--format')
function! Xmllint(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! xmllint " . l:arg . " % "
endfunction

" util
nmap <F6> <ESC>a<C-R>=strftime("%Y-%m-%dT%H:%M:%S")
command! Q quit

" URL encode/decode selection
vnoremap <leader>en :!python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'<cr>
vnoremap <leader>de :!python -c 'import sys,urllib;print urllib.unquote(sys.stdin.read().strip())'<cr>

" csvファイルハイライト「:Csvhl [数値]」 と打つと、csvファイルで[数値]カラム目のハイライトをしてくれる
function! CSVH(x)
    execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
    execute 'normal ^'.a:x.'f,'
endfunction
command! -nargs=1 Csvhl :call CSVH(<args>)
" 「:Csvs」と打つと、現在のカラムをハイライトしてくれる
command! Csvs :call CSVH(strlen(substitute(getline('.')[0:col('.')-1], "[^,]", "", "g")))
" Csv系のコマンドのハイライトを消す
command! Csvn execute 'match none'

" csvのn列目を取り出す
function! GetCsvCol(n)
    let linenum = 1
    for aline in getbufline(".",1,"$")
        call setline(linenum,split(aline,",")[a:n])
        let linenum=linenum+1
    endfor
endfunction
