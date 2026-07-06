" Tab setting for file type
augroup MyTabStop
    autocmd!
    autocmd BufNewFile,BufRead *.rhtml     setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html      setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js        setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css       setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.scss      setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.md        setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.scala     setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb        setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.erb       setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.{c,cpp,h} setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.py        setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.go        setlocal noexpandtab tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.vim       setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead Makefile    setlocal noexpandtab
    autocmd BufNewFile,BufRead *.yml       setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yaml      setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.toml      setlocal tabstop=4 shiftwidth=4
    autocmd BufRead,BufNewFile *.scss      setlocal filetype=scss
augroup END

augroup MyGitSpellCheck
    autocmd!
    autocmd FileType gitcommit setlocal spell
augroup END

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
