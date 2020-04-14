""
" @public
" Toggle terminal buffer or create new one if there is none.
"
" nnoremap <silent> <C-z> :call mappings#toggleterminal()<Enter>
" tnoremap <silent> <C-z> <C-\><C-n>:call mappings#toggleterminal()<Enter>
""
function! nvim_toggle_terminal#ToggleTerminal() abort
  if !has('nvim')
    return v:false
  endif

  let s:default_terminal = {
    \ 'loaded': v:null,
    \ 'termbufferid': v:null,
    \ 'termwindowid': v:null,
    \ 'originbufferid': v:null
  \ }

  if !exists('g:terminal')
    let g:terminal = copy(s:default_terminal)
  endif

  function! g:terminal.on_exit(jobid, data, event)
    silent execute 'buffer' g:terminal.originbufferid
    let g:terminal = copy(s:default_terminal)
  endfunction

  " If Terminal not open
  if !g:terminal.loaded
    let g:terminal.originbufferid = bufnr('')

    enew | call termopen(&shell, g:terminal)
    set bufhidden=hide
    set nobuflisted
    let g:terminal.loaded = v:true
    let g:terminal.termbufferid = bufnr('')

    return v:true
  endif

  if g:terminal.termbufferid ==# bufnr('')
    " Go back to origin buffer if current buffer is terminal.
    silent execute 'buffer' g:terminal.originbufferid
  else
    " Go to terminal buffer if is loaded but not current buffer
    let g:terminal.originbufferid = bufnr('')
    silent execute 'buffer' g:terminal.termbufferid
  endif
endfunction

function! nvim_toggle_terminal#TerminalOptions()
  silent au BufEnter <buffer> startinsert!
  silent au BufLeave <buffer> stopinsert!
  setlocal listchars= nonumber norelativenumber
  startinsert!
endfunction

