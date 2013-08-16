inoremap " "<esc>:call <SID>ScopeComplete()<cr>a
inoremap ' '<esc>:call <SID>ScopeComplete()<cr>a
inoremap ( (<esc>:call <SID>ScopeComplete()<cr>a
inoremap ) )<esc>:call <SID>ScopeComplete()<cr>a
inoremap { {<esc>:call <SID>ScopeComplete()<cr>a
inoremap } }<esc>:call <SID>ScopeComplete()<cr>a
inoremap [ [<esc>:call <SID>ScopeComplete()<cr>a
inoremap ] ]<esc>:call <SID>ScopeComplete()<cr>a
inoremap > ><esc>:call <SID>ScopeComplete()<cr>a
inoremap < <<esc>:call <SID>ScopeComplete()<cr>a
inoremap <BS> <esc>:call <SID>ScopeDelete()<CR>a<BS>
inoremap <CR> <esc>:call <SID>ScopeEnter()<CR>a<CR>

let s:scope_chs = {'(' : ')', '{' : '}', '[' : ']', '"' : '"', '''' : '''', '<' : '>',}


" Toggle scope completion by using either <leader>sc or :ScopeCompleteToggle
nnoremap <leader>sc :call <SID>ScopeCompleteToggle()<cr>
command! ScopeCompleteToggle :call <SID>ScopeCompleteToggle()

" Default to off. To turn on by default add "let g:scope_complete=1"
if !exists("g:scope_complete")
  let g:scope_complete = 0
endif

" When an opening character is typed, automatically insert a closing character
" after it and place the cursor between the opening and closing characters.
" If the user types a closing character before the automatically inserted
" closing character then remove the automatically inserted character.
function! s:ScopeComplete()
  if g:scope_complete
    " opening chars as keys and closing chars as values
    let pos = getpos('.')
    let line = getline(pos[1])
    let ch = line[pos[2] - 1]
    let next_ch = line[pos[2]]
    echom "ScopeComplete() called for: " . ch
    " if the ch is a closing ch and is the same as the next ch"
    if index(values(s:scope_chs), ch) >= 0 && ch ==# next_ch
      " delete the automatically inserted closing ch
      execute "normal! x"
      " if the ch is an opening ch
    elseif has_key(s:scope_chs, ch)
      " insert the corresponding closing ch and move cursor
      " between the opening and closing ch's
      execute "normal! a" . get(s:scope_chs, ch, '') . "\<esc>h"
    endif
  endif
endfunction

" Toggle on and off
function! s:ScopeCompleteToggle()
  if g:scope_complete
    let g:scope_complete = 0
  else
    let g:scope_complete = 1
  endif
endfunction

" If called when the cursor is between and opening and closing character, both
" characters will be removed. e
function! s:ScopeDelete()
  let pos = getpos('.')
  let line = getline(pos[1])
  let ch = line[pos[2] - 1]
  let next_ch = line[pos[2]]
  "execute "normal! %"
  if has_key(s:scope_chs, ch) && get(s:scope_chs, ch, '') ==# next_ch
    execute "normal! x"
  endif
endfunction

function! s:GetLastCharAbove(line)
  if a:line <=# 1
    return ''
  else
    let line_abv = getline(a:line - 1)
    return line_abv[strlen(line_abv) - 1]
  endif
endfunction

function! s:GetFirstCharBelow(line)
  if a:line >=# line('$')
    return '&'
  else
    let line_blw = getline(a:line + 1)
    return line_blw[1]
  endif
endfunction

function! s:ScopeEnter()
  let pos = getpos('.')
  let line = getline(pos[1])
  let ch = line[pos[2] - 1]
  let next_ch = line[pos[2]]
  if has_key(s:scope_chs, ch) && next_ch ==# get(s:scope_chs, ch, '')
    echom "success!"
    execute "normal! a\<cr>\<esc>k$"
  endif
endfunction

