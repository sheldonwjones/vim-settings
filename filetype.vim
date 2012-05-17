" :help new-filetype
if exists("did_load_filetypes")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

augroup filetypedetect
    au! BufNewFile,BufRead *.ini set ft=cfg
    au! BufRead,BufNewFile *.txx,*.ino setf cpp
    au! BufRead,BufNewFile *.mako setf mako.html
    au! BufRead,BufNewFile SConstruct setf python
    au! BufRead,BufNewFile SConscript setf python
    au! BufRead,BufNewFile *.jt,*.jinja2 setf htmljinja
    au! BufRead,BufNewFile *.as setf actionscript
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
