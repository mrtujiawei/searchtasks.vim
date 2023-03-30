" searchtasks.vim - Search TODO and FIXME tasks
" Maintainer:   Gilson Filho <http://gilsondev.com>
" Version:      1.0

if exists("g:searchtasks_loaded") || &cp || v:version < 700
  finish
endif

let g:searchtasks_loaded=1

if !exists("g:searchtasks_list")
  let g:searchtasks_list=["TODO", "FIXME"]
endif

" Search tasks {{{
function s:SearchTasks(...)
  if a:0 == 0
    echo "Directory is required (e.g: SearchTasks **/*.c)."
    return ''
  endif

  execute 'vimgrep /\(' . join(g:searchtasks_list, '\|') . '\)/gj ' . join(a:000)

  " show results
  cwindow
endfunction
" }}}


" Search tasks with :grep {{{
function s:SearchTasksGrep(...)
  if a:0 == 0
    echo "Directory is required (e.g: SearchTasksGrep **/*.c)."
    return ''
  endif

  let l:flag = 1
  for task in g:searchtasks_list
    for directory in a:000
      if l:flag
        execute 'silent! :grep ' . task . ' ' . directory
        let l:flag = 0
      else
        execute 'silent :grepadd ' . task . ' ' . directory
      endif
    endfor
  endfor

  " show results
  cwindow
endfunction
" }}}

if exists("grepadd") || v:version > 700
  command -nargs=* -complete=file SearchTasksGrep call s:SearchTasksGrep('<args>')
endif

command -nargs=* -complete=file SearchTasks call s:SearchTasks('<args>')
" vim:set sw=2 sts=2:
