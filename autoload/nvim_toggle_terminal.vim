""
" @public
" Toggle terminal buffer or create new one if there is none.
"
" nnoremap <silent> <C-z> :call nvim-toggle-terminal#ToggleTerminal()<Enter>
" tnoremap <silent> <C-z> <C-\><C-n>:call nvim-toggle-terminal#ToggleTerminal()<Enter>
""
function! nvim_toggle_terminal#ToggleTerminal() abort
  if !has('nvim')
    return v:false
  endif

  let s:default_terminal = {
    \ 'loaded': v:null,
    \ 'termbufferid': v:null
  \ }

  if !exists('g:terminal')
    let g:terminal = copy(s:default_terminal)
  endif

  function! g:terminal.on_exit(jobid, data, event)
    silent execute 'buffer' w:originbufferid
    let g:terminal = copy(s:default_terminal)
  endfunction

  " If Terminal not open
  if !g:terminal.loaded
    let s:originbufferid = bufnr('')

    enew | call termopen(&shell, g:terminal)
    set bufhidden=hide
    set nobuflisted
    let g:terminal.loaded = v:true
    let g:terminal.termbufferid = bufnr('')
    let w:originbufferid = s:originbufferid

    return v:true
  endif

  if g:terminal.termbufferid ==# bufnr('')
    " Go back to origin buffer if current buffer is terminal.
    silent execute 'buffer' w:originbufferid
  else
    " Go to terminal buffer if is loaded but not current buffer
    let s:originbufferid = bufnr('')
    silent execute 'buffer' g:terminal.termbufferid
    let w:originbufferid = s:originbufferid
  endif
endfunction

function! nvim_toggle_terminal#TerminalOptions()
  silent au BufEnter <buffer> startinsert!
  silent au BufLeave <buffer> stopinsert!
  setlocal listchars= nonumber norelativenumber
  startinsert!
endfunction

